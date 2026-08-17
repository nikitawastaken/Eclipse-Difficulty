local tmp_vec = Vector3()

Hooks:PostHook(TeamAILogicBase, "_set_attention_obj", "eclipse__set_attention_obj", function(data, att, react)
	if not att or not att.verified or not react then
		return
	end

	-- early abort
	if data.cool or data.internal_data.acting or data.objective and data.objective.type == "revive" then
		return
	end

	if data.unit:movement():chk_action_forbidden("action") or data.unit:anim_data().reload or data.unit:character_damage():is_downed() then
		return
	end

	if not alive(att.unit) or not att.unit:character_damage() or att.unit:character_damage():dead() then
		return
	end

	-- only do intimidation/marking if we are actually looking in that direction
	mvector3.set(tmp_vec, att.unit:movement():m_head_pos())
	mvector3.subtract(tmp_vec, data.unit:movement():m_head_pos())
	if tmp_vec:angle(data.unit:movement():m_rot():y()) > 50 then
		return
	end

	-- intimidate
	if react == AIAttentionObject.REACT_ARREST and (not data._next_intimidate_t or data._next_intimidate_t < data.t) then
		local logic_data = att.unit:brain()._logic_data
		if not logic_data._next_intimidate_t or logic_data._next_intimidate_t < data.t then
			TeamAILogicIdle.intimidate_cop(data, att.unit)
			data._next_intimidate_t = data.t + tweak_data.player.movement_state.interaction_delay
			return
		end
	end

	-- mark
	if not data._next_mark_t or data._next_mark_t < data.t then
		if att.char_tweak and att.char_tweak.priority_shout and not att.unit:contour():find_id_match("^mark_enemy") then
			if att.unit:character_damage():health_ratio() > 0.6 and att.dis <= tweak_data.player.long_dis_interaction.highlight_range then
				if not TeamAILogicIdle.is_high_priority(att.unit:movement()) then
					if not World:raycast("ray", data.m_pos, att.m_pos, "slot_mask", data.visibility_slotmask, "report") then
						TeamAILogicAssault.mark_enemy(data, data.unit, att.unit)
						att.mark_t = data.t
						data._next_mark_t = data.t + 5
						return
					end
				end
			end
		end
	end
end)

Hooks:PostHook(TeamAILogicBase, "on_new_objective", "eclipse_on_new_objective", function(data)
	local objective = data.objective
	if not objective then
		return
	end

	if objective.type == "follow" then
		data._latest_follow_unit = objective.follow_unit
	end

	if objective.type == "revive" or objective.assist_unit then
		objective.no_idle_delay = true
		data.brain:action_request({
			body_part = 3,
			type = "idle",
		})
	end
end)

function TeamAILogicBase.force_attention(data, my_data, unit)
	if data.cool then
		return
	end

	local logic_supports_shooting = data.name == "assault" or data.name == "travel"
	if not logic_supports_shooting and not data.logic.is_available_for_assignment(data) then
		return
	end

	local att_obj_data = TeamAILogicBase.identify_attention_obj_instant(data, unit:key())
	if not att_obj_data then
		return
	end

	TeamAILogicBase._upd_attention_obj_detection(data, AIAttentionObject.REACT_SHOOT, nil)

	local new_attention = TeamAILogicIdle._get_priority_attention(data, data.detected_attention_objects, nil)
	if not new_attention or new_attention.u_key ~= att_obj_data.u_key then
		return
	end

	local is_new = data.attention_obj ~= new_attention
	TeamAILogicBase._set_attention_obj(data, new_attention, AIAttentionObject.REACT_SHOOT)

	if not logic_supports_shooting then
		if data.objective and data.objective.type == "act" then
			data.objective_failed_clbk(data.unit, data.objective)
		end
		TeamAILogicBase._exit(data.unit, "assault")
	end

	if is_new then
		CopLogicAttack._chk_request_action_turn_to_enemy(data, my_data, data.m_pos, new_attention.m_pos)
	end
	TeamAILogicAssault._upd_aim(data, my_data)
end

-- This function is disabled in vanilla but is not part of other logics so it might crash in other logics when called with data.logic._upd_sneak_spotting
function TeamAILogicBase._upd_sneak_spotting() end

function TeamAILogicBase.chk_should_turn() end

-- Wait before switching to idle
function TeamAILogicBase._get_logic_state_from_reaction(data, reaction)
	local state = (not reaction or reaction <= AIAttentionObject.REACT_SCARED) and "idle" or "assault"

	if state == "assault" then
		data.last_assault_state_t = data.t
	elseif data.last_assault_state_t and data.t < data.last_assault_state_t + (data.objective and data.objective.type == "defend_area" and 10 or 5) then
		state = "assault"
	end

	return state
end

-- Bag movement
function TeamAILogicBase._find_closest_secure_zone(data, carry_unit)
	if not alive(data._latest_follow_unit) then
		return
	end

	local secure_bag_data = data.secure_bag_data[data._latest_follow_unit:key()]
	if not secure_bag_data then
		return
	end

	local blocked = {}
	for _, v in pairs(managers.groupai:state():all_AI_criminals()) do
		local other_objective = v.unit:brain():objective()
		if other_objective and alive(other_objective.zipline_unit) then
			blocked[other_objective.zipline_unit:key()] = true
		end
	end

	local secure_info
	local closest_secure_trigger
	local closest_secure_trigger_dis_sq = math.huge
	local carry_id = carry_unit:carry_data():carry_id()
	local carry_type_tweak = tweak_data.carry[carry_id] and tweak_data.carry.types[tweak_data.carry[carry_id].type]
	local carry_throw_multiplier = carry_type_tweak and carry_type_tweak.throw_distance_multiplier or 1
	for secure_trigger, secure_data in pairs(secure_bag_data) do
		secure_info = secure_data[carry_throw_multiplier] or secure_data[next(secure_data)]
		local dis_sq = secure_trigger:ub_can_secure_loot(carry_unit) and TeamAILogicBase:_check_bag_dis(data, secure_info.pos, 1000)
		local valid_zipline = alive(secure_info.zipline_unit) and not blocked[secure_info.zipline_unit:key()] and not secure_info.zipline_unit:zipline():is_interact_blocked()
		if dis_sq and dis_sq < closest_secure_trigger_dis_sq and (not secure_info.zipline_unit or valid_zipline) then
			closest_secure_trigger = secure_trigger
			break
		end
	end

	return closest_secure_trigger, secure_info
end

function TeamAILogicBase._find_closest_bag(data)
	if not alive(data._latest_follow_unit) then
		return
	end

	local secure_bag_data = data.secure_bag_data[data._latest_follow_unit:key()]
	if not secure_bag_data then
		return
	end

	local blocked = {}
	for _, v in pairs(managers.groupai:state():all_AI_criminals()) do
		local other_objective = v.unit:brain():objective()
		if other_objective and other_objective.pickup_carry_unit then
			blocked[other_objective.pickup_carry_unit:key()] = true
		end
	end

	local closest_carry_unit
	local closest_carry_unit_dis_sq = math.huge
	for u_key, unit in pairs(CarryData.ub_loot) do
		if not alive(unit) or not unit:interaction() or not unit:interaction():active() then
			CarryData.ub_loot[u_key] = nil
		elseif not blocked[u_key] and unit:sampled_velocity():length() == 0 then
			for secure_trigger in pairs(secure_bag_data) do
				local dis_sq = secure_trigger:ub_can_secure_loot(unit) and TeamAILogicBase:_check_bag_dis(data, unit:position(), 1000)
				if dis_sq and dis_sq < closest_carry_unit_dis_sq then
					closest_carry_unit_dis_sq = dis_sq
					closest_carry_unit = unit
				end
			end
		end
	end

	return closest_carry_unit
end

function TeamAILogicBase._check_deliver_bag(data)
	if data.cool or Monkeepers then
		return
	end

	local objective = data.objective
	if not objective then
		return
	end

	local carry_unit = data.unit:movement():carry_unit()
	if objective.secure_trigger then
		if not alive(carry_unit) or not objective.secure_trigger:ub_can_secure_loot(carry_unit) then
			data.brain:set_objective(nil)
			return true
		end
	elseif objective.pickup_carry_unit then
		if alive(carry_unit) or not alive(objective.pickup_carry_unit) or objective.pickup_carry_unit:carry_data():is_linked_to_unit() then
			data.brain:set_objective(nil)
			return true
		end
	end

	if objective.type ~= "follow" and objective.type ~= "defend_area" then
		return
	end

	if not carry_unit then
		return TeamAILogicBase._check_pickup_bag(data)
	end

	local secure_trigger, secure_info = TeamAILogicBase._find_closest_secure_zone(data, carry_unit)
	if not secure_trigger then
		return
	end

	if data.internal_data.advancing then
		data.brain:action_request({
			body_part = 2,
			type = "idle",
		})
	end

	local zipline_unit = secure_info.zipline_unit
	data.brain:set_objective({
		type = "free",
		secure_trigger = secure_trigger,
		zipline_unit = zipline_unit,
		path_ahead = true,
		haste = "run",
		pose = "stand",
		pos = secure_info.pos,
		rot = Rotation:look_at(secure_info.dir:with_z(0), math.UP),
		nav_seg = managers.navigation:get_nav_seg_from_pos(secure_info.pos, true),
		followup_objective = {
			type = "act",
			zipline_unit = zipline_unit,
			in_place = true,
			action_duration = 0.5,
			action = {
				type = "stand",
				body_part = 1,
			},
			complete_clbk = function(unit)
				local carry_unit = unit:movement():carry_unit()
				local carry_data = alive(carry_unit) and carry_unit:carry_data()
				if not carry_data then
					return
				end

				if zipline_unit and (not alive(zipline_unit) or zipline_unit:zipline():is_interact_blocked()) then
					return
				end

				CarryData.ub_loot[carry_unit:key()] = nil
				unit:movement()._was_carrying = { unit = carry_unit }

				carry_data:unlink()
				if zipline_unit then
					managers.network:session():send_to_peers_synched(
						"sync_carry_data",
						carry_unit,
						carry_data:carry_id(),
						carry_data:multiplier(),
						carry_data:dye_initiated(),
						carry_data:has_dye_pack(),
						carry_data:dye_value_multiplier(),
						secure_info.bag_pos,
						secure_info.dir,
						0,
						zipline_unit,
						0
					)
					zipline_unit:zipline():attach_bag(carry_unit)
				else
					carry_data:set_position_and_throw(secure_info.bag_pos, secure_info.dir, 100)
				end
			end,
		},
	})

	return true
end

function TeamAILogicBase._check_pickup_bag(data)
	if data._next_bag_check_t and data._next_bag_check_t > data.t then
		return
	end

	data._next_bag_check_t = data.t + 1

	local carry_unit = TeamAILogicBase._find_closest_bag(data)
	if not carry_unit then
		return
	end

	if data.objective.type == "defend_area" and not TeamAILogicBase._find_closest_secure_zone(data, carry_unit) then
		return
	end

	local tracker = managers.navigation:create_nav_tracker(carry_unit:position(), false)
	local pos = tracker:field_position()
	local nav_seg = tracker:nav_segment()
	managers.navigation:destroy_nav_tracker(tracker)

	if data.internal_data.advancing then
		data.brain:action_request({
			body_part = 2,
			type = "idle",
		})
	end

	data.brain:set_objective({
		type = "free",
		pickup_carry_unit = carry_unit,
		path_ahead = true,
		haste = "run",
		pose = "stand",
		pos = pos,
		nav_seg = nav_seg,
		followup_objective = {
			type = "act",
			in_place = true,
			action_duration = 1,
			action = {
				type = "act",
				variant = "untie",
				body_part = 1,
			},
			complete_clbk = function(unit)
				local valid_carry = alive(carry_unit) and carry_unit:interaction() and carry_unit:interaction():active()
				if valid_carry and not carry_unit:carry_data():is_linked_to_unit() and not unit:movement()._carry_unit then
					carry_unit:carry_data():link_to(unit)
				end
				unit:movement():action_request({
					type = "idle",
					body_part = 1,
				})
			end,
		},
	})

	return true
end

function TeamAILogicBase:_check_bag_dis(data, pos, max_dis)
	local is_stationary = data.objective and data.objective.type == "defend_area"
	if is_stationary then
		max_dis = max_dis * 0.5
	end

	local max_dis_sq = max_dis ^ 2
	local dis_sq = mvector3.distance_sq(data.m_pos, pos)
	if math.abs(data.m_pos.z - pos.z) < 100 and dis_sq < max_dis_sq then
		return dis_sq
	end

	if is_stationary then
		return
	end

	local follow_pos = alive(data._latest_follow_unit) and data._latest_follow_unit:movement():m_newest_pos()
	if follow_pos and math.abs(follow_pos.z - pos.z) < 100 and mvector3.distance_sq(follow_pos, pos) < max_dis_sq then
		return dis_sq
	end
end
