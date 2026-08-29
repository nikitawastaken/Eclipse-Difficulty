-- Tweak hostage rescue conditions
function CivilianLogicFlee.rescue_SO_verification(ignore_this, params, unit)
	if unit:movement():cool() then
		return false
	end

	if not unit:base():char_tweak().rescue_hostages then
		return false
	end

	local data = params.logic_data
	if data.team.foes[unit:movement():team().id] then
		return false
	end

	local logic_data = unit:brain()._logic_data
	if not logic_data or not logic_data.tactics or logic_data.tactics.rescue then
		return true
	end
end

-- Workaround for civilians being unresponsive when intimidated
function CivilianLogicFlee._delayed_intimidate_clbk(ignore_this, params)
	local data = params[1]
	local amount = params[2]
	local aggressor_unit = params[3]
	local my_data = data.internal_data

	CopLogicBase.on_delayed_clbk(my_data, my_data.delayed_intimidate_id)

	my_data.delayed_intimidate_id = nil

	if not alive(aggressor_unit) then
		return
	end

	CopLogicBase.identify_attention_obj_instant(data, aggressor_unit:key())

	if not CivilianLogicIdle.is_obstructed(data, aggressor_unit) then
		if not my_data.obstructed_t then
			my_data.obstructed_t = TimerManager:game():time()
		elseif TimerManager:game():time() >= my_data.obstructed_t + 1 then
			my_data.obstructed_t = nil
			data.unit:brain():action_request({
				clamp_to_graph = true,
				variant = "panic",
				body_part = 1,
				type = "act",
			})
		end
		return
	end

	data.unit:brain():set_objective({
		type = "surrender",
		amount = amount,
		aggressor_unit = aggressor_unit,
	})
end

-- Remove civilians as soon as they reached their flee point instead of waiting for the next logic update
Hooks:PostHook(CivilianLogicFlee, "action_complete_clbk", "sh_action_complete_clbk", function(data, action)
	if action:type() ~= "walk" then
		return
	end

	local coarse_path = data.internal_data.coarse_path
	local coarse_path_index = data.internal_data.coarse_path_index
	if not coarse_path or coarse_path_index ~= #coarse_path then
		return
	end

	data.internal_data.next_action_t = 0
	CivilianLogicFlee.update(data)
end)

-- Increase the delay before a civilian may call the police. Big function override, I know.
Hooks:OverrideFunction(CivilianLogicFlee, "enter", function(data, new_logic_name, enter_params)
	CopLogicBase.enter(data, new_logic_name, enter_params)
	data.unit:brain():cancel_all_pathing_searches()

	local old_internal_data = data.internal_data
	local my_data = {
		unit = data.unit
	}

	data.internal_data = my_data
	my_data.detection = data.char_tweak.detection.cbt

	data.unit:brain():set_update_enabled_state(false)

	local key_str = tostring(data.key)

	managers.groupai:state():register_fleeing_civilian(data.key, data.unit)

	my_data.panic_area = managers.groupai:state():get_area_from_nav_seg_id(data.unit:movement():nav_tracker():nav_segment())

	CivilianLogicFlee.reset_actions(data)

	if data.objective then
		if data.objective.alert_data then
			CivilianLogicFlee.on_alert(data, data.objective.alert_data)

			if my_data ~= data.internal_data then
				return
			end

			if data.unit:anim_data().react_enter and not data.unit:anim_data().idle then
				my_data.delayed_post_react_alert_id = "postreact_alert" .. key_str

				CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_post_react_alert_id, callback(CivilianLogicFlee, CivilianLogicFlee, "post_react_alert_clbk", {
					data = data,
					alert_data = clone(data.objective.alert_data)
				}), TimerManager:game():time() + math.lerp(4, 8, math.random()))
			end
		elseif data.objective.dmg_info then
			CivilianLogicFlee.damage_clbk(data, data.objective.dmg_info)
		end
	end

	data.unit:movement():set_stance(data.is_tied and "cbt" or "hos")
	data.unit:movement():set_cool(false)

	if my_data ~= data.internal_data then
		return
	end

	CivilianLogicFlee._chk_add_delayed_rescue_SO(data, my_data)

	if data.objective and data.objective.was_rescued then
		data.objective.was_rescued = nil

		if CivilianLogicFlee._get_coarse_flee_path(data) then
			managers.groupai:state():on_civilian_freed()
		end
	end

	if not data.been_outlined and data.char_tweak.outline_on_discover then
		my_data.outline_detection_task_key = "CivilianLogicFlee_upd_outline_detection" .. key_str

		CopLogicBase.queue_task(my_data, my_data.outline_detection_task_key, CivilianLogicIdle._upd_outline_detection, data, data.t + 2)
	end

	if not my_data.detection_task_key and data.unit:anim_data().react_enter then
		my_data.detection_task_key = "CivilianLogicFlee._upd_detection" .. key_str

		CopLogicBase.queue_task(my_data, my_data.detection_task_key, CivilianLogicFlee._upd_detection, data, data.t + 0)
	end

	local attention_settings

	attention_settings = {
		"civ_enemy_cbt",
		"civ_civ_cbt",
		"civ_murderer_cbt"
	}

	CivilianLogicFlee.schedule_run_away_clbk(data)

	if not my_data.delayed_post_react_alert_id and data.unit:movement():stance_name() == "ntl" then
		my_data.delayed_post_react_alert_id = "postreact_alert" .. key_str

		CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_post_react_alert_id, callback(CivilianLogicFlee, CivilianLogicFlee, "post_react_alert_clbk", {
			data = data
		}), TimerManager:game():time() + math.lerp(4, 8, math.random()))
	end

	data.unit:brain():set_attention_settings(attention_settings)

	if data.char_tweak.calls_in and not managers.groupai:state():is_police_called() and managers.groupai:state():can_police_be_called() then
		my_data.call_police_clbk_id = "civ_call_police" .. key_str

		local call_t = math.max(data.call_police_delay_t or 0, TimerManager:game():time() + math.lerp(data.char_tweak.call_police_delay[1], data.char_tweak.call_police_delay[2], math.random()))

		CopLogicBase.add_delayed_clbk(my_data, my_data.call_police_clbk_id, callback(CivilianLogicFlee, CivilianLogicFlee, "clbk_chk_call_the_police", data), call_t)
	end

	my_data.next_action_t = 0
end)

-- Security Camera Rework by Hoppip
local on_new_objective_original = CivilianLogicFlee.on_new_objective
function CivilianLogicFlee.on_new_objective(data, ...)
	if not data.forced_police_call_attention or managers.groupai:state():enemy_weapons_hot() then
		return on_new_objective_original(data, ...)
	end
end