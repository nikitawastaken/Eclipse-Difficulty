local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()

-- Instant detection outside of stealth
local _create_detected_attention_object_data_original = CopLogicBase._create_detected_attention_object_data
function CopLogicBase._create_detected_attention_object_data(...)
	local data = _create_detected_attention_object_data_original(...)
	if managers.groupai:state():enemy_weapons_hot() then
		data.notice_progress = 1
	end
	return data
end

-- Make shield_cover tactics stick closer to their shield tactics providers
-- Also handle units with unit_cover to follow a random unit in their group
Hooks:PreHook(CopLogicBase, "on_new_objective", "sh_on_new_objective", function(data, old_objective)
	if not data.objective or data.objective.type ~= "defend_area" or not data.group then
		return
	end

	if not data.tactics or not data.tactics.shield_cover and not data.tactics.unit_cover then
		return
	end

	local cover_unit = old_objective and old_objective.cover_unit
	if not alive(cover_unit) or cover_unit:character_damage():dead() then
		local followers = {}
		for u_key, u_data in pairs(data.group.units) do
			local logic_data = alive(u_data.unit) and u_data.unit:brain()._logic_data
			if logic_data and logic_data.tactics then
				if logic_data.tactics.shield_cover or logic_data.tactics.unit_cover then
					local unit = logic_data.objective and logic_data.objective.cover_unit
					if alive(unit) and not unit:character_damage():dead() then
						local unit_key = unit:key()
						if data.group.units[unit_key] then
							followers[unit_key] = followers[unit_key] or { amount = 0 }
							followers[unit_key].amount = followers[unit_key].amount + 1
						end
					end
				else
					followers[u_key] = followers[u_key] or { amount = 0 }
					followers[u_key].is_shield = logic_data.tactics.shield
				end
			end
		end

		local best_u_key, best_is_shield
		local least_followers = math.huge
		for u_key, follower_data in pairs(followers) do
			if follower_data.is_shield or not data.tactics.shield_cover or data.tactics.unit_cover and not best_is_shield then
				if follower_data.amount < least_followers or data.tactics.shield_cover and follower_data.is_shield and not best_is_shield then
					best_u_key = u_key
					best_is_shield = follower_data.is_shield
					least_followers = follower_data.amount
				end
			end
		end

		cover_unit = best_u_key and data.group.units[best_u_key].unit
	end

	if cover_unit then
		data.objective.type = "follow"
		data.objective.cover_unit = cover_unit
		data.objective.follow_unit = cover_unit
		data.objective.path_data = nil
		data.objective.distance = 300
	end
end)

-- Remove follow unit as soon as it dies, not just after the body despawned
function CopLogicBase.on_objective_unit_damaged(data, unit, _)
	if unit:character_damage()._dead then
		data.objective_failed_clbk(data.unit, data.objective)
	end
end

-- Allow more dodge directions
function CopLogicBase.chk_start_action_dodge(data, reason)
	if not data.char_tweak.dodge or not data.char_tweak.dodge.occasions[reason] then
		return
	end

	if data.dodge_timeout_t and data.t < data.dodge_timeout_t or data.unit:movement():chk_action_forbidden("walk") then
		return
	end

	if data.dodge_chk_timeout_t and data.t < data.dodge_chk_timeout_t and reason ~= "hit" then
		return
	end

	-- Consistent dodge check cooldown
	data.dodge_chk_timeout_t = TimerManager:game():time() + 0.5

	local dodge_tweak = data.char_tweak.dodge.occasions[reason]
	if dodge_tweak.chance == 0 or dodge_tweak.chance < math.random() then
		return
	end

	local enemy_dir = tmp_vec3
	if data.attention_obj and data.attention_obj.reaction >= AIAttentionObject.REACT_COMBAT then
		mvector3.set(enemy_dir, data.attention_obj.m_pos)
		mvector3.subtract(enemy_dir, data.m_pos)
		mvector3.set_z(enemy_dir, 0)
		mvector3.normalize(enemy_dir)
	else
		mvector3.set(enemy_dir, math.UP)
		mvector3.random_orthogonal(enemy_dir)
	end

	local dodge_dir = mvector3.copy(enemy_dir)
	mvector3.cross(dodge_dir, enemy_dir, math.UP)
	if math.random() < 0.5 then
		mvector3.negate(dodge_dir)
	end

	local test_space, available_space, min_space, prefered_space = 0, 0, 90, 130
	local ray_params = {
		trace = true,
		tracker_from = data.unit:movement():nav_tracker(),
		pos_to = tmp_vec1,
	}

	mvector3.set(ray_params.pos_to, dodge_dir)
	mvector3.multiply(ray_params.pos_to, prefered_space)
	mvector3.add(ray_params.pos_to, data.m_pos)
	local ray_hit1 = managers.navigation:raycast(ray_params)
	if ray_hit1 then
		mvector3.set(tmp_vec2, ray_params.trace[1])
		mvector3.subtract(tmp_vec2, data.m_pos)
		mvector3.set_z(tmp_vec2, 0)
		test_space = mvector3.length(tmp_vec2)
	else
		test_space = prefered_space
	end

	if test_space >= min_space then
		available_space = test_space
	end

	mvector3.set(ray_params.pos_to, dodge_dir)
	mvector3.multiply(ray_params.pos_to, prefered_space)
	mvector3.add(ray_params.pos_to, data.m_pos)
	local ray_hit2 = managers.navigation:raycast(ray_params)
	if ray_hit2 then
		mvector3.set(tmp_vec2, ray_params.trace[1])
		mvector3.subtract(tmp_vec2, data.m_pos)
		mvector3.set_z(tmp_vec2, 0)
		test_space = mvector3.length(tmp_vec2)
	elseif available_space < prefered_space then
		test_space = prefered_space
	end

	if test_space >= min_space and test_space > available_space then
		available_space = test_space
		mvector3.negate(dodge_dir)
	end

	-- Give enemies a chance to dodge backwards if dodging to the side is not possible or if dodging backwards has more space
	if available_space < min_space or data.attention_obj and math.random() < math.max(0, 1 - data.attention_obj.dis / 500) then
		mvector3.set(ray_params.pos_to, enemy_dir)
		mvector3.multiply(ray_params.pos_to, -prefered_space)
		mvector3.add(ray_params.pos_to, data.m_pos)
		local ray_hit3 = managers.navigation:raycast(ray_params)
		if ray_hit3 then
			mvector3.set(tmp_vec2, ray_params.trace[1])
			mvector3.subtract(tmp_vec2, data.m_pos)
			mvector3.set_z(tmp_vec2, 0)
			test_space = mvector3.length(tmp_vec2)
		else
			test_space = prefered_space
		end

		if test_space >= min_space and test_space >= available_space then
			available_space = test_space
			mvector3.set(dodge_dir, enemy_dir)
			mvector3.negate(dodge_dir)
		end
	end

	if available_space < min_space then
		return
	end

	mrotation.x(data.unit:movement():m_rot(), tmp_vec1)
	local right_dot = mvector3.dot(dodge_dir, tmp_vec1)
	local fwd_dot = mvector3.dot(dodge_dir, data.unit:movement():m_fwd())
	local dodge_side = math.abs(fwd_dot) > 0.6 and (fwd_dot > 0 and "fwd" or "bwd") or right_dot > 0 and "r" or "l"

	local rand_nr = math.random()
	local total_chance = 0
	local variation, variation_data
	for test_variation, test_variation_data in pairs(dodge_tweak.variations) do
		total_chance = total_chance + test_variation_data.chance

		if test_variation_data.chance > 0 and rand_nr <= total_chance then
			variation = test_variation
			variation_data = test_variation_data
			break
		end
	end

	local body_part = 1
	local shoot_chance = variation_data.shoot_chance
	if shoot_chance and shoot_chance > 0 and math.random() < shoot_chance then
		body_part = 2
	end

	local action_data = {
		type = "dodge",
		body_part = body_part,
		variation = variation,
		side = dodge_side,
		direction = dodge_dir,
		timeout = variation_data.timeout,
		speed = data.char_tweak.dodge.speed,
		shoot_accuracy = variation_data.shoot_accuracy,
		blocks = {
			act = -1,
			tase = -1,
			dodge = -1,
			walk = -1,
			action = body_part == 1 and -1 or nil,
			aim = body_part == 1 and -1 or nil,
		},
	}

	if variation ~= "side_step" then
		action_data.blocks.hurt = -1
		action_data.blocks.heavy_hurt = -1
	end

	local action = data.unit:movement():action_request(action_data)
	if action then
		local my_data = data.internal_data

		CopLogicAttack._cancel_cover_pathing(data, my_data)
		CopLogicAttack._cancel_charge(data, my_data)
		CopLogicAttack._cancel_expected_pos_path(data, my_data)
		CopLogicAttack._cancel_walking_to_cover(data, my_data, true)
	end

	return action
end

-- Check for verified interrupt distance and remove bad marshal interrupt distance
function CopLogicBase.is_obstructed(data, objective, strictness, attention)
	attention = attention or data.attention_obj
	strictness = 1 - (strictness or 0)

	if not objective or objective.is_default or (objective.in_place or not objective.nav_seg) and not objective.action then
		return true, false
	end

	if objective.interrupt_suppression and data.is_suppressed then
		return true, true
	end

	if objective.interrupt_health then
		local health_ratio = data.unit:character_damage():health_ratio()
		if health_ratio < 1 and health_ratio * strictness < objective.interrupt_health or data.unit:character_damage():dead() then
			return true, true
		end
	end

	if objective.interrupt_dis then
		if attention and (AIAttentionObject.REACT_COMBAT <= attention.reaction or data.cool and AIAttentionObject.REACT_SURPRISED <= attention.reaction) then
			if objective.interrupt_dis == -1 then
				return true, true
			end

			if attention.verified and data.char_tweak.min_obj_interrupt_dis then
				if attention.dis * strictness < data.char_tweak.min_obj_interrupt_dis then
					return true, true
				end
			end

			if math.abs(attention.m_pos.z - data.m_pos.z) < 250 then
				if attention.dis * strictness * (attention.verified and 1 or 2) < objective.interrupt_dis then
					return true, true
				end
			end

			if objective.pos and math.abs(attention.m_pos.z - objective.pos.z) < 250 then
				if mvector3.distance(objective.pos, attention.m_pos) * strictness < objective.interrupt_dis then
					return true, true
				end
			end
		elseif objective.interrupt_dis == -1 and not data.cool then
			return true, true
		end
	end

	return false, false
end

-- Fix function not working accurately for clients/NPCs
function CopLogicBase.chk_am_i_aimed_at(data, attention_obj, max_dot)
	if not attention_obj.is_person then
		return
	end

	if attention_obj.dis < 1000 then
		max_dot = math.lerp(max_dot * 0.75, max_dot, attention_obj.dis / 1000)
	end

	mvector3.set(tmp_vec1, attention_obj.unit:movement():detect_look_dir())
	mvector3.direction(tmp_vec2, attention_obj.m_head_pos, data.unit:movement():m_com())

	return max_dot < mvector3.dot(tmp_vec2, tmp_vec1)
end

-- Reduce maximum update delay
local _upd_attention_obj_detection_original = CopLogicBase._upd_attention_obj_detection
function CopLogicBase._upd_attention_obj_detection(data, ...)
	local delay = _upd_attention_obj_detection_original(data, ...)
	return data.cool and delay or math.min(0.5, delay)
end

-- Fix incorrect checks and improve surrender conditions
-- Move surrender reason checks outside so they are easier to extend for other mods
CopLogicBase.surrender_chk_funcs = {
	health = function(data, aggressor_unit, surrender_data)
		local health_ratio = data.unit:character_damage():health_ratio()
		if health_ratio >= 1 then
			return
		end

		local min_ratio, max_ratio, min_chance, max_chance
		for ratio, chance in pairs(surrender_data) do
			if not min_ratio or ratio < min_ratio then
				min_ratio = ratio
				min_chance = chance
			end

			if not max_ratio or ratio > max_ratio then
				max_ratio = ratio
				max_chance = chance
			end
		end

		if health_ratio < max_ratio then
			return 1 - math.map_range_clamped(health_ratio, min_ratio, max_ratio, min_chance, max_chance)
		end
	end,

	aggressor_dis = function(data, aggressor_unit, surrender_data)
		local agg_dis = mvector3.distance(data.m_pos, aggressor_unit:movement():m_pos())
		local min_dis, max_dis, min_chance, max_chance

		for dis, chance in pairs(surrender_data) do
			if not min_dis or dis < min_dis then
				min_dis = dis
				min_chance = chance
			end

			if not max_dis or dis > max_dis then
				max_dis = dis
				max_chance = chance
			end
		end

		if agg_dis < max_dis then
			return 1 - math.map_range_clamped(agg_dis, min_dis, max_dis, min_chance, max_chance)
		end
	end,

	weapon_down = function(data, aggressor_unit, surrender_data)
		local anim_data = data.unit:anim_data()
		if anim_data.reload or data.unit:inventory():equipped_unit():base():get_ammo_remaining_in_clip() == 0 then
			return 1 - surrender_data
		elseif anim_data.hurt then
			return 1 - surrender_data * 0.8
		end
	end,

	flanked = function(data, aggressor_unit, surrender_data)
		mvector3.direction(tmp_vec1, data.m_pos, aggressor_unit:movement():m_pos())
		local fwd_dot = mvector3.dot(data.unit:movement():m_fwd(), tmp_vec1)
		if fwd_dot < 0 then
			return 1 - surrender_data * math.abs(fwd_dot)
		end
	end,

	unaware_of_aggressor = function(data, aggressor_unit, surrender_data)
		local att_info = data.detected_attention_objects[aggressor_unit:key()]
		if not att_info or not att_info.identified or data.t - att_info.identified_t < 1 then
			return 1 - surrender_data
		end
	end,

	enemy_weap_cold = function(data, aggressor_unit, surrender_data)
		if not managers.groupai:state():enemy_weapons_hot() then
			return 1 - surrender_data
		end
	end,

	isolated = function(data, aggressor_unit, surrender_data)
		if not data.group or not data.group.has_spawned or data.group.initial_size <= 1 then
			return
		end

		local max_dis_sq = 800 ^ 2
		for u_key, u_data in pairs(data.group.units) do
			if u_key ~= data.key and mvector3.distance_sq(data.m_pos, u_data.m_pos) < max_dis_sq then
				return
			end
		end

		return 1 - surrender_data
	end,

	pants_down = function(data, aggressor_unit, surrender_data)
		local not_cool_t = data.unit:movement():not_cool_t()
		if (not not_cool_t or data.t - not_cool_t < 1.5) and not managers.groupai:state():enemy_weapons_hot() then
			return 1 - surrender_data
		end
	end,

	not_assault = function(data, aggressor_unit, surrender_data)
		if not managers.groupai:state():get_assault_mode() then
			return 1 - surrender_data
		end
	end,
}

function CopLogicBase._evaluate_reason_to_surrender(data, my_data, aggressor_unit)
	local surrender_tweak = data.char_tweak.surrender
	if not surrender_tweak then
		return
	end

	if surrender_tweak.base_chance >= 1 then
		return 0
	end

	if data.surrender_window and data.t > data.surrender_window.window_expire_t then
		return
	end

	local hold_chance = 1 - surrender_tweak.base_chance

	for reason, reason_data in pairs(surrender_tweak.reasons) do
		if CopLogicBase.surrender_chk_funcs[reason] then
			hold_chance = hold_chance * (CopLogicBase.surrender_chk_funcs[reason](data, aggressor_unit, reason_data) or 1)
		else
			Eclipse:warn_console("CopLogicBase.surrender_chk_funcs.%s does not exist", reason)
		end
	end

	if hold_chance > 1 - (surrender_tweak.significant_chance or 0) then
		return 1
	end

	for factor, factor_data in pairs(surrender_tweak.factors) do
		if CopLogicBase.surrender_chk_funcs[factor] then
			hold_chance = hold_chance * (CopLogicBase.surrender_chk_funcs[factor](data, aggressor_unit, factor_data) or 1)
		else
			Eclipse:warn_console("CopLogicBase.surrender_chk_funcs.%s does not exist", factor)
		end
	end

	if data.surrender_window then
		hold_chance = hold_chance * (1 - data.surrender_window.chance_mul)
	end

	if surrender_tweak.violence_timeout then
		local violence_t = data.unit:character_damage():last_suppression_t()
		if violence_t then
			local violence_dt = data.t - violence_t
			if violence_dt < surrender_tweak.violence_timeout then
				hold_chance = hold_chance + (1 - hold_chance) * (1 - violence_dt / surrender_tweak.violence_timeout)
			end
		end
	end

	return hold_chance < 1 and hold_chance
end

-- Change how alert ranges get diminished by walls
-- The bigger an alert range, the less it gets diminished by being blocked by a wall
function CopLogicBase._chk_alert_obstructed(listen_pos, alert_data)
	if not alert_data[3] then
		return false
	end

	local alert_epicenter
	if alert_data[1] == "bullet" then
		alert_epicenter = tmp_vec1
		mvector3.step(alert_epicenter, alert_data[2], alert_data[6], 20)
	else
		alert_epicenter = alert_data[2]
	end

	if not World:raycast("ray", listen_pos, alert_epicenter, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision", "report") then
		return false
	end

	if alert_data[1] == "footstep" then
		return true
	end

	local my_dis_sq = mvector3.distance_sq(listen_pos, alert_epicenter)
	local effective_dis_sq = (alert_data[3] * math.map_range_clamped(alert_data[3], 0, 10000, 0.75, 1)) ^ 2

	return my_dis_sq > effective_dis_sq
end

-- Add chance for enemies to comment on squad member deaths
Hooks:PostHook(CopLogicBase, "death_clbk", "sh_death_clbk", function(data, damage_info)
	if not data.group then
		return
	end

	local weapon_base = alive(damage_info.weapon_unit) and damage_info.weapon_unit:base()
	if weapon_base and weapon_base.is_category and weapon_base:is_category("trip_mine") then
		managers.groupai:state():_chk_say_group(data.group, "trip_mine")
	elseif weapon_base and weapon_base.is_category and weapon_base:is_category("saw") and math.random() < 0.75 then
		managers.groupai:state():_chk_say_group(data.group, "saw")
	elseif math.random() < (damage_info.variant == "melee" and 0.75 or 0.25) then
		managers.groupai:state():_chk_say_group(data.group, "group_death")
	end
end)

-- Disable forced voicelines
local empty_chatter = {}
local _set_attention_obj_original = CopLogicBase._set_attention_obj
function CopLogicBase._set_attention_obj(data, ...)
	local chatter = data.char_tweak.chatter
	data.char_tweak.chatter = empty_chatter

	_set_attention_obj_original(data, ...)

	data.char_tweak.chatter = chatter
end
