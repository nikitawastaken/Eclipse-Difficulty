local ids_single = Idstring("single")
local ids_auto = Idstring("auto")
local ids_burst = Idstring("burst")
local ids_volley = Idstring("volley")
local FIRE_MODE_IDS = {
	single = ids_single,
	auto = ids_auto,
	burst = ids_burst,
	volley = ids_volley,
}

Hooks:PostHook(NewRaycastWeaponBase, "init", "eclipse_init", function(self)
	self._spread_firing = 0
	self._spread_last_shot_t = 0
	self._shots_fired_consecutively = 0
	self._kick_pattern_shots_fired = 0
	self._kick_pattern_index = 1
	self._use_persist_pattern = false
	self._shield_knock = false
	self._is_incendiary_bstorm_active = false

	self._unit:set_extension_update_enabled(Idstring("base"), true)
end)

Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", "eclipse_update_stats_values", function(self, disallow_replenish)
	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
	local weapon_tweak = self:weapon_tweak_data()

	-- Extra start out ammo upgrade
	if not disallow_replenish and not (self._name_id and self._name_id:find("crew")) and not self:forbid_start_out_ammo() then
		local is_starting_out_with_extra_ammo = managers.player:has_category_upgrade("player", "start_out_ammo_multiplier")
		self:replenish(is_starting_out_with_extra_ammo)
	end

	-- Add and properly scale new index stats
	local new_stats = {}
	local parts_stats = managers.weapon_factory:get_stats(self._factory_id, self._blueprint)
	local bonus_stats = self._cosmetics_bonus
			and self._cosmetics_data
			and self._cosmetics_data.bonus
			and tweak_data.economy.bonuses[self._cosmetics_data.bonus]
			and tweak_data.economy.bonuses[self._cosmetics_data.bonus].stats
		or {}

	new_stats.swap_speed = weapon_tweak and weapon_tweak.stats and weapon_tweak.stats.swap_speed or 11
	new_stats.exit_run_speed = weapon_tweak and weapon_tweak.stats and weapon_tweak.stats.exit_run_speed or 11

	for new_stat, _ in pairs(new_stats) do
		if parts_stats[new_stat] then
			new_stats[new_stat] = new_stats[new_stat] + parts_stats[new_stat]
		end

		if bonus_stats[new_stat] then
			new_stats[new_stat] = new_stats[new_stat] + bonus_stats[new_stat]
		end

		new_stats[new_stat] = math.clamp(new_stats[new_stat], 1, #tweak_data.weapon.stats[new_stat])
	end

	if not self._current_stats then
		self._current_stats = {}
	end

	for new_stat, i in pairs(new_stats) do
		self._current_stats[new_stat] = tweak_data.weapon.stats[new_stat] and tweak_data.weapon.stats[new_stat][i] or 1

		if self:weapon_tweak_data().stats_modifiers and self:weapon_tweak_data().stats_modifiers[new_stat] then
			self._current_stats[new_stat] = self._current_stats[new_stat] * self:weapon_tweak_data().stats_modifiers[new_stat]
		end
	end

	self._swap_speed = self._current_stats.swap_speed or self._swap_speed
	self._exit_run_speed = self._current_stats.exit_run_speed or self._exit_run_speed

	self._volley_spread_mul = 1 -- Slightly hacky fix to 'volley' fire mode's spread_mul now being applied twice

	self._penetration_data = weapon_tweak.penetration

	self._max_nr_enemy_penetrations = weapon_tweak.max_nr_enemy_penetrations
	self._ammo_bag_consumption_mul = weapon_tweak.ammo_bag_consumption_mul

	self._steelsight_enter_time = weapon_tweak.steelsight_enter_time or 0.3
	self._exit_run_time = weapon_tweak.exit_run_time or 0.4

	self._steelsight_move_speed_mul = weapon_tweak.steelsight_move_speed_mul or 0.6

	self._swap_speed_multiplier = weapon_tweak.swap_speed_multiplier or 1
	self._fire_rate_multiplier = weapon_tweak.fire_rate_multiplier or 1
	self._reload_speed_multiplier = weapon_tweak.reload_speed_multiplier or 1
	self._exit_run_speed_multiplier = weapon_tweak.exit_run_speed_multiplier or 1

	self._spread = weapon_tweak.spread
	self._kick = weapon_tweak.kick
	self._spread_bloom = weapon_tweak.spread_bloom
	self._kick_pattern = weapon_tweak.kick_pattern

	for _, custom_stat in pairs(custom_stats) do
		if custom_stat.forbid_start_out_ammo ~= nil then
			self._forbid_start_out_ammo = custom_stat.forbid_start_out_ammo
		end

		if custom_stat.spread_override then
			self._spread = custom_stat.spread_override
		end

		if custom_stat.kick_override then
			self._kick = custom_stat.kick_override
		end

		if custom_stat.spread_bloom_override then
			self._spread_bloom = custom_stat.spread_bloom_override
		end

		if custom_stat.steelsight_move_speed_mul then
			self._steelsight_move_speed_mul = custom_stat.steelsight_move_speed_mul
		end

		if custom_stat.max_nr_enemy_penetrations then
			self._max_nr_enemy_penetrations = custom_stat.max_nr_enemy_penetrations
		end

		if custom_stat.ammo_bag_consumption_mul then
			self._ammo_bag_consumption_mul = custom_stat.ammo_bag_consumption_mul
		end

		if custom_stat.swap_speed_multiplier then
			self._swap_speed_multiplier = self._swap_speed_multiplier * custom_stat.swap_speed_multiplier
		end

		if custom_stat.fire_rate_multiplier then
			self._fire_rate_multiplier = self._fire_rate_multiplier * custom_stat.fire_rate_multiplier
		end

		if custom_stat.reload_speed_multiplier then
			self._reload_speed_multiplier = self._reload_speed_multiplier * custom_stat.reload_speed_multiplier
		end

		if custom_stat.exit_run_speed_multiplier then
			self._exit_run_speed_multiplier = self._exit_run_speed_multiplier * custom_stat.exit_run_speed_multiplier
		end

		if custom_stat.ammo_max_mul then
			self._ammo_max_mul = custom_stat.ammo_max_mul
		end

		if custom_stat.steelsight_enter_time_mul then
			self._steelsight_enter_time_mul = custom_stat.steelsight_enter_time_mul
		end

		if custom_stat.exit_run_time then
			self._exit_run_time = custom_stat.exit_run_time
		end
	end
end)

-- Helper functions for new index stats
function NewRaycastWeaponBase:swap_speed_stat()
	return self._swap_speed
end

function NewRaycastWeaponBase:exit_run_speed_stat()
	return self._exit_run_speed
end

-- Helper functions for new custom stats
function NewRaycastWeaponBase:exit_run_speed_multiplier()
	return self._exit_run_speed_multiplier
end

-- Helper functions for spread and kick tables
function NewRaycastWeaponBase:get_spread()
	return self._spread
end

function NewRaycastWeaponBase:get_kick()
	return self._kick
end

function NewRaycastWeaponBase:movement_penalty()
	if managers.player:has_category_upgrade("player", "no_movement_penalty") then
		return 1
	else
		return self._movement_penalty or 1
	end
end

function NewRaycastWeaponBase:update(unit, t, dt)
	local user_unit = self._setup and self._setup.user_unit

	if self._spread_bloom then
		self._spread_last_shot_t = math.max((self._spread_last_shot_t or 0) - dt, 0)

		local spread_bloom_recovery = self._spread_bloom.recovery * managers.player:upgrade_value("weapon", "faster_spread_bloom_recovery", 1)
		if self._spread_last_shot_t <= 0.0001 then
			self._spread_firing = math.max((self._spread_firing or 0) - dt * spread_bloom_recovery, 0)
		end
	end

	if self._kick_pattern_reset_t then
		if self._kick_pattern_reset_t > 0 then
			self._kick_pattern_reset_t = self._kick_pattern_reset_t - dt
		end

		if self._kick_pattern_reset_t <= 0 then
			self._kick_pattern_shots_fired = 0
			self._kick_pattern_index = 1
			self._use_persist_pattern = false
			--	Eclipse:log_chat("Reset kick pattern!")
		end
	end

	if self._is_incendiary_bstorm_active and self:bullet_class() == FlameBulletBase and not managers.player:has_active_temporary_property("bullet_storm") then
		self._is_incendiary_bstorm_active = false

		self:override_bullet_class(self._ammo_data.bullet_class or "InstantBulletBase")

		self:change_fire_effect()
		self:change_trail_effect()
	end
end

function NewRaycastWeaponBase:_get_spread(user_unit)
	local current_state = user_unit:movement()._current_state

	if not current_state then
		return 0, 0
	end

	local spread_values = self:get_spread()

	if not spread_values then
		return 0, 0
	end

	local current_spread_value = spread_values[current_state:get_movement_state()]
	current_spread_value = current_spread_value + (self._spread_firing or 0)

	local spread_x, spread_y
	if type(current_spread_value) == "number" then
		spread_x = self:_get_spread_from_number(user_unit, current_state, current_spread_value)
		spread_y = spread_x
	else
		spread_x, spread_y = self:_get_spread_from_table(user_unit, current_state, current_spread_value)
	end

	if current_state:full_steelsight() then
		local steelsight_tweak = spread_values.steelsight
		local multi_x, multi_y

		if type(steelsight_tweak) == "number" then
			multi_x = 1 + (1 - steelsight_tweak)
			multi_y = multi_x
		else
			multi_x = 1 + (1 - steelsight_tweak[1])
			multi_y = 1 + (1 - steelsight_tweak[2])
		end

		spread_x = spread_x * multi_x
		spread_y = spread_y * multi_y
	end

	if self._spread_multiplier then
		spread_x = spread_x * self._spread_multiplier[1]
		spread_y = spread_y * self._spread_multiplier[2]
	end

	return spread_x, spread_y
end

function NewRaycastWeaponBase:fire(...)
	local ray_res = NewRaycastWeaponBase.super.fire(self, ...)

	if self._fire_mode == ids_burst and self._bullets_fired > 1 and not self:weapon_tweak_data().sounds.fire_single then
		self:_fire_sound()
	end

	local is_player = self._setup.user_unit == managers.player:player_unit()
	if is_player then
		self._shots_fired_consecutively = self._shots_fired_consecutively + 1
		self._kick_pattern_shots_fired = self._kick_pattern_shots_fired + 1
	end

	local in_steelsight = user_unit and alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state:full_steelsight()

	if self._spread_bloom then
		local spread_bloom_data = self._spread_bloom[self._fire_mode:key()] or self._spread_bloom
		local spread_bloom_add = spread_bloom_data and (in_steelsight and spread_bloom_data.add_steelsight or spread_bloom_data.add)

		self._spread_firing = math.min((self._spread_firing or 0) + spread_bloom_add, self._spread_bloom.max)
		self._spread_last_shot_t = (self:weapon_tweak_data().fire_mode_data and self:weapon_tweak_data().fire_mode_data.fire_rate or 0)
			/ self:fire_rate_multiplier()
			* self._spread_bloom.recovery_wait_multiplier
	end

	local user_unit = self._setup and self._setup.user_unit
	local kick_pattern = self._kick_pattern and self._kick_pattern[self:fire_mode()] and self._kick_pattern[self:fire_mode()][in_steelsight and "steelsight" or "standing"]

	--		Eclipse:log_chat("Shots Fired: " .. tostring(self._kick_pattern_shots_fired))
	--		Eclipse:log_chat("Pattern Index: " .. tostring(self._kick_pattern_index))

	if kick_pattern and kick_pattern[self._kick_pattern_index] then
		if kick_pattern[self._kick_pattern_index][2] and kick_pattern[self._kick_pattern_index][2] <= self._kick_pattern_shots_fired then
			self._kick_pattern_index = math.min(self._kick_pattern_index + 1, #kick_pattern)
		elseif kick_pattern[self._kick_pattern_index].persist and not self._use_persist_pattern then
			self._use_persist_pattern = true

			if self._use_persist_pattern then
				--				Eclipse:log_chat("Using persist pattern!")
			end
		end
	end

	if self:weapon_tweak_data().kick_pattern_reset_t then
		self._kick_pattern_reset_t = self:weapon_tweak_data().kick_pattern_reset_t

		if self._kick_pattern_reset_t == self:weapon_tweak_data().kick_pattern_reset_t then
			--	Eclipse:log_chat("Kick pattern reset time: " .. tostring(self._kick_pattern_reset_t))
		end
	end

	return ray_res
end

function NewRaycastWeaponBase:stop_shooting()
	NewRaycastWeaponBase.super.stop_shooting(self)

	if self._fire_mode == ids_burst then
		local weapon_tweak_data = self:weapon_tweak_data()
		local fire_mode_data = weapon_tweak_data.fire_mode_data or {}
		local next_fire = (fire_mode_data.burst_cooldown or self:weapon_fire_rate()) / self:fire_rate_multiplier()
		self._next_fire_allowed = math.max(self._next_fire_allowed, self._unit:timer():time() + next_fire)
		self._shooting_count = 0
	elseif self._fire_mode == ids_volley then
		self:stop_volley_charge()
	end

	self._shots_fired_consecutively = 0 -- reset the shots counter when you stop spraying
end

function NewRaycastWeaponBase:recoil_multiplier()
	local is_moving = false
	local is_crouching = false
	local in_steelsight = false
	local multiplier = managers.blackmarket:recoil_multiplier(self._name_id, self:categories(), self._silencer, self._blueprint, is_moving)
	local user_unit = self._setup and self._setup.user_unit

	if user_unit then
		is_moving = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state._moving
		is_crouching = alive(user_unit) and user_unit:movement() and user_unit:movement():crouching()
		in_steelsight = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state:full_steelsight()
	end

	local categories = self:categories()
	if not in_steelsight then
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "hipfire_recoil_multiplier", 1)
		end
	else
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "steelsight_recoil_multiplier", 1)
		end

		multiplier = multiplier * managers.player:upgrade_value("weapon", "steelsight_recoil_multiplier", 1)
	end

	if is_moving then
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "moving_recoil_multiplier", 1)
		end

		multiplier = multiplier * managers.player:upgrade_value("weapon", "moving_recoil_penalty_reduction", 1)
	else
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "standing_recoil_multiplier", 1)
		end
	end

	if is_crouching then
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "crouching_recoil_multiplier", 1)
		end
	end

	if self._silencer then
		multiplier = multiplier * managers.player:upgrade_value("weapon", "silencer_recoil_multiplier", 1)
	end

	-- upgrade that reduces recoil as you fire
	for _, category in ipairs(categories) do
		multiplier = multiplier
			* math.max(tweak_data.upgrades.max_spray_recoil_reduction, (1 - (managers.player:upgrade_value(category, "spray_recoil_multiplier", 0) * self._shots_fired_consecutively)))
	end

	local fire_mode_data = self:weapon_tweak_data().fire_mode_data
	if fire_mode_data and fire_mode_data[self:fire_mode()] and fire_mode_data[self:fire_mode()].recoil_mul then
		multiplier = multiplier * fire_mode_data[self:fire_mode()].recoil_mul
	end

	if self._alt_fire_active and self._alt_fire_data then
		multiplier = multiplier * (self._alt_fire_data.recoil_mul or 1)
	end

	-- Burst fire
	if self._shooting_count and self._shooting_count >= 1 then
		multiplier = multiplier * 1 / (self._shooting_count + 1)
	end

	if self._shooting_count and self._shooting_count <= 0 and fire_mode_data.burst_recoil_final_mul then
		multiplier = multiplier * fire_mode_data.burst_recoil_final_mul
	end

	return multiplier
end

function NewRaycastWeaponBase:spread_multiplier()
	local is_moving = false
	local is_crouching = false
	local in_steelsight = false
	local multiplier =
		managers.blackmarket:accuracy_multiplier(self._name_id, self:categories(), self._silencer, current_state, self._spread_moving, self:fire_mode(), self._blueprint, self:is_single_shot())
	local user_unit = self._setup and self._setup.user_unit

	if user_unit then
		is_moving = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state._moving
		is_crouching = alive(user_unit) and user_unit:movement() and user_unit:movement():crouching()
		in_steelsight = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state:full_steelsight()
	end

	local categories = self:categories()
	if not in_steelsight then
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "hipfire_spread_multiplier", 1)
		end

		multiplier = multiplier * managers.player:upgrade_value("weapon", "hipfire_spread_penalty_reduction", 1)
	else
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "steelsight_spread_multiplier", 1)
		end
	end

	if is_moving then
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "moving_spread_multiplier", 1)
		end
	else
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "standing_spread_multiplier", 1)
		end

		multiplier = multiplier * managers.player:upgrade_value("weapon", "standing_spread_multiplier", 1)
	end

	if is_crouching then
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "crouching_spread_multiplier", 1)
		end
	end

	if self._silencer then
		multiplier = multiplier * managers.player:upgrade_value("weapon", "silencer_spread_multiplier", 1)
	end

	local fire_mode_data = self:weapon_tweak_data().fire_mode_data
	if fire_mode_data and fire_mode_data[self:fire_mode()] and fire_mode_data[self:fire_mode()].spread_mul then
		multiplier = multiplier * fire_mode_data[self:fire_mode()].spread_mul
	end

	if self._alt_fire_active and self._alt_fire_data then
		multiplier = multiplier * (self._alt_fire_data.spread_mul or 1)
	end

	return multiplier
end

function NewRaycastWeaponBase:enter_steelsight_speed_multiplier()
	local multiplier = 1
	local categories = self:categories()

	local steelsight_enter_time = tweak_data.player.TRANSITION_DURATION / self._steelsight_enter_time -- It just works. Okay?

	if self._steelsight_enter_time_mul then
		multiplier = multiplier * self._steelsight_enter_time_mul
	end

	for _, category in ipairs(categories) do
		multiplier = multiplier + (1 - managers.player:upgrade_value(category, "enter_steelsight_speed_multiplier", 1))
	end

	multiplier = multiplier + (1 - managers.player:temporary_upgrade_value("temporary", "combat_medic_enter_steelsight_speed_multiplier", 1))
	multiplier = multiplier + (1 - managers.player:upgrade_value(self._name_id, "enter_steelsight_speed_multiplier", 1))
	multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "enter_steelsight_speed_multiplier", 1))

	if self._silencer then
		multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "silencer_enter_steelsight_speed_multiplier", 1))

		for _, category in ipairs(categories) do
			multiplier = multiplier + (1 - managers.player:upgrade_value(category, "silencer_enter_steelsight_speed_multiplier", 1))
		end
	end

	multiplier = self:_convert_add_to_mul(multiplier)

	multiplier = multiplier * steelsight_enter_time

	return multiplier
end

function NewRaycastWeaponBase:reload_speed_multiplier()
	if self._current_reload_speed_multiplier then
		return self._current_reload_speed_multiplier
	end

	local multiplier = 1
	local pm = managers.player

	multiplier = multiplier + 1 - self._reload_speed_multiplier

	if self:clip_not_empty() then
		multiplier = multiplier + 1 - (self:weapon_tweak_data().reload_not_empty_speed_multiplier or 1)
	elseif self:clip_empty() then
		multiplier = multiplier + 1 - (self:weapon_tweak_data().reload_empty_speed_multiplier or 1)
	end

	for _, category in ipairs(self:categories()) do
		multiplier = multiplier + 1 - pm:upgrade_value(category, "reload_speed_multiplier", 1)

		if category == "shotgun" then -- shotgun reload speed stuff
			if self._use_shotgun_reload or self:weapon_tweak_data().double_barrel then
				multiplier = multiplier + 1 - pm:upgrade_value("shotgun", "pump_reload_speed_mul", 1)
			else
				multiplier = multiplier + 1 - pm:upgrade_value("shotgun", "mag_reload_speed_mul", 1)
			end
		end
	end

	multiplier = multiplier + 1 - pm:upgrade_value("weapon", "passive_reload_speed_multiplier", 1)
	multiplier = multiplier + 1 - pm:upgrade_value(self._name_id, "reload_speed_multiplier", 1)

	if self._setup and alive(self._setup.user_unit) and self._setup.user_unit:movement() then
		if self._setup.user_unit:movement():next_reload_speed_multiplier() then
			multiplier = multiplier + 1 - self._setup.user_unit:movement():next_reload_speed_multiplier()
		end
	end

	if pm:has_activate_temporary_upgrade("temporary", "reload_weapon_faster") then
		multiplier = multiplier + 1 - pm:temporary_upgrade_value("temporary", "reload_weapon_faster", 1)
	end

	if pm:has_activate_temporary_upgrade("temporary", "single_shot_fast_reload") then
		multiplier = multiplier + 1 - pm:temporary_upgrade_value("temporary", "single_shot_fast_reload", 1)
	end

	multiplier = multiplier + 1 - pm:get_property("shock_and_awe_reload_multiplier", 1)
	multiplier = multiplier + 1 - pm:get_temporary_property("bloodthirst_reload_speed", 1)
	multiplier = multiplier + 1 - pm:upgrade_value("team", "crew_faster_reload", 1)

	multiplier = self:_convert_add_to_mul(multiplier)
	multiplier = multiplier * self:reload_speed_stat()

	multiplier = multiplier + pm:get_property("desperado_reload", 0)

	multiplier = managers.modifiers:modify_value("WeaponBase:GetReloadSpeedMultiplier", multiplier)

	return multiplier
end

function NewRaycastWeaponBase:fire_rate_multiplier()
	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state
	local multiplier = managers.blackmarket:fire_rate_multiplier(self._name_id, self:categories(), self._silencer, nil, current_state, self._blueprint)

	multiplier = multiplier * self._fire_rate_multiplier

	if self._alt_fire_active and self._alt_fire_data then
		multiplier = multiplier * (self._alt_fire_data.fire_rate_mul or 1)
	end

	return multiplier
end

function NewRaycastWeaponBase:conditional_accuracy_multiplier(current_state)
	local mul = 1

	if not current_state then
		return mul
	end

	local pm = managers.player

	if current_state:full_steelsight() and self:is_single_shot() then
		mul = mul + 1 - pm:upgrade_value("player", "single_shot_accuracy_inc", 1)
	end

	if current_state:full_steelsight() then
		for _, category in ipairs(self:categories()) do
			mul = mul + 1 - managers.player:upgrade_value(category, "steelsight_accuracy_inc", 1)
		end
	end

	mul = mul + pm:get_property("desperado", 0)

	return self:_convert_add_to_mul(mul)
end

function NewRaycastWeaponBase:steelsight_move_speed_multiplier()
	if managers.player:has_category_upgrade("weapon", "steelsight_move_speed_penalty_multiplier") then
		local speed_penalty = 1 - self._steelsight_move_speed_mul
		return (1 - speed_penalty * managers.player:upgrade_value("weapon", "steelsight_move_speed_penalty_multiplier", 1))
	end

	return self._steelsight_move_speed_mul
end

-- (Re-)add damage penalties when shooting through multiple enemies/walls/shields
Hooks:PreHook(NewRaycastWeaponBase, "_fire_raycast", "eclipse_fire_raycast", function(self)
	self._enemy_penetrations = nil
	self._wall_penetrations = nil
	self._shield_penetrations = nil

	self._hit_through_enemy = nil
	self._hit_through_wall = nil
	self._hit_through_shield = nil
end)

Hooks:PostHook(NewRaycastWeaponBase, "get_damage_falloff", "eclipse_get_damage_falloff", function(self, _, hit)
	local multiplier = 1

	local weapon_tweak = self:weapon_tweak_data()

	self._hit_through_enemy = self._hit_through_enemy or hit.unit:in_slot(self.enemy_mask)
	self._hit_through_wall = self._hit_through_wall or hit.unit:in_slot(self.wall_mask)
	self._hit_through_shield = self._hit_through_shield or hit.unit:in_slot(self.shield_mask)

	if self._hit_through_enemy then
		self._enemy_penetrations = (self._enemy_penetrations or 0) + 1

		local max_nr_enemy_penetrations = self._max_nr_enemy_penetrations
		if max_nr_enemy_penetrations then
			for _, category in ipairs(self:categories()) do
				max_nr_enemy_penetrations = max_nr_enemy_penetrations + managers.player:upgrade_value(category, "max_enemy_penetrations_addend", 1)
			end
		end

		if self._penetration_data.enemy then
			if max_nr_enemy_penetrations and math.max(0, self._enemy_penetrations - 1) > max_nr_enemy_penetrations then
				return 0
			end

			multiplier = multiplier * (self._penetration_data.enemy.damage_mul or 1) ^ math.max(0, self._enemy_penetrations - 1)
		end
	end

	if self._hit_through_wall then
		self._wall_penetrations = (self._wall_penetrations or 0) + 1

		if self._penetration_data.wall then
			multiplier = multiplier * (self._penetration_data.wall.damage_mul or 1) ^ math.max(0, self._wall_penetrations - 1)
		end
	end

	if self._hit_through_shield then
		self._shield_penetrations = (self._shield_penetrations or 0) + 1

		if self._penetration_data.shield then
			multiplier = multiplier * (self._penetration_data.shield.damage_mul or 1) ^ math.max(0, self._shield_penetrations - 1)
		end
	end

	return Hooks:GetReturn() * multiplier
end)

-- Body Expertise only works on LMGs and Miniguns
function NewRaycastWeaponBase:get_add_head_shot_mul()
	if self:is_category("lmg", "minigun") then
		return managers.player:upgrade_value("weapon", "automatic_head_shot_add", nil)
	end

	return nil
end

-- Percentage clip ammo increase upgrade
function NewRaycastWeaponBase:calculate_ammo_max_per_clip()
	local added = 0

	if self:is_category("shotgun") and tweak_data.weapon[self._name_id].has_magazine then
		added = managers.player:upgrade_value("shotgun", "magazine_capacity_inc", 0)

		if self:is_category("akimbo") then
			added = added * 2
		end
	elseif self:is_category("pistol") and not self:is_category("revolver") and managers.player:has_category_upgrade("pistol", "magazine_capacity_inc") then
		added = managers.player:upgrade_value("pistol", "magazine_capacity_inc", 0)

		if self:is_category("akimbo") then
			added = added * 2
		end
	elseif self:is_category("smg", "assault_rifle", "lmg") then
		added = managers.player:upgrade_value("player", "automatic_mag_increase", 0)

		if self:is_category("akimbo") then
			added = added * 2
		end
	end

	local ammo = tweak_data.weapon[self._name_id].CLIP_AMMO_MAX

	if not self:upgrade_blocked("weapon", "clip_ammo_increase") then
		ammo = math.ceil(ammo * managers.player:upgrade_value("weapon", "clip_ammo_increase", 1))
	end

	ammo = ammo + managers.player:upgrade_value(self._name_id, "clip_ammo_increase")

	for _, category in ipairs(tweak_data.weapon[self._name_id].categories) do
		if not self:upgrade_blocked(category, "clip_ammo_increase") then
			ammo = ammo + managers.player:upgrade_value(category, "clip_ammo_increase", 0)
		end
	end

	ammo = ammo + added
	ammo = ammo + (self._extra_ammo or 0)

	return ammo
end

-- Sidearm reload extra damage and ricochet
function NewRaycastWeaponBase:on_reload(...)
	NewRaycastWeaponBase.super.on_reload(self, ...)

	local user_unit = managers.player:player_unit()
	local has_sidearm_reload_dmg_mul = managers.player:has_enabled_cooldown_upgrade("cooldown", "sidearm_reload_damage_multiplier")

	if has_sidearm_reload_dmg_mul and managers.player:has_category_upgrade("temporary", "sidearm_reload_damage_multiplier") and self:is_category("revolver", "pistol") then
		managers.player:activate_temporary_upgrade("temporary", "sidearm_reload_damage_multiplier")
		managers.player:disable_cooldown_upgrade("cooldown", "sidearm_reload_damage_multiplier")
	end

	if user_unit then
		user_unit:movement():current_state():send_reload_interupt()
	end

	self:set_reload_objects_visible(false)

	self._reload_objects = {}
end

-- Extra startout ammo upgrade
function NewRaycastWeaponBase:replenish(is_starting_out_with_extra_ammo)
	local ammo_max_multiplier = managers.player:upgrade_value("player", "extra_ammo_multiplier", 1)
	local extra_start_ammo_multiplier = is_starting_out_with_extra_ammo and managers.player:upgrade_value("player", "start_out_ammo_multiplier", 1) or 1

	for _, category in ipairs(self:categories()) do
		ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value(category, "extra_ammo_multiplier", 1)
	end

	ammo_max_multiplier = ammo_max_multiplier + ammo_max_multiplier * (self._total_ammo_mod or 0)

	if managers.player:has_category_upgrade("player", "add_armor_stat_skill_ammo_mul") then
		ammo_max_multiplier = ammo_max_multiplier * managers.player:body_armor_value("skill_ammo_mul", nil, 1)
	end

	ammo_max_multiplier = managers.modifiers:modify_value("WeaponBase:GetMaxAmmoMultiplier", ammo_max_multiplier)
	local ammo_max_per_clip = self:calculate_ammo_max_per_clip()
	local ammo_max = math.round(
		(tweak_data.weapon[self._name_id].AMMO_MAX + managers.player:upgrade_value(self._name_id, "clip_amount_increase") * ammo_max_per_clip) * ammo_max_multiplier * (self._ammo_max_mul or 1)
	)
	ammo_max_per_clip = math.min(ammo_max_per_clip, ammo_max)

	self:set_ammo_max_per_clip(ammo_max_per_clip)
	self:set_ammo_max(ammo_max)
	self:set_ammo_total(math.round(ammo_max * extra_start_ammo_multiplier))
	self:set_ammo_remaining_in_clip(ammo_max_per_clip)

	self._ammo_pickup = tweak_data.weapon[self._name_id].AMMO_PICKUP

	if self._assembly_complete then
		for _, gadget in ipairs(self:get_all_override_weapon_gadgets()) do
			if gadget and gadget.replenish then
				gadget:replenish()
			end
		end
	end

	self:update_damage()
end

-- Firestorm Incendiary Ammo activation
function NewRaycastWeaponBase:activate_firestorm_incendiary_ammo()
	if
		self:is_category("saw", "grenade_launcher", "flamethrower", "bow", "crossbow", "minigun")
		or (self:is_category("shotgun") and self:bullet_class() == InstantExplosiveBulletBase or self:bullet_class() == FlameBulletBase)
	then
		return
	end

	self._is_incendiary_bstorm_active = true
	self:override_bullet_class("FlameBulletBase")

	if not self._silencer then
		self:change_fire_effect(self:weapon_tweak_data().muzzleflash_incendiary)
		self:change_trail_effect(self:weapon_tweak_data().trail_effect_incendiary)
	end
end

function NewRaycastWeaponBase:_check_use_persist_pattern()
	return self._use_persist_pattern
end

function NewRaycastWeaponBase:_get_kick_pattern_index()
	return self._kick_pattern_index
end
