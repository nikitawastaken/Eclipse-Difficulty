local math_lerp = math.lerp
local math_random = math.random
local mrot_axis_angle = mrotation.set_axis_angle
local mvec3_add = mvector3.add
local mvec3_cross = mvector3.cross
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_norm = mvector3.normalize
local mvec3_rot = mvector3.rotate_with
local mvec3_set = mvector3.set
local mvec3_set_l = mvector3.set_length
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local temp_rot1 = Rotation()
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()

-- Helper function to reset variables when shooting is stopped
function CopActionShoot:_stop_firing()
	self._is_single_shot = nil
	if self._autofiring then
		self._autofiring = nil
		self._weapon_base:stop_autofire()
	end
end

-- Set some values needed for fixed focus and aim delay
Hooks:PostHook(CopActionShoot, "on_attention", "sh_on_attention", function(self)
	-- Stop autofiring on target change
	if not self._w_usage_tweak.no_autofire_stop then
		self:_stop_firing()
	end

	-- This is not needed here, it is already set by the IK functions if needed and just artificially delays enemies shooting
	self._mod_enable_t = 0

	if self._attention and self._attention.unit then
		self._next_vis_ray_t = 0
		self._apply_aim_focus_delay = true
		self._shooting_husk_player = self._attention.unit:base() and self._attention.unit:base().is_husk_player
	else
		self._apply_aim_focus_delay = false
	end
end)

-- Thanks to the messy implementation of this function, we have to replace it completely, no hook can save us here
function CopActionShoot:update(t)
	local vis_state = self._ext_base:lod_stage() or 4
	if vis_state ~= 1 then
		if self._skipped_frames < vis_state * 3 then
			self._skipped_frames = self._skipped_frames + 1
			return
		else
			self._skipped_frames = 1
		end
	end

	if self._ext_anim.base_need_upd then
		self._ext_movement:upd_m_head_pos()
	end

	local shoot_from_pos = self._shoot_from_pos
	local ext_anim = self._ext_anim
	local target_vec, target_dis, target_pos

	if self._attention then
		target_pos, target_vec, target_dis = self:_get_target_pos(shoot_from_pos, self._attention, t)
		local tar_vec_flat = temp_vec1
		mvec3_set(tar_vec_flat, target_vec)
		mvec3_set_z(tar_vec_flat, 0)
		mvec3_norm(tar_vec_flat)
		local fwd = self._common_data.fwd
		local fwd_dot = mvec3_dot(fwd, tar_vec_flat)
		-- This originally only executed on client side which causes great inconsistencies in enemy turning behaviour
		-- between host and client. Reworking the turning condition and enabling it for the host too should fix that.
		if CopActionIdle._can_turn(self) then
			local spin = tar_vec_flat:to_polar_with_reference(fwd, math.UP).spin
			if math.abs(spin) > 25 then
				self._ext_movement:action_request({
					body_part = 2,
					type = "turn",
					angle = spin,
				})
			end
		end
		target_vec = self:_upd_ik(target_vec, fwd_dot, t)
	end

	if ext_anim.reload then
		if self._looped_expire_t and self._looped_expire_t < t then
			self._looped_expire_t = nil
			self._ext_movement:play_redirect("reload_looped_exit")
		end
		return
	elseif ext_anim.melee then
		self._shoot_t = t + 0.25
		return
	elseif ext_anim.equip then
		return
	end

	-- Reload
	if self._weapon_base:clip_empty() then
		self:_stop_firing()
		CopActionReload._play_reload(self, t)
		return
	end

	-- Stop shooting
	if not target_vec or not target_dis or not target_pos or not self._common_data.allow_fire then
		self:_stop_firing()
		return
	end

	-- Melee
	if self:_chk_start_melee(t, target_dis, target_pos) then
		return
	end

	-- Shield flash
	if self._shield_use_cooldown and self._shield_use_cooldown < t and target_dis < self._shield_use_range then
		self._shield_use_cooldown = self._shield_base:request_use(t) or self._shield_use_cooldown
	end

	-- Update shooting
	if self._autofiring then
		local falloff, i_range = self:_get_shoot_falloff(target_dis, self._falloff)
		local dmg_buff = self._unit:base():get_total_buff("base_damage")
		local dmg_mul = (1 + dmg_buff) * falloff.dmg_mul

		target_pos = self:_get_unit_shoot_pos(t, target_pos, target_dis, self._w_usage_tweak, falloff, i_range, self._shooting_player) or target_pos
		mvec3_dir(target_vec, shoot_from_pos, target_pos)

		-- Pick and run the right shooting function
		local fire_func = self._is_single_shot and self._weapon_base.singleshot or self._weapon_base.trigger_held
		local fired = fire_func(self._weapon_base, shoot_from_pos, target_vec, dmg_mul, self._shooting_player, nil, nil, nil, self._attention.unit)
		if not fired then
			return
		end

		self._autofiring = self._autofiring and self._autofiring - 1 or 0
		if self._autofiring <= 0 then
			self:_stop_firing()
			self._shoot_t = t + (self._common_data.is_suppressed and 1.5 or 1) * math_lerp(falloff.recoil[1], falloff.recoil[2], self:_pseudorandom())
		end

		if vis_state == 1 and not ext_anim.base_no_recoil then
			self._ext_movement:play_redirect("recoil_single")
		end

		if fired.hit_enemy and fired.hit_enemy.type == "death" and self._unit:unit_data().mission_element then
			self._unit:unit_data().mission_element:event("killshot", self._unit)
		end

		return
	end

	-- Apply aim and focus delay
	if self._apply_aim_focus_delay then
		if t < self._next_vis_ray_t then
			return
		elseif self._shooting_player and self._unit:raycast("ray", shoot_from_pos, target_pos, "slot_mask", self._verif_slotmask, "ray_type", "ai_vision", "report") then
			self._next_vis_ray_t = t + 0.05
			return
		end

		local aim_delay_minmax = self._w_usage_tweak.aim_delay
		local aim_delay = math.map_range_clamped(target_dis, 0, self._falloff[#self._falloff].r, aim_delay_minmax[1], aim_delay_minmax[2])

		self._shoot_t = math.max(self._shoot_t, t + aim_delay * (self._common_data.is_suppressed and 1.5 or 1))

		self._shoot_history.focus_start_t = self._shoot_t
		self._shoot_history.focus_delay = self._w_usage_tweak.focus_delay

		self._apply_aim_focus_delay = false

		return
	end

	-- Start shooting
	if self._shoot_t < t and self._mod_enable_t < t then
		if self._common_data.char_tweak.no_move_and_shoot and ext_anim.move then
			self._shoot_t = t + (self._common_data.char_tweak.move_and_shoot_cooldown or 1)
			return
		end

		local num_rounds = 1
		if self._automatic_weap then
			local falloff = self:_get_shoot_falloff(target_dis, self._falloff)
			if falloff.autofire_rounds then
				num_rounds = self:_pseudorandom(falloff.autofire_rounds[1], falloff.autofire_rounds[2])
			elseif self._w_usage_tweak.autofire_rounds then
				local f = math.map_range(target_dis, self._falloff[1].r, self._falloff[#self._falloff].r, 0, 1)
				local autofire_rounds = self._w_usage_tweak.autofire_rounds
				num_rounds = math.ceil(math.map_range_clamped(f - 0.15 + self:_pseudorandom() * 0.3, 0, 1, autofire_rounds[2], autofire_rounds[1]))
			end
		end

		self._is_single_shot = num_rounds == 1
		self._autofiring = num_rounds
		if num_rounds > 1 then
			self._weapon_base:start_autofire(num_rounds < 4 and num_rounds)
		end
	end
end

-- Remove pseudrandom hitchance and hit chance interpolation (interpolation is already done in _get_shoot_falloff)
function CopActionShoot:_get_unit_shoot_pos(t, pos, dis, w_tweak, falloff, i_range, shooting_player)
	local shoot_hist = self._shoot_history
	local focus_delay, focus_prog
	if shoot_hist and shoot_hist.focus_delay then
		focus_delay = (shooting_player and self._attention.unit:character_damage():focus_delay_mul() or 1) * shoot_hist.focus_delay
		focus_prog = focus_delay > 0 and (t - shoot_hist.focus_start_t) / focus_delay
		if not focus_prog or focus_prog >= 1 then
			shoot_hist.focus_delay = nil
			focus_prog = 1
		end
	else
		focus_prog = 1
	end

	local hit_chance = math_lerp(falloff.acc[1], falloff.acc[2], focus_prog) * self._unit:character_damage():accuracy_multiplier()

	if self._common_data.is_suppressed then
		hit_chance = hit_chance * 0.5
	end

	if self._common_data.active_actions[2] and self._common_data.active_actions[2]:type() == "dodge" then
		hit_chance = hit_chance * self._common_data.active_actions[2]:accuracy_multiplier()
	end

	if self._miss_first_player_shot and (shooting_player or self._shooting_husk_player) then
		self._miss_first_player_shot = nil
		self._ext_movement.missed_first_shot = true
		hit_chance = 0
	end

	local hit = math_random() < hit_chance

	mvec3_set(temp_vec1, pos)
	mvec3_sub(temp_vec1, self._shoot_from_pos)

	mvec3_cross(temp_vec2, temp_vec1, math.UP)
	mrot_axis_angle(temp_rot1, temp_vec1, math_random(360))
	mvec3_rot(temp_vec2, temp_rot1)

	local miss_min_dis = shooting_player and 31 or 150
	local hit_max_dis = shooting_player and 25 or 7
	local error_vec_len = hit and hit_max_dis * math_random() or miss_min_dis + 100 * (1 - hit_chance) * (2 - focus_prog) * math_random()

	mvec3_set_l(temp_vec2, error_vec_len)
	mvec3_add(temp_vec2, pos)

	return temp_vec2
end

-- Interpolate between entries in the FALLOFF table to prevent sudden changes in damage etc
function CopActionShoot:_get_shoot_falloff(target_dis, falloff)
	local i = #falloff
	local data = falloff[i]
	for i_range, range_data in ipairs(falloff) do
		if target_dis < range_data.r then
			i = i_range
			data = range_data
			break
		end
	end
	if i == 1 or target_dis > data.r then
		return data, i
	else
		local prev_data = falloff[i - 1]
		local t = (target_dis - prev_data.r) / (data.r - prev_data.r)
		local n_data = {
			r = target_dis,
			dmg_mul = math_lerp(prev_data.dmg_mul, data.dmg_mul, t),
			acc = {
				math_lerp(prev_data.acc[1], data.acc[1], t),
				math_lerp(prev_data.acc[2], data.acc[2], t),
			},
			recoil = {
				math_lerp(prev_data.recoil[1], data.recoil[1], t),
				math_lerp(prev_data.recoil[2], data.recoil[2], t),
			},
			autofire_rounds = prev_data.autofire_rounds and data.autofire_rounds and {
				math_lerp(prev_data.autofire_rounds[1], data.autofire_rounds[1], t),
				math_lerp(prev_data.autofire_rounds[2], data.autofire_rounds[2], t),
			},
			mode = data.mode,
		}
		return n_data, i
	end
end

-- Do all the melee related checks inside this function
-- Adjust melee code to work against npcs
function CopActionShoot:_chk_start_melee(t, target_dis, target_pos)
	if self._shoot_t > t or self._mod_enable_t > t or not self._w_usage_tweak.melee_speed then
		return
	end

	local z_diff = math.abs(target_pos.z - self._shoot_from_pos.z)
	if z_diff > 200 or target_dis > math.sqrt(((self._w_usage_tweak.melee_range or 125) * 0.8) ^ 2 + z_diff ^ 2) then
		return
	end

	-- Only start melee if target is the local player (or an NPC on the server)
	if Network:is_client() and not self._shooting_player or Network:is_server() and self._shooting_husk_player then
		return
	end

	if self._melee_timeout_t > t or self._common_data.melee_countered_t and t - self._common_data.melee_countered_t < 15 then
		return
	end

	local attention_unit = self._attention.unit
	if not attention_unit or not attention_unit:character_damage() or not attention_unit:character_damage().damage_melee then
		return
	end

	if self._autofiring and math.random() < 0.75 then
		self._melee_timeout_t = t + self._w_usage_tweak.melee_retry_delay[1] * 0.25
		return
	end

	self:_stop_firing()

	if not self:_play_melee_anim(t) then
		return
	end

	self._melee_unit = attention_unit

	self._common_data.ext_network:send("action_melee_attack", self._body_part)

	return true
end

function CopActionShoot:_play_melee_anim(t)
	local melee_weapon = self._unit:base():melee_weapon()
	local state = self._ext_movement:play_redirect(melee_weapon == "weapon" and "melee" or melee_weapon == "bash" and "melee_bayonet" or "melee_item")
	if not state then
		return
	end

	if melee_weapon ~= "weapon" and melee_weapon ~= "bash" then
		local anim_attack_vars = self._common_data.char_tweak.melee_anims or { "var1", "var2" }
		local melee_var = self:_pseudorandom(#anim_attack_vars)
		self._common_data.machine:set_parameter(state, anim_attack_vars[melee_var], 1)

		local param = tweak_data.weapon.npc_melee[melee_weapon].animation_param
		self._common_data.machine:set_parameter(state, param, 1)
	end

	self._common_data.machine:set_speed(state, self._w_usage_tweak.melee_speed)

	local retry_delay = self._w_usage_tweak.melee_retry_delay
	self._melee_timeout_t = t + (retry_delay and math.lerp(retry_delay[1], retry_delay[2], self:_pseudorandom()) or 1)

	return true
end

function CopActionShoot:sync_start_melee()
	if not self._ext_anim.melee then
		self:_play_melee_anim(TimerManager:game():time())
	end
end

function CopActionShoot:anim_clbk_melee_strike()
	if not alive(self._melee_unit) then
		return
	end

	local target_pos = self._melee_unit:movement():m_head_pos()
	local z_diff = math.abs(target_pos.z - self._shoot_from_pos.z)
	if z_diff > 200 then
		return
	end

	local target_vec = temp_vec1
	local target_dis = mvec3_dir(target_vec, self._shoot_from_pos, target_pos)
	local max_dis = math.sqrt((self._w_usage_tweak.melee_range or 125) ^ 2 + z_diff ^ 2)
	if target_dis > max_dis then
		return
	end

	local tar_vec_flat = temp_vec2
	mvec3_set(tar_vec_flat, target_vec)
	mvec3_set_z(tar_vec_flat, 0)
	mvec3_norm(tar_vec_flat)

	local fwd = self._common_data.fwd
	local fwd_dot = mvec3_dot(fwd, tar_vec_flat)
	local min_dot = math.lerp(0.1, 0.5, target_dis / max_dis)
	if fwd_dot < min_dot then
		return
	end

	local hit_shield = self._unit:raycast("ray", self._shoot_from_pos, target_pos, "slot_mask", managers.slot:get_mask("enemy_shield_check"), "report")
	local defense_data = self._melee_unit:character_damage():damage_melee({
		variant = "melee",
		damage = hit_shield and 0 or (self._w_usage_tweak.melee_dmg or 10) * (1 + self._unit:base():get_total_buff("base_damage")),
		shield_knock = hit_shield,
		damage_effect = (self._w_usage_tweak.melee_force or 500) / 10,
		weapon_unit = self._weapon_unit,
		attacker_unit = self._common_data.unit,
		melee_weapon = self._unit:base():melee_weapon(),
		push_vel = tar_vec_flat:with_z(0.1) * (self._w_usage_tweak.melee_force or 500),
		col_ray = {
			position = self._shoot_from_pos + fwd * 50,
			ray = mvector3.copy(target_vec),
			body = self._melee_unit:body(0),
		},
	})

	local melee_tweak = tweak_data.weapon.npc_melee[self._unit:base():melee_weapon()]
	if melee_tweak and melee_tweak.tase_data then
		if self._attention.unit:character_damage().on_non_lethal_electrocution then
			if not self._attention.unit:character_damage().can_be_tased or self._attention.unit:character_damage():can_be_tased() then
				self._attention.unit:character_damage():on_non_lethal_electrocution(melee_tweak.tase_data.electrocution_time_mul)
			end
		elseif self._attention.unit:character_damage().damage_tase then
			self._attention.unit:character_damage():damage_tase({
				variant = melee_tweak.tase_data.tase_strength or "light",
				damage = 0,
				attacker_unit = self._unit,
				col_ray = {
					position = self._shoot_from_pos + fwd * 50,
					ray = mvector3.copy(target_vec),
				},
			})
		end
	end

	if defense_data ~= "countered" then
		if melee_tweak and melee_tweak.additional_impact_sound then
			self._unit:sound():play(melee_tweak.additional_impact_sound)
		end
	else
		self._common_data.melee_countered_t = TimerManager:game():time()
		self._unit:character_damage():damage_melee({
			damage_effect = 1,
			damage = 0,
			variant = "counter_spooc",
			attacker_unit = self._melee_unit,
			col_ray = {
				body = self._unit:body(0),
				position = self._common_data.pos + math.UP * 100,
			},
			attack_dir = -target_vec:normalized(),
			name_id = managers.blackmarket:equipped_melee_weapon(),
		})
	end

	self._melee_unit = nil
end
