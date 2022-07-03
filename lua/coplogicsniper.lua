-- Make snipers always aim if they have a target
function CopLogicSniper._upd_aim(data, my_data)
	local focus_enemy = data.attention_obj
	local expected_pos = focus_enemy and (focus_enemy.last_verified_pos or focus_enemy.verified_pos)
	local aim = expected_pos and true
	local shoot = focus_enemy and focus_enemy.verified and focus_enemy.reaction >= AIAttentionObject.REACT_SHOOT
	local anim_data = data.unit:anim_data()

	local action_taken = my_data.turning or data.unit:movement():chk_action_forbidden("walk")
	if not action_taken then

		if anim_data.reload and not anim_data.crouch and (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch) then
			action_taken = CopLogicAttack._chk_request_action_crouch(data)
		end

		if not action_taken then
			if my_data.attitude == "engage" and not data.is_suppressed then
				if focus_enemy then
					if not focus_enemy.verified and not anim_data.reload then
						if anim_data.crouch then
							if (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.stand) and not CopLogicSniper._chk_stand_visibility(data.m_pos, focus_enemy.m_head_pos, data.visibility_slotmask) then
								CopLogicAttack._chk_request_action_stand(data)
							end
						elseif (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch) and not CopLogicSniper._chk_crouch_visibility(data.m_pos, focus_enemy.m_head_pos, data.visibility_slotmask) then
							CopLogicAttack._chk_request_action_crouch(data)
						end
					end
				elseif my_data.wanted_pose and not anim_data.reload then
					if my_data.wanted_pose == "crouch" then
						if not anim_data.crouch and (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch) then
							action_taken = CopLogicAttack._chk_request_action_crouch(data)
						end
					elseif not anim_data.stand and (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.stand) then
						action_taken = CopLogicAttack._chk_request_action_stand(data)
					end
				end
			elseif focus_enemy then
				if focus_enemy.verified and anim_data.stand and (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch) and CopLogicSniper._chk_crouch_visibility(data.m_pos, focus_enemy.m_head_pos, data.visibility_slotmask) then
					CopLogicAttack._chk_request_action_crouch(data)
				end
			elseif my_data.wanted_pose and not anim_data.reload then
				if my_data.wanted_pose == "crouch" then
					if not anim_data.crouch and (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch) then
						action_taken = CopLogicAttack._chk_request_action_crouch(data)
					end
				elseif not anim_data.stand and (not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.stand) then
					action_taken = CopLogicAttack._chk_request_action_stand(data)
				end
			end
		end
	end

	if my_data.reposition and not action_taken and not my_data.advancing then
		local objective = data.objective
		my_data.advance_path = {
			mvector3.copy(data.m_pos),
			mvector3.copy(objective.pos)
		}

		if CopLogicTravel._chk_request_action_walk_to_advance_pos(data, my_data, objective.haste or "walk", objective.rot) then
			action_taken = true
		end
	end

	if aim or shoot then
		if focus_enemy.verified then
			if my_data.attention_unit ~= focus_enemy.u_key then
				CopLogicBase._set_attention(data, focus_enemy)
				my_data.attention_unit = focus_enemy.u_key
			end
		elseif my_data.attention_unit ~= expected_pos then
			CopLogicBase._set_attention_on_pos(data, expected_pos)
			my_data.attention_unit = expected_pos
		end

		if not my_data.shooting and not data.unit:movement():chk_action_forbidden("action") then
			my_data.shooting = data.unit:brain():action_request({
				body_part = 3,
				type = "shoot"
			})
		end
	else
		if my_data.shooting then
			data.unit:brain():action_request({
				body_part = 3,
				type = "idle"
			})
		end

		if my_data.attention_unit then
			CopLogicBase._reset_attention(data)
			my_data.attention_unit = nil
		end
	end

	CopLogicAttack.aim_allow_fire(shoot, aim, data, my_data)
end
