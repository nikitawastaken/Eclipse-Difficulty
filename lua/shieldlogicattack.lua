local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()
local tmp_vec4 = Vector3()

-- Only allow positioning when group is fully spawned
local _chk_request_action_walk_to_optimal_pos_original = ShieldLogicAttack._chk_request_action_walk_to_optimal_pos
function ShieldLogicAttack._chk_request_action_walk_to_optimal_pos(data, ...)
	if not data.group or data.group.has_spawned then
		_chk_request_action_walk_to_optimal_pos_original(data, ...)
	end
end

-- Stop walking action upon entering or leaving attack logic
Hooks:PreHook(ShieldLogicAttack, "enter", "sh_enter", function(data)
	CopLogicTravel.cancel_advance(data)

	-- elite shields do their unique bang sound when entering attack logic
	if not data.attack_sound_t or data.t - data.attack_sound_t > 40 then
		data.attack_sound_t = data.t

		if data.unit:base()._tweak_table == "city_shield" then
			data.unit:sound():play("hos_shield_indication_sound_terminator_style", nil, true)
		else
			data.unit:sound():play("shield_identification", nil, true)
		end
	end
end)

Hooks:PreHook(ShieldLogicAttack, "exit", "sh_exit", function(data)
	ShieldLogicAttack._cancel_optimal_attempt(data, data.internal_data)
end)

-- Update logic more consistently
function ShieldLogicAttack.queue_update(data, my_data)
	CopLogicBase.queue_task(my_data, my_data.update_queue_id, ShieldLogicAttack.queued_update, data, data.t + 0.5, data.important and true)
end

-- Improve positioning to be more consistent and leave space for group members
function ShieldLogicAttack._upd_enemy_detection(data)
	local my_data = data.internal_data
	local close_range = my_data.weapon_range and my_data.weapon_range.close or 500
	local optimal_range = my_data.weapon_range and my_data.weapon_range.optimal or 1000
	local far_range = my_data.weapon_range and my_data.weapon_range.far or 2000
	local threat_pos, threat_dir, threat_dir_side, test_pos = tmp_vec1, tmp_vec2, tmp_vec3, tmp_vec4
	local attention_objects = {}
	local total_importance = 0
	local can_walk = not data.unit:movement():chk_action_forbidden("walk")

	CopLogicBase._upd_attention_obj_detection(data, min_reaction, nil)

	if data.tactics and data.tactics.ranged_fire then
		optimal_range = optimal_range * 1.5
	end

	if data.tactics and data.tactics.charge then
		optimal_range = optimal_range * 0.75
	end

	if can_walk then
		mvector3.set_zero(threat_pos)
		for u_key, attention_obj in pairs(data.detected_attention_objects) do
			local verified_dt = attention_obj.verified_t and data.t - attention_obj.verified_t or math.huge
			local importance = attention_obj.verified and 1 or math.map_range_clamped(verified_dt, 0, 4, 1, 0)
			importance = importance * math.map_range_clamped(attention_obj.verified_dis, 0, far_range, 1, 0) ^ 2
			importance = importance * (attention_obj.settings.weight_mul or 1)
			attention_obj.reaction = CopLogicSniper._chk_reaction_to_attention_object(data, attention_obj, true)
			if importance > 0 and attention_obj.reaction > AIAttentionObject.REACT_AIM then
				total_importance = total_importance + importance
				mvector3.add_scaled(threat_pos, attention_obj.verified and attention_obj.m_pos or attention_obj.verified_pos, importance)
				attention_objects[u_key] = attention_obj
			end
		end
	end

	if total_importance == 0 then
		local new_attention, _, new_reaction = CopLogicIdle._get_priority_attention(data, data.detected_attention_objects, nil)
		CopLogicBase._set_attention_obj(data, new_attention, new_reaction)
		CopLogicAttack._chk_exit_attack_logic(data, new_reaction)
		if my_data ~= data.internal_data or CopLogicIdle._chk_relocate(data) then
			return
		end

		if can_walk and new_attention and new_attention.nav_tracker then
			my_data.optimal_pos = CopLogicAttack._find_flank_pos(data, my_data, new_attention.nav_tracker)
		end

		ShieldLogicAttack._upd_aim(data, my_data)
		return
	end

	ShieldLogicAttack._cancel_charge(data, my_data)

	mvector3.divide(threat_pos, total_importance)
	mvector3.set_z(threat_pos, data.m_pos.z)
	local threat_dis = mvector3.direction(threat_dir, threat_pos, data.m_pos)
	local too_close, too_far = threat_dis < close_range, threat_dis > optimal_range
	if too_close or too_far then
		local factor, flip = 0, false
		local optimal_dis, optimal_pos = -math.huge, nil
		local pos_reservation = {
			radius = 60,
			filter = data.pos_rsrv_id,
		}
		local ray_params = {
			allow_entry = true,
			trace = true,
			pos_from = data.m_pos,
		}

		local extra_space = too_far and -40 or 0
		if too_close and data.group then
			for _, u_data in pairs(data.group.units) do
				local other_objective = alive(u_data.unit) and u_data.unit:brain():objective()
				if other_objective and other_objective.follow_unit == data.unit then
					extra_space = 120
					break
				end
			end
		end

		mvector3.cross(threat_dir_side, threat_dir, math.UP)
		while factor <= 1 or not flip do
			mvector3.lerp(test_pos, threat_dir, threat_dir_side, factor)
			mvector3.multiply(test_pos, math.lerp(close_range, optimal_range, too_close and 0.75 or 0.25) + extra_space)
			mvector3.add(test_pos, threat_pos)

			ray_params.pos_to = test_pos
			managers.navigation:raycast(ray_params)
			if extra_space ~= 0 then
				mvector3.step(test_pos, ray_params.trace[1], threat_pos, extra_space)
				managers.navigation:raycast(ray_params)
			end

			pos_reservation.position = ray_params.trace[1]

			local threat_pos_dis = mvector3.distance(ray_params.trace[1], threat_pos)
			if threat_pos_dis > optimal_dis and managers.navigation:is_pos_free(pos_reservation) then
				optimal_dis = threat_pos_dis
				optimal_pos = ray_params.trace[1]
				if threat_pos_dis > close_range then
					break
				end
			end

			flip = not flip
			if flip then
				factor = factor + 0.125
			end

			mvector3.negate(threat_dir_side)
		end

		if optimal_pos and my_data.current_optimal_pos then
			local old_dis = mvector3.distance(my_data.current_optimal_pos, optimal_pos)
			if old_dis < 150 then
				optimal_pos = nil
			elseif old_dis > close_range and threat_dis > 300 then
				ShieldLogicAttack._cancel_optimal_attempt(data, my_data)
			end
		end

		if optimal_pos and not my_data.walking_to_optimal_pos and not my_data.pathing_to_optimal_pos then
			my_data.current_optimal_pos = optimal_pos
			my_data.pathing_to_optimal_pos = true
			my_data.optimal_path_search_id = tostring(data.key) .. "optimal"

			local reserve_clbk = callback(ShieldLogicAttack, ShieldLogicAttack, "_reserve_pos_step_clbk", { unit_pos = data.m_pos })
			local reservation = managers.navigation:reserve_pos(nil, nil, optimal_pos, reserve_clbk, 60, data.pos_rsrv_id)

			if reservation then
				optimal_pos = reservation.position
			else
				reservation = pos_reservation
				managers.navigation:add_pos_reservation(reservation)
			end

			data.brain:set_pos_rsrv("path", reservation)
			data.brain:search_for_path(my_data.optimal_path_search_id, optimal_pos)
		end
	end

	local attention_dir = tmp_vec1
	local best_importance, best_attention_obj = -math.huge, nil
	for u_key, attention_obj in pairs(attention_objects) do
		mvector3.direction(attention_dir, attention_obj.m_pos, data.m_pos)
		local dot = math.map_range(mvector3.dot(attention_dir, threat_dir), -1, 1, 0, 1)
		local dis = attention_obj.dis < close_range and math.map_range(attention_obj.dis, 0, close_range, 2, 1) or 0
		local is_current = data.attention_obj and data.attention_obj.u_key == u_key
		local importance = (dot + dis) * (is_current and 1.01 or 1)
		if importance > best_importance then
			best_importance = importance
			best_attention_obj = attention_obj
		end
	end

	CopLogicBase._set_attention_obj(data, best_attention_obj, best_attention_obj.reaction)

	ShieldLogicAttack._upd_aim(data, my_data)
end
