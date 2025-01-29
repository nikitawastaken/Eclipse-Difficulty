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
	self._shots_fired_consecutively = 0
end)

Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", "eclipse_update_stats_values", function(self)
	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
	local weapon_tweak = self:weapon_tweak_data()

	local fire_mode_data = self:weapon_tweak_data().fire_mode_data or {}
	local toggable_fire_modes = custom_stats and custom_stats.fire_modes or fire_mode_data and fire_mode_data.toggable

	if toggable_fire_modes then
		self._toggable_fire_modes = {}

		for _, fire_mode in ipairs(toggable_fire_modes) do
			if FIRE_MODE_IDS[fire_mode] then
				table.insert(self._toggable_fire_modes, FIRE_MODE_IDS[fire_mode])
			end
		end
	end

	self._steelsight_time = weapon_tweak.steelsight_time or 0.3

	self._sprint_exit_time = weapon_tweak.sprint_exit_time or 0.4

	self._total_ammo_multiplier = weapon_tweak.total_ammo_multiplier or 1

	self._swap_speed_multiplier = weapon_tweak.swap_speed_multiplier or 1

	self._fire_rate_multiplier = weapon_tweak.fire_rate_multiplier or 1

	self._reload_speed_multiplier = weapon_tweak.reload_speed_multiplier or 1

	self._exit_run_speed_multiplier = weapon_tweak.exit_run_speed_multiplier or 1

	self._falloff_range_multiplier = weapon_tweak.falloff_range_multiplier or 1

	self._penetration_dmg_mul = weapon_tweak.penetration_damage_mul or {}

	self._standing_hipfire_recoil_mul = (weapon_tweak.recoil_multiplier and weapon_tweak.recoil_multiplier.standing and weapon_tweak.recoil_multiplier.standing.hipfire) or 1
	self._standing_crouching_recoil_mul = (weapon_tweak.recoil_multiplier and weapon_tweak.recoil_multiplier.standing and weapon_tweak.recoil_multiplier.standing.crouching) or 1
	self._standing_steelsight_recoil_mul = (weapon_tweak.recoil_multiplier and weapon_tweak.recoil_multiplier.standing and weapon_tweak.recoil_multiplier.standing.steelsight) or 1

	self._moving_hipfire_recoil_mul = (weapon_tweak.recoil_multiplier and weapon_tweak.recoil_multiplier.moving and weapon_tweak.recoil_multiplier.moving.hipfire) or 1
	self._moving_crouching_recoil_mul = (weapon_tweak.recoil_multiplier and weapon_tweak.recoil_multiplier.moving and weapon_tweak.recoil_multiplier.moving.crouching) or 1
	self._moving_steelsight_recoil_mul = (weapon_tweak.recoil_multiplier and weapon_tweak.recoil_multiplier.moving and weapon_tweak.recoil_multiplier.moving.steelsight) or 1

	self._standing_hipfire_spread_mul = (weapon_tweak.spread_multiplier and weapon_tweak.spread_multiplier.standing and weapon_tweak.spread_multiplier.standing.hipfire) or 1
	self._standing_crouching_spread_mul = (weapon_tweak.spread_multiplier and weapon_tweak.spread_multiplier.standing and weapon_tweak.spread_multiplier.standing.crouching) or 1
	self._standing_steelsight_spread_mul = (weapon_tweak.spread_multiplier and weapon_tweak.spread_multiplier.standing and weapon_tweak.spread_multiplier.standing.steelsight) or 1

	self._moving_hipfire_spread_mul = (weapon_tweak.spread_multiplier and weapon_tweak.spread_multiplier.moving and weapon_tweak.spread_multiplier.moving.hipfire) or 1
	self._moving_crouching_spread_mul = (weapon_tweak.spread_multiplier and weapon_tweak.spread_multiplier.moving and weapon_tweak.spread_multiplier.moving.crouching) or 1
	self._moving_steelsight_spread_mul = (weapon_tweak.spread_multiplier and weapon_tweak.spread_multiplier.moving and weapon_tweak.spread_multiplier.moving.steelsight) or 1

	self._in_air_spread_mul = weapon_tweak.in_air_spread_multiplier or 1

	for part_id, stats in pairs(custom_stats) do
		if stats.swap_speed_multiplier then
			self._swap_speed_multiplier = self._swap_speed_multiplier * stats.swap_speed_multiplier
		end

		if stats.fire_rate_multiplier then
			self._fire_rate_multiplier = self._fire_rate_multiplier * stats.fire_rate_multiplier
		end

		if stats.reload_speed_multiplier then
			self._reload_speed_multiplier = self._reload_speed_multiplier * stats.reload_speed_multiplier
		end

		if stats.exit_run_speed_multiplier then
			self._exit_run_speed_multiplier = self._exit_run_speed_multiplier * stats.exit_run_speed_multiplier
		end

		if stats.falloff_range_multiplier then
			self._falloff_range_multiplier = self._falloff_range_multiplier * stats.falloff_range_multiplier
		end

		if stats.total_ammo_multiplier then
			self._total_ammo_multiplier = self._total_ammo_multiplier * stats.total_ammo_multiplier
		end
	end
end)

function NewRaycastWeaponBase:movement_penalty()
	if managers.player:has_category_upgrade("player", "no_movement_penalty") then
		return 1
	else
		return self._movement_penalty or 1
	end
end

-- remove ARs from BE
function NewRaycastWeaponBase:get_add_head_shot_mul()
	if self:is_category("smg", "lmg", "minigun") and self._fire_mode == ids_auto or self:is_category("bow", "saw") then
		return managers.player:upgrade_value("weapon", "automatic_head_shot_add", nil)
	end

	return nil
end

function NewRaycastWeaponBase:reload_speed_multiplier()
	if self._current_reload_speed_multiplier then
		return self._current_reload_speed_multiplier
	end

	local multiplier = 1

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		multiplier = multiplier + 1 - managers.player:upgrade_value(category, "reload_speed_multiplier", 1)

		if category == "shotgun" then -- shotgun reload speed stuff
			if self._use_shotgun_reload then
				multiplier = multiplier + 1 - managers.player:upgrade_value("shotgun", "pump_reload_speed", 1)
			else
				multiplier = multiplier + 1 - managers.player:upgrade_value("shotgun", "mag_reload_speed", 1)
			end
		end
	end

	multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "passive_reload_speed_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value(self._name_id, "reload_speed_multiplier", 1)

	if self._setup and alive(self._setup.user_unit) and self._setup.user_unit:movement() then
		local morale_boost_bonus = self._setup.user_unit:movement():morale_boost()

		if morale_boost_bonus then
			multiplier = multiplier + 1 - morale_boost_bonus.reload_speed_bonus
		end

		if self._setup.user_unit:movement():next_reload_speed_multiplier() then
			multiplier = multiplier + 1 - self._setup.user_unit:movement():next_reload_speed_multiplier()
		end
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "reload_weapon_faster") then
		multiplier = multiplier + 1 - managers.player:temporary_upgrade_value("temporary", "reload_weapon_faster", 1)
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "single_shot_fast_reload") then
		multiplier = multiplier + 1 - managers.player:temporary_upgrade_value("temporary", "single_shot_fast_reload", 1)
	end

	multiplier = multiplier + 1 - managers.player:get_property("shock_and_awe_reload_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:get_temporary_property("bloodthirst_reload_speed", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value("team", "crew_faster_reload", 1)
	multiplier = self:_convert_add_to_mul(multiplier)
	multiplier = multiplier * self:reload_speed_stat()
	multiplier = managers.modifiers:modify_value("WeaponBase:GetReloadSpeedMultiplier", multiplier)

	return multiplier
end

function NewRaycastWeaponBase:fire(...)
	local ray_res = NewRaycastWeaponBase.super.fire(self, ...)

	if self._fire_mode == ids_burst and self._bullets_fired > 1 and not self:weapon_tweak_data().sounds.fire_single then
		self:_fire_sound()
	end

	local is_player = self._setup.user_unit == managers.player:player_unit()
	if is_player then
		self._shots_fired_consecutively = self._shots_fired_consecutively + 1
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
	local multiplier = managers.blackmarket:recoil_multiplier(self._name_id, self:weapon_tweak_data().categories, self._silencer, self._blueprint, is_moving)
	local user_unit = self._setup and self._setup.user_unit

	if user_unit then
		is_moving = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state._moving
		is_crouching = alive(user_unit) and user_unit:movement() and user_unit:movement():crouching()
		in_steelsight = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state:in_steelsight()
	end

	local weapon_tweak = self:weapon_tweak_data()

	local fire_modes = weapon_tweak.fire_mode_data and weapon_tweak.fire_mode_data.toggable

	if fire_modes then
		for _, fire_mode in ipairs(fire_modes) do
			if self:fire_mode() == fire_mode then
				multiplier = multiplier * (weapon_tweak.fire_mode_mul and weapon_tweak.fire_mode_mul[fire_mode].recoil or 1)
			end
		end
	end

	if not is_moving then
		if not in_steelsight then
			multiplier = multiplier * self._standing_hipfire_recoil_mul
		else
			multiplier = multiplier * self._standing_steelsight_recoil_mul
		end

		if is_crouching then
			multiplier = multiplier * self._standing_crouching_recoil_mul
		end
	else
		if not in_steelsight then
			multiplier = multiplier * self._moving_hipfire_recoil_mul
		else
			multiplier = multiplier * self._moving_steelsight_recoil_mul
		end

		if is_crouching then
			multiplier = multiplier * self._moving_crouching_recoil_mul
		end
	end

	local categories = weapon_tweak.categories

	if not in_steelsight then
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "hipfire_recoil_multiplier", 1)
		end

		for _, category in ipairs(categories) do
			multiplier = multiplier
				* math.max(tweak_data.upgrades.max_spray_recoil_reduction, (1 - (managers.player:upgrade_value(category, "spray_recoil_multiplier", 0) * self._shots_fired_consecutively)))
		end
	else
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "steelsight_recoil_multiplier", 1)

			multiplier = multiplier * managers.player:upgrade_value("weapon", "steelsight_recoil_multiplier", 1)
		end
	end

	if is_moving then
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "moving_recoil_multiplier", 1)
		end
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

	if self._alt_fire_active and self._alt_fire_data then
		multiplier = multiplier * (self._alt_fire_data.recoil_mul or 1)
	end

	return multiplier
end

function NewRaycastWeaponBase:spread_multiplier()
	local is_moving = false
	local is_crouching = false
	local in_steelsight = false
	local multiplier = managers.blackmarket:accuracy_multiplier(
		self._name_id,
		self:weapon_tweak_data().categories,
		self._silencer,
		current_state,
		self._spread_moving,
		self:fire_mode(),
		self._blueprint,
		self:is_single_shot()
	)
	local user_unit = self._setup and self._setup.user_unit

	if user_unit then
		is_moving = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state._moving
		is_crouching = alive(user_unit) and user_unit:movement() and user_unit:movement():crouching()
		in_steelsight = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state:in_steelsight()
		in_air = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state:in_air()
	end

	local weapon_tweak = self:weapon_tweak_data()

	local fire_modes = weapon_tweak.fire_mode_data and weapon_tweak.fire_mode_data.toggable

	if fire_modes then
		for _, fire_mode in ipairs(fire_modes) do
			if self:fire_mode() == fire_mode then
				multiplier = multiplier * (weapon_tweak.fire_mode_mul and weapon_tweak.fire_mode_mul[fire_mode].spread or 1)
			end
		end
	end

	if not is_moving then
		if not in_steelsight then
			multiplier = multiplier * self._standing_hipfire_spread_mul
		else
			multiplier = multiplier * self._standing_steelsight_spread_mul
		end
	else
		if not in_steelsight then
			multiplier = multiplier * self._moving_hipfire_spread_mul
		else
			multiplier = multiplier * self._moving_steelsight_spread_mul
		end

		if is_crouching then
			multiplier = multiplier * self._moving_crouching_spread_mul
		end
	end

	local categories = self:weapon_tweak_data().categories

	if not in_steelsight then
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "hipfire_spread_multiplier", 1)

			multiplier = multiplier * managers.player:upgrade_value("weapon", "hipfire_spread_penalty_reduction", 1)
		end
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
	end

	if is_crouching then
		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "crouching_spread_multiplier", 1)
		end
	end

	if self._silencer then
		multiplier = multiplier * managers.player:upgrade_value("weapon", "silencer_spread_multiplier", 1)
	end

	if self._alt_fire_active and self._alt_fire_data then
		multiplier = multiplier * (self._alt_fire_data.spread_mul or 1)
	end

	return multiplier
end

function NewRaycastWeaponBase:fire_rate_multiplier()
	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state
	local multiplier = managers.blackmarket:fire_rate_multiplier(self._name_id, self:weapon_tweak_data().categories, self._silencer, nil, current_state, self._blueprint)

	multiplier = multiplier * self._fire_rate_multiplier

	local weapon_tweak = self:weapon_tweak_data()

	local fire_modes = weapon_tweak.fire_mode_data and weapon_tweak.fire_mode_data.toggable

	if fire_modes then
		for _, fire_mode in ipairs(fire_modes) do
			if self:fire_mode() == fire_mode then
				multiplier = multiplier * (weapon_tweak.fire_mode_mul and weapon_tweak.fire_mode_mul[fire_mode].fire_rate or 1)
			end
		end
	end

	if self._alt_fire_active and self._alt_fire_data then
		multiplier = multiplier * (self._alt_fire_data.fire_rate_mul or 1)
	end

	return multiplier
end

function NewRaycastWeaponBase:falloff_range_multiplier()
	local primary_category = self:weapon_tweak_data().categories and self:weapon_tweak_data().categories[1]
	local current_state = user_unit and user_unit:movement() and user_unit:movement()._current_state
	local multiplier = 1

	multiplier = multiplier * self._falloff_range_multiplier

	local weapon_tweak = self:weapon_tweak_data()

	local fire_modes = weapon_tweak.fire_mode_data and weapon_tweak.fire_mode_data.toggable

	if fire_modes then
		for _, fire_mode in ipairs(fire_modes) do
			if self:fire_mode() == fire_mode then
				multiplier = multiplier * (weapon_tweak.fire_mode_mul and weapon_tweak.fire_mode_mul[fire_mode].falloff_range or 1)
			end
		end
	end

	if self._alt_fire_active and self._alt_fire_data then
		multiplier = multiplier * (self._alt_fire_data.falloff_range_mul or 1)
	end

	if managers.player:current_state() and managers.player:current_state() == "bipod" then
		multiplier = multiplier * managers.player:upgrade_value(primary_category, "bipod_range_mul", 1)

		multiplier = multiplier * (weapon_tweak.stance_range_mul and weapon_tweak.stance_range_mul.bipod or 1)
	elseif current_state and current_state:in_steelsight() then
		multiplier = multiplier * (weapon_tweak.stance_range_mul and weapon_tweak.stance_range_mul.steelsight or 1)
	end

	if current_state and current_state:in_steelsight() then
		multiplier = multiplier * managers.player:upgrade_value(primary_category, "steelsight_range_mul", 1)
	end

	return multiplier
end

function NewRaycastWeaponBase:conditional_accuracy_multiplier(current_state)
	local mul = 1

	if not current_state then
		return mul
	end

	local pm = managers.player

	if current_state:in_steelsight() and self:is_single_shot() then
		mul = mul + 1 - pm:upgrade_value("player", "single_shot_accuracy_inc", 1)
	end

	if current_state:in_steelsight() then
		for _, category in ipairs(self:categories()) do
			mul = mul + 1 - managers.player:upgrade_value(category, "steelsight_accuracy_inc", 1)
		end
	end

	mul = mul + 1 - pm:get_property("desperado", 1)

	return self:_convert_add_to_mul(mul)
end

function NewRaycastWeaponBase:enter_steelsight_speed_multiplier()
	local weapon_tweak = self:weapon_tweak_data()
	local categories = weapon_tweak.categories

	local multiplier = (tweak_data.player.TRANSITION_DURATION or 0.23) / self._steelsight_time

	for _, category in ipairs(categories) do
		multiplier = multiplier * managers.player:upgrade_value(category, "enter_steelsight_speed_multiplier", 1)
	end

	multiplier = multiplier * managers.player:temporary_upgrade_value("temporary", "combat_medic_enter_steelsight_speed_multiplier", 1)
	multiplier = multiplier * managers.player:upgrade_value("weapon", "enter_steelsight_speed_multiplier", 1)

	if self._silencer then
		multiplier = multiplier * managers.player:upgrade_value("weapon", "silencer_enter_steelsight_speed_multiplier", 1)

		for _, category in ipairs(categories) do
			multiplier = multiplier * managers.player:upgrade_value(category, "silencer_enter_steelsight_speed_multiplier", 1)
		end
	end

	return multiplier
end

Hooks:PreHook(NewRaycastWeaponBase, "_fire_raycast", "eclipse_fire_raycast", function(self)
	self._hit_through_enemy = nil
end)

function NewRaycastWeaponBase:get_damage_falloff(damage, col_ray, user_unit)
	local damage_mul = 1

	local weapon_tweak = self:weapon_tweak_data()

	if col_ray.unit and col_ray.unit:in_slot(self.shield_mask) then
		damage_mul = damage_mul * (self._penetration_dmg_mul and self._penetration_dmg_mul.shield or 1)
	elseif col_ray.unit and col_ray.unit:in_slot(self.wall_mask) then
		damage_mul = damage_mul * (self._penetration_dmg_mul and self._penetration_dmg_mul.wall or 1)
	end

	if col_ray.unit and col_ray.unit:in_slot(self.enemy_mask) then
		if self._hit_through_enemy then
			damage_mul = damage_mul * (self._penetration_dmg_mul and self._penetration_dmg_mul.enemy or 1)
		end

		self._hit_through_enemy = true
	end

	if self._optimal_distance + self._optimal_range == 0 then
		return damage * damage_mul
	end

	local distance = col_ray.distance or mvector3.distance(col_ray.unit:position(), user_unit:position())
	local near_dist = self._optimal_distance - self._near_falloff
	local optimal_start = self._optimal_distance
	local optimal_end = self._optimal_distance + self._optimal_range
	local far_dist = optimal_end + self._far_falloff
	local near_mul = self._near_multiplier
	local optimal_mul = 1
	local far_mul = self._far_multiplier
	local multiplier = self:falloff_range_multiplier()

	optimal_end = optimal_end * multiplier
	far_dist = far_dist * multiplier

	if distance < self._optimal_distance then
		if self._near_falloff > 0 then
			damage_mul = math.map_range_clamped(distance, near_dist, optimal_start, near_mul, optimal_mul)
		else
			damage_mul = near_mul
		end
	elseif distance < optimal_end then
		damage_mul = optimal_mul
	elseif self._far_falloff > 0 then
		damage_mul = math.map_range_clamped(distance, optimal_end, far_dist, optimal_mul, far_mul)
	else
		damage_mul = far_mul
	end

	return damage * damage_mul
end

--Hitmarker size now scales linearly based on distance to make falloff more readable
function NewRaycastWeaponBase:is_weak_hit(distance, user_unit)
	if not distance or not user_unit or self._optimal_distance + self._optimal_range == 0 then
		return 1
	end

	local multiplier = self:falloff_range_multiplier()

	local optimal_end = (self._optimal_distance + self._optimal_range) * multiplier
	local far_dist = self._far_falloff * multiplier

	local scale_mul = 0

	local f = math.clamp(math.max(0, (distance - optimal_end)) / far_dist, 0, 1)

	scale_mul = math.lerp(1, 0.5, f)

	return scale_mul
end
