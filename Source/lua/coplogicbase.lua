local math_random = math.random
local mrot_y = mrotation.y
local mvec3_add = mvector3.add
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_mul = mvector3.multiply
local mvec3_neg = mvector3.negate
local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
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
Hooks:PreHook(CopLogicBase, "on_new_objective", "sh_on_new_objective", function (data, old_objective)
	if not data.objective or data.objective.type ~= "defend_area" or not data.group or not data.tactics or not data.tactics.shield_cover then
		return
	end

	local shielding_units = {}
	if old_objective and alive(old_objective.shield_cover_unit) then
		table.insert(shielding_units, old_objective.shield_cover_unit)
	else
		local logic_data
		for _, u_data in pairs(data.group.units) do
			logic_data = u_data.unit:brain()._logic_data
			if logic_data and logic_data.tactics and logic_data.tactics.shield then
				table.insert(shielding_units, u_data.unit)
			end
		end
	end

	if #shielding_units > 0 then
		data.objective.type = "follow"
		data.objective.shield_cover_unit = table.random(shielding_units)
		data.objective.follow_unit = data.objective.shield_cover_unit
		data.objective.path_data = nil
		data.objective.distance = 300
	end
end)


-- Remove follow unit as soon as it dies, not just after the body despawned
function CopLogicBase.on_objective_unit_damaged(data, unit, attacker_unit)
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
	if dodge_tweak.chance == 0 or dodge_tweak.chance < math_random() then
		return
	end

	local enemy_dir = tmp_vec3
	if data.attention_obj and data.attention_obj.reaction >= AIAttentionObject.REACT_COMBAT then
		mvec3_set(enemy_dir, data.attention_obj.m_pos)
		mvec3_sub(enemy_dir, data.m_pos)
		mvec3_set_z(enemy_dir, 0)
		mvector3.normalize(enemy_dir)
	else
		mvector3.set(enemy_dir, math.UP)
		mvector3.random_orthogonal(enemy_dir)
	end

	local dodge_dir = mvector3.copy(enemy_dir)
	mvector3.cross(dodge_dir, enemy_dir, math.UP)
	if math_random() < 0.5 then
		mvec3_neg(dodge_dir)
	end

	local test_space, available_space, min_space, prefered_space = 0, 0, 90, 130
	local ray_params = {
		trace = true,
		tracker_from = data.unit:movement():nav_tracker(),
		pos_to = tmp_vec1
	}

	mvec3_set(ray_params.pos_to, dodge_dir)
	mvec3_mul(ray_params.pos_to, prefered_space)
	mvec3_add(ray_params.pos_to, data.m_pos)
	local ray_hit1 = managers.navigation:raycast(ray_params)
	if ray_hit1 then
		mvec3_set(tmp_vec2, ray_params.trace[1])
		mvec3_sub(tmp_vec2, data.m_pos)
		mvec3_set_z(tmp_vec2, 0)
		test_space = mvector3.length(tmp_vec2)
	else
		test_space = prefered_space
	end

	if test_space >= min_space then
		available_space = test_space
	end

	mvec3_set(ray_params.pos_to, dodge_dir)
	mvec3_mul(ray_params.pos_to, -prefered_space)
	mvec3_add(ray_params.pos_to, data.m_pos)
	local ray_hit2 = managers.navigation:raycast(ray_params)
	if ray_hit2 then
		mvec3_set(tmp_vec2, ray_params.trace[1])
		mvec3_sub(tmp_vec2, data.m_pos)
		mvec3_set_z(tmp_vec2, 0)
		test_space = mvector3.length(tmp_vec2)
	elseif available_space < prefered_space then
		test_space = prefered_space
	end

	if test_space >= min_space and test_space > available_space then
		available_space = test_space
		mvec3_neg(dodge_dir)
	end

	-- Give enemies a chance to dodge backwards if dodging to the side is not possible or if dodging backwards has more space
	if available_space < min_space or data.attention_obj and math_random() < math.max(0, 1 - data.attention_obj.dis / 500) then
		mvec3_set(ray_params.pos_to, enemy_dir)
		mvec3_mul(ray_params.pos_to, -prefered_space)
		mvec3_add(ray_params.pos_to, data.m_pos)
		local ray_hit3 = managers.navigation:raycast(ray_params)
		if ray_hit3 then
			mvec3_set(tmp_vec2, ray_params.trace[1])
			mvec3_sub(tmp_vec2, data.m_pos)
			mvec3_set_z(tmp_vec2, 0)
			test_space = mvector3.length(tmp_vec2)
		else
			test_space = prefered_space
		end

		if test_space >= min_space and test_space >= available_space then
			available_space = test_space
			mvec3_set(dodge_dir, enemy_dir)
			mvec3_neg(dodge_dir)
		end
	end

	if available_space < min_space then
		return
	end

	mrotation.x(data.unit:movement():m_rot(), tmp_vec1)
	local right_dot = mvec3_dot(dodge_dir, tmp_vec1)
	local fwd_dot = mvec3_dot(dodge_dir, data.unit:movement():m_fwd())
	local dodge_side =  math.abs(fwd_dot) > 0.6 and (fwd_dot > 0 and "fwd" or "bwd") or right_dot > 0 and "r" or "l"

	local rand_nr = math_random()
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
	if shoot_chance and shoot_chance > 0 and math_random() < shoot_chance then
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
			bleedout = -1,
			dodge = -1,
			walk = -1,
			action = body_part == 1 and -1 or nil,
			aim = body_part == 1 and -1 or nil
		}
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


-- Check for minimum objective interruption distance
local is_obstructed_original = CopLogicBase.is_obstructed
function CopLogicBase.is_obstructed(data, objective, strictness, attention, ...)
	local min_obj_interrupt_dis = data.char_tweak.min_obj_interrupt_dis
	if not min_obj_interrupt_dis or not objective or not objective.interrupt_dis or objective.interrupt_dis < 0 then
		return is_obstructed_original(data, objective, strictness, attention, ...)
	end

	attention = attention or data.attention_obj
	if not attention or not attention.verified then
		-- This is an additional multiplier, is_obstructed already halves when not visible, but for larger ranges thats not enough
		min_obj_interrupt_dis = min_obj_interrupt_dis * 0.25
	end

	local interrupt_dis = objective.interrupt_dis
	objective.interrupt_dis = math.max(interrupt_dis, min_obj_interrupt_dis)
	local allow_trans, obj_failed = is_obstructed_original(data, objective, strictness, attention, ...)
	objective.interrupt_dis = interrupt_dis

	return allow_trans, obj_failed
end


-- Fix function not working accurately for clients/NPCs
function CopLogicBase.chk_am_i_aimed_at(data, attention_obj, max_dot)
	if not attention_obj.is_person then
		return
	end

	if attention_obj.dis < 1000 then
		max_dot = math.lerp(max_dot * 0.75, max_dot, attention_obj.dis / 1000)
	end

	if attention_obj.is_local_player then
		mrot_y(attention_obj.unit:movement():m_head_rot(), tmp_vec1)
	elseif attention_obj.is_husk_player then
		mvec3_set(tmp_vec1, attention_obj.unit:movement():detect_look_dir())
	else
		mvec3_set(tmp_vec1, attention_obj.unit:movement()._action_common_data.look_vec)
	end

	mvec3_dir(tmp_vec2, attention_obj.m_head_pos, data.unit:movement():m_com())

	return max_dot < mvec3_dot(tmp_vec2, tmp_vec1)
end