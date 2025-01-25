local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()

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
			my_data.shooting = data.brain:action_request({
				body_part = 3,
				type = "shoot",
			})
		end
	else
		if my_data.shooting then
			data.brain:action_request({
				body_part = 3,
				type = "idle",
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
	local running = data.unit:anim_data().run or advancing and my_data.advancing:haste() == "run"
	local verified_dt = focus_enemy.verified_t and data.t - focus_enemy.verified_t or math.huge
	local weapon_range = my_data.weapon_range or { close = 750, optimal = 1500, far = 3000 }
	local firing_range = running and weapon_range.close or weapon_range.far
	local enemy_dis = focus_enemy.verified_dis
	local pushing = data.group and data.group.objective and (data.group.objective.open_fire or data.group.objective.moving_in)

	local expected_pos
	local aim = data.char_tweak.always_face_enemy or not advancing or pushing or verified_dt < math.map_range(enemy_dis, 0, firing_range, 6, 3)
	local shoot = aim and my_data.shooting and AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction and verified_dt < (running and 2 or 4)

	if verified or nearly_visible then
		if not shoot and AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction then
			local suppression_t = data.unit:character_damage():last_suppression_t()
			local suppression_dt = suppression_t and data.t - suppression_t
			local assault_dt = focus_enemy.criminal_record and focus_enemy.criminal_record.assault_t and data.t - focus_enemy.criminal_record.assault_t

			if suppression_dt and suppression_dt < 7 * (running and 0.5 or 1) * (verified and 1 or 0.5) then
				shoot = true
			elseif verified and enemy_dis < firing_range then
				shoot = true
			elseif verified and assault_dt and assault_dt < (running and 2 or 4) then
				shoot = true
			elseif my_data.attitude == "engage" and my_data.firing and verified_dt < 4 then
				shoot = true
			end
		end

		aim = aim or shoot or enemy_dis < firing_range
	else
		if not shoot and focus_enemy.criminal_record then
			expected_pos = focus_enemy.criminal_record.pos
		else
			expected_pos = focus_enemy.last_verified_pos or focus_enemy.verified_pos
		end
	end

	return aim, shoot, expected_pos
end

-- Improve aggressive chatter, specials get priority and are not limited by max amount of chatter in an area
function CopLogicAttack._chk_say_chatter(data, chatter_type)
	if data.unit:base():has_tag("special") then
		if not data.unit:sound():speaking(data.t) then
			data.unit:sound():say(tweak_data.group_ai.enemy_chatter[chatter_type].queue, true)
			return true
		end
	else
		return managers.groupai:state():chk_say_enemy_chatter(data.unit, data.m_pos, chatter_type)
	end
end

Hooks:PreHook(CopLogicAttack, "aim_allow_fire", "sh_aim_allow_fire", function(shoot, aim, data, my_data)
	local chatter = data.char_tweak.chatter
	local is_off_cooldown = not data.combat_chatter_cooldown_t or data.combat_chatter_cooldown_t < data.t
	if not chatter then
		return
	elseif data.unit:in_slot(16) then
		if aim and is_off_cooldown and chatter.aggressive and not data.unit:sound():speaking(data.t) then
			data.unit:sound():say(shoot and "lk3a" or "lk3b", true)
			data.combat_chatter_cooldown_t = data.t + math.rand(30, 90)
		end
	elseif shoot and not my_data.firing and chatter.contact then
		if CopLogicAttack._chk_say_chatter(data, "contact") then
			data.combat_chatter_cooldown_t = data.t + math.rand(5, 10)
		end
	elseif aim and is_off_cooldown and chatter.aggressive then
		if CopLogicAttack._chk_say_chatter(data, "aggressive") then
			data.combat_chatter_cooldown_t = data.t + math.rand(10, 20)
		end
	end
end)

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
		position = from_pos,
		filter = data.pos_rsrv_id,
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
		to_pos,
	}
	CopLogicAttack._chk_request_action_walk_to_cover_shoot_pos(data, my_data, path, math.random() < 0.5 and "run" or "walk")
end

-- Empty this function (path starting position is corrected in CopActionWalk as it covers all cases)
function CopLogicAttack._correct_path_start_pos() end

-- Simplify function, navigation raycast is already done in CopLogicAttack._find_retreat_position
function CopLogicAttack._confirm_retreat_position(retreat_pos, threat_pos, threat_head_pos, threat_tracker)
	mvector3.set(tmp_vec1, retreat_pos)
	mvector3.set_z(tmp_vec1, retreat_pos.z + 140)
	if not World:raycast("ray", tmp_vec1, threat_head_pos, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision") then
		return retreat_pos
	end
end

-- Make moving back during combat depend on weapon range
function CopLogicAttack._chk_start_action_move_back(data, my_data, focus_enemy, engage, range)
	if not focus_enemy or not focus_enemy.nav_tracker or not focus_enemy.verified then
		return
	end

	local close_range = (my_data.weapon_range and (my_data.weapon_range[range] or my_data.weapon_range.close) or 800) * 0.5
	if focus_enemy.dis > close_range or not CopLogicAttack._can_move(data) then
		return
	end

	local from_pos = mvector3.copy(data.m_pos)
	local threat_tracker = focus_enemy.nav_tracker
	local threat_head_pos = focus_enemy.m_head_pos
	local retreat_to = CopLogicAttack._find_retreat_position(from_pos, focus_enemy.m_pos, threat_head_pos, threat_tracker, close_range, engage)
	if not retreat_to then
		return
	end

	CopLogicAttack._cancel_cover_pathing(data, my_data)

	my_data.advancing = data.brain:action_request({
		type = "walk",
		variant = "walk",
		body_part = 2,
		nav_path = {
			from_pos,
			retreat_to,
		},
	})

	if my_data.advancing then
		my_data.surprised = true
		return true
	end
end

-- Improve cover update
function CopLogicAttack._update_cover(data)
	local my_data = data.internal_data
	local best_cover = my_data.best_cover
	local focus_enemy = data.attention_obj
	local objective = data.objective

	if not focus_enemy or not focus_enemy.nav_tracker or focus_enemy.reaction < AIAttentionObject.REACT_COMBAT or objective and objective.cover_unit then
		if best_cover and mvector3.distance_sq(best_cover[1][1], data.m_pos) > 100 ^ 2 then
			CopLogicAttack._set_best_cover(data, my_data, nil)
		end
		return
	end

	local taking_cover = my_data.moving_to_cover or my_data.walking_to_cover_shoot_pos or my_data.surprised
	local processing_cover = my_data.processing_cover_path or my_data.charge_path_search_id

	if not taking_cover and not processing_cover then
		local threat_pos = focus_enemy.nav_tracker:field_position()
		local better_cover, best_cover_invalid

		if objective and objective.type == "follow" then
			local near_pos = objective.follow_unit:movement():m_pos()

			if not best_cover or not CopLogicAttack._verify_follow_cover(best_cover[1], near_pos, threat_pos, 200, 1000) then
				local nav_seg = objective.follow_unit:movement():nav_tracker():nav_segment()
				local max_dis = objective.distance and objective.distance * 0.9
				local found_cover = managers.navigation:find_cover_in_nav_seg_3(nav_seg, max_dis, near_pos, threat_pos)

				if found_cover then
					better_cover = {
						found_cover,
					}
				end
			end
		else
			local flank_cover = my_data.flank_cover and not my_data.flank_cover.failed and my_data.flank_cover
			local min_dis = my_data.want_to_take_cover and my_data.weapon_range.close * 0.5 or nil

			if flank_cover or not best_cover or not CopLogicAttack._verify_cover(best_cover[1], threat_pos, min_dis, nil) then
				local dir, near_pos, furthest_pos = tmp_vec1, tmp_vec2, tmp_vec3
				local optimal_dis = mvector3.direction(dir, threat_pos, data.m_pos)
				local max_dis = my_data.weapon_range.far

				if flank_cover then
					mvector3.rotate_with(dir, Rotation(flank_cover.angle))
				end

				if min_dis and optimal_dis < min_dis or optimal_dis > my_data.weapon_range.optimal * 1.2 then
					optimal_dis = my_data.weapon_range.optimal
				end

				mvector3.set(near_pos, threat_pos)
				mvector3.add_scaled(near_pos, dir, optimal_dis)

				mvector3.set(furthest_pos, threat_pos)
				mvector3.add_scaled(furthest_pos, dir, max_dis)

				local found_cover
				if objective and objective.grp_objective and objective.grp_objective.type == "reenforce_area" then
					local nav_seg = objective.area and objective.area.nav_segs or objective.nav_seg
					found_cover = managers.navigation:find_cover_from_threat(nav_seg, optimal_dis, near_pos, threat_pos)
				else
					local angle = flank_cover and flank_cover.step or math.map_range(optimal_dis, 0, max_dis, 90, 60)
					found_cover = managers.navigation:find_cover_in_cone_from_threat_pos_1(threat_pos, furthest_pos, near_pos, nil, angle, nil, nil, nil, data.pos_rsrv_id)
				end

				if found_cover and CopLogicAttack._verify_cover(found_cover, threat_pos, min_dis, max_dis) then
					better_cover = {
						found_cover,
					}
				elseif flank_cover then
					if math.sign(flank_cover.angle) == flank_cover.sign then
						flank_cover.angle = -flank_cover.angle
					else
						flank_cover.angle = flank_cover.angle + flank_cover.step * flank_cover.sign
						if math.abs(flank_cover.angle) > 90 then
							flank_cover.failed = true
						end
					end
				elseif best_cover then
					best_cover_invalid = true
				end
			end
		end

		if better_cover then
			CopLogicAttack._set_best_cover(data, my_data, better_cover)

			local offset_pos, yaw = CopLogicAttack._get_cover_offset_pos(data, better_cover, threat_pos)
			if offset_pos then
				better_cover[5] = offset_pos
				better_cover[6] = yaw
			end
		elseif best_cover_invalid then
			CopLogicAttack._set_best_cover(data, my_data, nil)
		end
	end

	if my_data.in_cover then
		my_data.in_cover[3], my_data.in_cover[4] = CopLogicAttack._chk_covered(data, data.m_pos, focus_enemy.verified_pos, data.visibility_slotmask)
	end
end

-- Improve check for cover requirement
function CopLogicAttack._chk_wants_to_take_cover(data, my_data)
	if not data.attention_obj or data.attention_obj.reaction < AIAttentionObject.REACT_COMBAT then
		return
	end

	if my_data.moving_to_cover or data.is_suppressed or my_data.attitude ~= "engage" then
		return true
	end

	if data.attention_obj.verified and data.attention_obj.dis < my_data.weapon_range.close * 0.5 then
		return true
	end

	if data.unit:inventory():equipped_unit():base():get_ammo_ratio() < 0.3 then
		return true
	end
end

-- Improve Marshal combat movement, they really just need to try to keep their distance
function MarshalLogicAttack._upd_combat_movement(data)
	local my_data = data.internal_data
	local focus_enemy = data.attention_obj

	if data.logic.action_taken(data, my_data) or CopLogicAttack._upd_pose(data, my_data) then
		return
	end

	if data.unit:movement():chk_action_forbidden("walk") or not CopLogicAttack._can_move(data) then
		return
	end

	if focus_enemy.verified then
		if CopLogicAttack._chk_start_action_move_back(data, my_data, focus_enemy, true, "optimal") then
			return
		end

		if data.important then
			if data.is_suppressed and data.t - data.unit:character_damage():last_suppression_t() < 0.7 then
				if CopLogicBase.chk_start_action_dodge(data, "scared") then
					return
				end
			end

			if focus_enemy.is_person and focus_enemy.dis < 2000 and (data.group and data.group.size > 1 or math.random() < 0.5) then
				local dodge

				if focus_enemy.is_local_player then
					local e_movement_state = focus_enemy.unit:movement():current_state()
					if not e_movement_state:_is_reloading() and not e_movement_state:_interacting() and not e_movement_state:is_equipping() then
						dodge = true
					end
				else
					local e_anim_data = focus_enemy.unit:anim_data()
					if (e_anim_data.move or e_anim_data.idle) and not e_anim_data.reload then
						dodge = true
					end
				end

				if dodge and focus_enemy.aimed_at and CopLogicBase.chk_start_action_dodge(data, "preemptive") then
					return
				end
			end
		end
	end

	CopLogicAttack._chk_start_action_move_out_of_the_way(data, my_data)
end

function MarshalLogicAttack.update_cover(data) end

--Medic attack logic
MedicLogicAttack = MedicLogicAttack or class(CopLogicAttack)

function MedicLogicAttack._upd_combat_movement(data)
	local my_data = data.internal_data
	local focus_enemy = data.attention_obj

	if data.logic.action_taken(data, my_data) or CopLogicAttack._upd_pose(data, my_data) then
		return
	end

	if data.unit:movement():chk_action_forbidden("walk") or not CopLogicAttack._can_move(data) then
		return
	end

	if focus_enemy.verified then
		if CopLogicAttack._chk_start_action_move_back(data, my_data, focus_enemy, true, "optimal") then
			return
		end
	end

	CopLogicAttack._chk_start_action_move_out_of_the_way(data, my_data)
end
