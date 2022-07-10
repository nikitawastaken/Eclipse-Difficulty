-- Reuse function of idle logic to make enemies in an area aware of a player entering the area
CopLogicAttack.on_area_safety = CopLogicIdle.on_area_safety

-- Remove some of the strict conditions for enemies shooting while on the move
-- This will result in enemies opening fire more likely while moving
-- Also greatly simplified the function
function CopLogicAttack._upd_aim(data, my_data)
	local focus_enemy = data.attention_obj
	local verified = focus_enemy and focus_enemy.verified
	local nearly_visible = focus_enemy and focus_enemy.nearly_visible

	local aim, shoot, expected_pos = CopLogicAttack._check_aim_shoot(data, my_data, focus_enemy, verified, nearly_visible)

	if aim or shoot then
		if verified or nearly_visible then
			if my_data.attention_unit ~= focus_enemy.u_key then
				CopLogicBase._set_attention(data, focus_enemy)
				my_data.attention_unit = focus_enemy.u_key
			end
		elseif expected_pos then
			if my_data.attention_unit ~= expected_pos then
				CopLogicBase._set_attention_on_pos(data, expected_pos)
				my_data.attention_unit = expected_pos
			end
		end

		if not my_data.shooting and not my_data.spooc_attack and not data.unit:anim_data().reload and not data.unit:movement():chk_action_forbidden("action") then
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

-- Helper function to reuse in other enemy logic _upd_aim functions
function CopLogicAttack._check_aim_shoot(data, my_data, focus_enemy, verified, nearly_visible)
	if not focus_enemy or focus_enemy.reaction < AIAttentionObject.REACT_AIM then
		return
	end

	local advancing = my_data.advancing and not my_data.advancing:stopping()
	local running = data.unit:anim_data().run or advancing and my_data.advancing._cur_vel and my_data.advancing._cur_vel > 300
	local time_since_verification = focus_enemy.verified_t and data.t - focus_enemy.verified_t or math.huge
	local weapon_range = data.internal_data.weapon_range or { close = 1000, far = 4000 }
	local firing_range = running and weapon_range.close or weapon_range.far

	local aim = not advancing or time_since_verification < math.lerp(4, 1, focus_enemy.verified_dis / firing_range) or focus_enemy.verified_dis < 800 or data.char_tweak.always_face_enemy
	local shoot = aim and my_data.shooting and AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction and time_since_verification < (running and 2 or 4)
	local expected_pos = not shoot and focus_enemy.verified_dis < weapon_range.close and focus_enemy.m_head_pos or focus_enemy.last_verified_pos or focus_enemy.verified_pos

	if verified or nearly_visible then
		if not shoot and AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction then
			local last_sup_t = data.unit:character_damage():last_suppression_t()

			if last_sup_t and data.t - last_sup_t < 7 * (running and 0.5 or 1) * (verified and 1 or 0.5) then
				shoot = true
			elseif verified and focus_enemy.verified_dis < firing_range then
				shoot = true
			elseif verified and focus_enemy.criminal_record and focus_enemy.criminal_record.assault_t and data.t - focus_enemy.criminal_record.assault_t < (running and 2 or 4) then
				shoot = true
			elseif my_data.attitude == "engage" and my_data.firing and time_since_verification < 4 then
				shoot = true
			end
		end

		aim = aim or shoot or focus_enemy.verified_dis < firing_range
	end

	return aim, shoot, expected_pos
end


-- Pathing related fixes to stop spamming walk actions when the new position is the same as the current position
local _find_retreat_position_original = CopLogicAttack._find_retreat_position
function CopLogicAttack._find_retreat_position(from_pos, ...)
	local to_pos = _find_retreat_position_original(from_pos, ...)
	if to_pos and (from_pos.x ~= to_pos.x or from_pos.y ~= to_pos.y) then
		return to_pos
	end
end

function CopLogicAttack._chk_start_action_move_out_of_the_way(data, my_data)
	local from_pos = data.m_pos
	local reservation = {
		radius = 30,
		position =  from_pos,
		filter = data.pos_rsrv_id
	}
	if managers.navigation:is_pos_free(reservation) then
		return
	end

	local to_pos = CopLogicTravel._get_pos_on_wall(from_pos, 500)
	if from_pos.x == to_pos.x and from_pos.y == to_pos.y then
		return
	end

	local path = {
		mvector3.copy(from_pos),
		to_pos
	}
	CopLogicAttack._chk_request_action_walk_to_cover_shoot_pos(data, my_data, path, "run")
end

-- Empty this function (path starting position is corrected in CopActionWalk as it covers all cases)
function CopLogicAttack._correct_path_start_pos() end


-- Make moving back during combat depend on weapon range
function CopLogicAttack._chk_start_action_move_back(data, my_data, focus_enemy, engage)
	local weapon_range = my_data.weapon_range or { close = 500 }
	local close_range = weapon_range.close * 0.5
	if focus_enemy and focus_enemy.nav_tracker and focus_enemy.verified and focus_enemy.dis < close_range and CopLogicAttack._can_move(data) then
		local from_pos = mvector3.copy(data.m_pos)
		local threat_tracker = focus_enemy.nav_tracker
		local threat_head_pos = focus_enemy.m_head_pos
		local retreat_to = CopLogicAttack._find_retreat_position(from_pos, focus_enemy.m_pos, threat_head_pos, threat_tracker, 400, engage)

		if retreat_to then
			CopLogicAttack._cancel_cover_pathing(data, my_data)

			my_data.advancing = data.unit:brain():action_request({
				type = "walk",
				variant = "walk",
				body_part = 2,
				nav_path = {
					from_pos,
					retreat_to
				}
			})

			if my_data.advancing then
				my_data.surprised = true
				return true
			end
		end
	end
end