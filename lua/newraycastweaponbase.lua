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

	self._steelsight_move_speed_mul = weapon_tweak.steelsight_move_speed_mul or 0.6

	self._steelsight_time = weapon_tweak.steelsight_time or 0.3

	self._sprint_exit_time = weapon_tweak.sprint_exit_time or 0.4

	self._total_ammo_multiplier = weapon_tweak.total_ammo_multiplier or 1

	self._swap_speed_multiplier = weapon_tweak.swap_speed_multiplier or 1

	self._fire_rate_multiplier = weapon_tweak.fire_rate_multiplier or 1

	self._steelsight_speed_multiplier = weapon_tweak.steelsight_speed_multiplier or 1

	self._reload_speed_multiplier = weapon_tweak.reload_speed_multiplier or 1

	self._exit_run_speed_multiplier = weapon_tweak.exit_run_speed_multiplier or 1

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

	for part_id, stats in pairs(custom_stats) do
		if stats.steelsight_move_speed_mul then
			self._steelsight_move_speed_mul = stats.steelsight_move_speed_mul
		end

		if stats.swap_speed_multiplier then
			self._swap_speed_multiplier = self._swap_speed_multiplier * stats.swap_speed_multiplier
		end

		if stats.steelsight_speed_multiplier then
			self._steelsight_speed_multiplier = self._steelsight_speed_multiplier * stats.steelsight_speed_multiplier
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

		if stats.total_ammo_multiplier then
			self._total_ammo_multiplier = self._total_ammo_multiplier * stats.total_ammo_multiplier
		end

		local stats_stance_mul = stats.stance_mul

		if stats_stance_mul then
			if stats.stance_mul.recoil then
				if stats_stance_mul.recoil.standing then
					self._standing_hipfire_recoil_mul = stats_stance_mul.recoil.standing.hipfire
					self._standing_crouching_recoil_mul = stats_stance_mul.recoil.standing.crouching
					self._standing_steelsight_recoil_mul = stats_stance_mul.recoil.standing.steelsight
				elseif stats_stance_mul.recoil.moving then
					self._moving_hipfire_recoil_mul = stats_stance_mul.recoil.moving.hipfire
					self._moving_crouching_recoil_mul = stats_stance_mul.recoil.moving.crouching
					self._moving_steelsight_recoil_mul = stats_stance_mul.recoil.moving.steelsight
				end
			elseif stats.stance_mul.spread then
				if stats_stance_mul.spread.standing then
					self._standing_hipfire_spread_mul = stats_stance_mul.spread.standing.hipfire
					self._standing_crouching_spread_mul = stats_stance_mul.spread.standing.crouching
					self._standing_steelsight_spread_mul = stats_stance_mul.spread.standing.steelsight
				elseif stats_stance_mul.spread.moving then
					self._moving_hipfire_spread_mul = stats_stance_mul.spread.moving.hipfire
					self._moving_crouching_spread_mul = stats_stance_mul.spread.moving.crouching
					self._moving_steelsight_spread_mul = stats_stance_mul.spread.moving.steelsight
				end
			end
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

function NewRaycastWeaponBase:steelsight_move_speed_multiplier()
	return self._steelsight_move_speed_mul
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

			multiplier = multiplier * managers.player:upgrade_value("weapon", "moving_recoil_penalty_reduction", 1)
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

function NewRaycastWeaponBase:reload_speed_multiplier()
	if self._current_reload_speed_multiplier then
		return self._current_reload_speed_multiplier
	end

	local multiplier = 1

	multiplier = multiplier + 1 - self._reload_speed_multiplier

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		multiplier = multiplier + 1 - managers.player:upgrade_value(category, "reload_speed_multiplier", 1)

		if category == "shotgun" then -- shotgun reload speed stuff
			if self._use_shotgun_reload then
				multiplier = multiplier + 1 - managers.player:upgrade_value("shotgun", "pump_reload_speed_mul", 1)
			else
				multiplier = multiplier + 1 - managers.player:upgrade_value("shotgun", "mag_reload_speed_mul", 1)
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

function NewRaycastWeaponBase:enter_steelsight_speed_multiplier()
	local weapon_tweak = self:weapon_tweak_data()
	local categories = weapon_tweak.categories

	local steelsight_time = (tweak_data.player.TRANSITION_DURATION or 0.23) / self._steelsight_time

	local multiplier = 1

	multiplier = multiplier + 1 - self._steelsight_speed_multiplier

	for _, category in ipairs(categories) do
		multiplier = multiplier + 1 - managers.player:upgrade_value(category, "enter_steelsight_speed_multiplier", 1)
	end

	multiplier = multiplier + 1 - managers.player:temporary_upgrade_value("temporary", "combat_medic_enter_steelsight_speed_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value(self._name_id, "enter_steelsight_speed_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "enter_steelsight_speed_multiplier", 1)

	if self._silencer then
		multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "silencer_enter_steelsight_speed_multiplier", 1)

		for _, category in ipairs(categories) do
			multiplier = multiplier + 1 - managers.player:upgrade_value(category, "silencer_enter_steelsight_speed_multiplier", 1)
		end
	end

	multiplier = self:_convert_add_to_mul(multiplier)

	multiplier = multiplier * steelsight_time

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

Hooks:PreHook(NewRaycastWeaponBase, "_fire_raycast", "eclipse_fire_raycast", function(self)
	self._enemy_penetrations = nil
	self._hit_through_enemy = nil
	self._hit_through_wall = nil
	self._hit_through_shield = nil
end)

Hooks:PostHook(NewRaycastWeaponBase, "get_damage_falloff", "eclipse_get_damage_falloff", function(self, damage, hit)
	local multiplier = 1

	local weapon_tweak = self:weapon_tweak_data()
	local penetration_dmg_mul = weapon_tweak.penetration_damage_mul

	self._hit_through_enemy = self._hit_through_enemy or hit.unit:in_slot(self.enemy_mask)
	self._hit_through_wall = self._hit_through_wall or hit.unit:in_slot(self.wall_mask)
	self._hit_through_shield = self._hit_through_shield or hit.unit:in_slot(self.shield_mask)

	if self._hit_through_enemy then
		self._enemy_penetrations = (self._enemy_penetrations or 0) + 1

		if self._enemy_penetrations > 1 then
			local pen_mult = (penetration_dmg_mul and penetration_dmg_mul.enemy or 1) ^ math.max(1, self._enemy_penetrations - 1)

			multiplier = multiplier * pen_mult
		end
	end

	multiplier = multiplier * (self._hit_through_wall and penetration_dmg_mul and penetration_dmg_mul.wall or 1)
	multiplier = multiplier * (self._hit_through_shield and penetration_dmg_mul and penetration_dmg_mul.shield or 1)

	return Hooks:GetReturn() * multiplier
end)

-- percentage clip ammo increase upgrade
function NewRaycastWeaponBase:calculate_ammo_max_per_clip()
	local added = 0
	local weapon_tweak_data = self:weapon_tweak_data()

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

	local ammo = tweak_data.weapon[self._name_id].CLIP_AMMO_MAX + added
	ammo = ammo + managers.player:upgrade_value(self._name_id, "clip_ammo_increase")

	if not self:upgrade_blocked("weapon", "clip_ammo_increase") then
		ammo = math.ceil(ammo * managers.player:upgrade_value("weapon", "clip_ammo_increase", 1))
	end

	for _, category in ipairs(tweak_data.weapon[self._name_id].categories) do
		if not self:upgrade_blocked(category, "clip_ammo_increase") then
			ammo = ammo + managers.player:upgrade_value(category, "clip_ammo_increase", 0)
		end
	end

	ammo = ammo + (self._extra_ammo or 0)

	return ammo
end
