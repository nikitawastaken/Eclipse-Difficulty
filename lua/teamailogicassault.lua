-- Prevent changing back to hostile stance if bot entered with combat stance
local enter_original = TeamAILogicAssault.enter
function TeamAILogicAssault.enter(data, ...)
	local movement = data.unit:movement()
	local set_stance = rawget(movement, "set_stance")

	if movement:stance_code() ~= 1 then
		movement.set_stance = function() end
	end

	enter_original(data, ...)

	movement.set_stance = set_stance
end

-- Don't carry over "firing" variable, it has a chance to stop bots from shooting
Hooks:PostHook(TeamAILogicAssault, "enter", "eclipse_enter", function(data)
	data.internal_data.firing = nil
end)

TeamAILogicAssault._mark_special_chk_t = math.huge -- hacky way to stop the vanilla special mark code

function TeamAILogicAssault.mark_enemy(data, criminal, to_mark)
	if to_mark:base().char_tweak then
		criminal:sound():say(to_mark:base():char_tweak().priority_shout .. "x_any", true)
	end
	managers.network:session():send_to_peers_synched("play_distance_interact_redirect", data.unit, "cmd_point")
	data.unit:movement():play_redirect("cmd_point")
	to_mark:contour():add("mark_enemy", true)
end

-- This function is disabled in vanilla but is not part of TeamAILogicAssault so it might crash in other logics when called with data.logic._upd_sneak_spotting
function TeamAILogicAssault._upd_sneak_spotting() end

-- Fix attention unit reset
Hooks:PostHook(TeamAILogicAssault, "action_complete_clbk", "action_complete_clbk_ub", function(data, action)
	local my_data = data.internal_data
	if action:type() == "shoot" then
		if my_data.attention_unit then
			CopLogicBase._reset_attention(data)
			my_data.attention_unit = nil
		end

		if not data.unit:movement():chk_action_forbidden("action") then
			local mag_total, mag_remaining = data.unit:inventory():equipped_unit():base():ammo_info()
			if mag_remaining < mag_total ^ 0.75 then
				data.brain:action_request({
					body_part = 3,
					type = "reload",
				})
			end
		end
	end

	TeamAILogicIdle._check_objective_pos(data)
end)

-- Sanity check
Hooks:PreHook(TeamAILogicAssault, "_upd_aim", "_upd_aim_ub", function(data, my_data)
	my_data.weapon_range = my_data.weapon_range or data.char_tweak.weapon[data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
end)

local update_original = TeamAILogicAssault.update
function TeamAILogicAssault.update(data, ...)
	local my_data = data.internal_data

	if TeamAILogicBase._check_deliver_bag(data) then
		return
	end

	update_original(data, ...)

	if my_data == data.internal_data then
		TeamAILogicAssault:_update_combat_movement(data, my_data)
	end
end

function TeamAILogicAssault:_update_combat_movement(data, my_data)
	local charge_path = my_data.charge_path
	my_data.charge_path = nil

	if not Eclipse.settings.team_ai.combat_movement then
		return
	end

	if my_data.advancing or data.unit:movement()._should_stay or data.unit:movement():chk_action_forbidden("walk") then
		return
	end

	if charge_path then
		CopLogicAttack._chk_request_action_walk_to_cover_shoot_pos(data, my_data, charge_path)
		return
	end

	if my_data.charge_path_search_id or my_data.charge_path_failed_t and my_data.charge_path_failed_t + 1 > data.t then
		return
	end

	local attention_obj = data.attention_obj
	if not attention_obj or not attention_obj.nav_tracker or attention_obj.reaction < AIAttentionObject.REACT_SHOOT then
		return
	end

	if attention_obj.verified and not TeamAILogicIdle._ignore_shield(data.unit, attention_obj) then
		return
	end

	local follow_unit = data.objective and data.objective.follow_unit
	if not alive(follow_unit) then
		return
	end

	local _, max_dis_xy, max_dis_z = Eclipse.utils.ub_get_follow_behavior()
	local pos = CopLogicAttack._find_flank_pos(data, my_data, attention_obj.nav_tracker)
	local follow_pos = follow_unit:movement():m_newest_pos()
	if not pos or math.abs(pos.z - follow_pos.z) > max_dis_z or mvector3.distance(pos, follow_pos) > max_dis_xy * 0.5 then
		my_data.charge_path_failed_t = data.t
		return
	end

	my_data.charge_path_search_id = tostring(data.unit:key()) .. "charge"
	data.brain:search_for_path(my_data.charge_path_search_id, pos)
end
