function ShieldLogicAttack.queued_update(data)
	local t = TimerManager:game():time()
	data.t = t
	local unit = data.unit
	local my_data = data.internal_data

	ShieldLogicAttack._upd_enemy_detection(data)

	if my_data ~= data.internal_data then
		return
	end

	if my_data.has_old_action then
		CopLogicAttack._upd_stop_old_action(data, my_data)
		ShieldLogicAttack.queue_update(data, my_data)
		CopLogicBase._report_detections(data.detected_attention_objects)

		return
	end

	if not data.attention_obj or data.attention_obj.reaction < AIAttentionObject.REACT_AIM then
		ShieldLogicAttack.queue_update(data, my_data)

		return
	end

	local focus_enemy = data.attention_obj
	local action_taken = my_data.turning or data.unit:movement():chk_action_forbidden("walk") or my_data.walking_to_shoot_pos

	if not action_taken and unit:anim_data().stand then
		action_taken = CopLogicAttack._chk_request_action_crouch(data)
	end

	ShieldLogicAttack._process_pathing_results(data, my_data)

	local enemy_visible = focus_enemy.verified
    -- actually do the shielding if close enough
	if enemy_visible and focus_enemy.verified_dis < 800 then
		unit:brain():action_request({
			body_part = 2,
			type = "idle"
		})
	end
	local engage = my_data.attitude == "engage"
	local action_taken = my_data.turning or data.unit:movement():chk_action_forbidden("walk") or my_data.walking_to_optimal_pos

	if not action_taken then
		if unit:anim_data().stand then
			action_taken = CopLogicAttack._chk_request_action_crouch(data)
		end

		if not action_taken then
			if my_data.pathing_to_optimal_pos then
				-- Nothing
			elseif my_data.optimal_path then
				ShieldLogicAttack._chk_request_action_walk_to_optimal_pos(data, my_data)
			elseif my_data.optimal_pos and focus_enemy.nav_tracker then
				local to_pos = my_data.optimal_pos
				my_data.optimal_pos = nil
				local ray_params = {
					trace = true,
					tracker_from = unit:movement():nav_tracker(),
					pos_to = to_pos
				}
				local ray_res = managers.navigation:raycast(ray_params)
				to_pos = ray_params.trace[1]

				if ray_res then
					local vec = data.m_pos - to_pos

					mvector3.normalize(vec)

					local fwd = unit:movement():m_fwd()
					local fwd_dot = fwd:dot(vec)

					if fwd_dot > 0 then
						local enemy_tracker = focus_enemy.nav_tracker

						if enemy_tracker:lost() then
							ray_params.tracker_from = nil
							ray_params.pos_from = enemy_tracker:field_position()
						else
							ray_params.tracker_from = enemy_tracker
						end

						ray_res = managers.navigation:raycast(ray_params)
						to_pos = ray_params.trace[1]
					end
				end

				local fwd_bump = nil
				to_pos, fwd_bump = ShieldLogicAttack.chk_wall_distance(data, my_data, to_pos)
				local do_move = mvector3.distance_sq(to_pos, data.m_pos) > 10000

				if not do_move then
					local to_pos_current, fwd_bump_current = ShieldLogicAttack.chk_wall_distance(data, my_data, data.m_pos)

					if fwd_bump_current then
						do_move = true
					end
				end

				if do_move then
					my_data.pathing_to_optimal_pos = true
					my_data.optimal_path_search_id = tostring(unit:key()) .. "optimal"
					local reservation = managers.navigation:reserve_pos(nil, nil, to_pos, callback(ShieldLogicAttack, ShieldLogicAttack, "_reserve_pos_step_clbk", {
						unit_pos = data.m_pos
					}), 70, data.pos_rsrv_id)

					if reservation then
						to_pos = reservation.position
					else
						reservation = {
							radius = 60,
							position = mvector3.copy(to_pos),
							filter = data.pos_rsrv_id
						}

						managers.navigation:add_pos_reservation(reservation)
					end

					data.brain:set_pos_rsrv("path", reservation)
					data.brain:search_for_path(my_data.optimal_path_search_id, to_pos)
				end
			end
		end
	end

	ShieldLogicAttack.queue_update(data, my_data)
	CopLogicBase._report_detections(data.detected_attention_objects)
end