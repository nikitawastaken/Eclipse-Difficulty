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
	self._shield_knock = false
end)

Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", "eclipse_update_stats_values", function(self, disallow_replenish)
	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
	local weapon_tweak = self:weapon_tweak_data()

	local fire_mode_data = self:weapon_tweak_data().fire_mode_data or {}
	local toggable_fire_modes = fire_mode_data and fire_mode_data.toggable

	if not disallow_replenish and not (self._name_id and self._name_id:find("crew")) then
		-- Extra start out ammo upgrade
		local is_starting_out_with_extra_ammo = managers.player:has_category_upgrade("player", "start_out_ammo_multiplier")
		self:replenish(is_starting_out_with_extra_ammo)
	end

	if toggable_fire_modes then
		self._toggable_fire_modes = {}

		for _, fire_mode in ipairs(toggable_fire_modes) do
			if FIRE_MODE_IDS[fire_mode] then
				table.insert(self._toggable_fire_modes, FIRE_MODE_IDS[fire_mode])
			end
		end
	end

	self._explosive_ammo = weapon_tweak.explosive_ammo

	self._fire_modes = toggable_fire_modes or weapon_tweak.CAN_TOGGLE_FIREMODE and { "auto", "single" } or { "single" }

	self._steelsight_move_speed_mul = weapon_tweak.steelsight_move_speed_mul or 0.6

	self._steelsight_time = weapon_tweak.steelsight_time or 0.25

	self._sprint_exit_time = weapon_tweak.sprint_exit_time or 0.4

	self._swap_speed_multiplier = weapon_tweak.swap_speed_multiplier or 1

	self._fire_rate_multiplier = weapon_tweak.fire_rate_multiplier or 1

	self._reload_speed_multiplier = weapon_tweak.reload_speed_multiplier or 1

	self._exit_run_speed_multiplier = weapon_tweak.exit_run_speed_multiplier or 1

	self._fire_mode_multipliers = weapon_tweak.fire_mode_multipliers or {}

	local recoil_muls = weapon_tweak.stance_multipliers and weapon_tweak.stance_multipliers.recoil
	local spread_muls = weapon_tweak.stance_multipliers and weapon_tweak.stance_multipliers.spread

	self._standing_hipfire_recoil_mul = recoil_muls and recoil_muls.standing and recoil_muls.standing.hipfire or 1
	self._standing_crouching_recoil_mul = recoil_muls and recoil_muls.standing and recoil_muls.standing.crouching or 1
	self._standing_steelsight_recoil_mul = recoil_muls and recoil_muls.standing and recoil_muls.standing.steelsight or 1

	self._moving_hipfire_recoil_mul = recoil_muls and recoil_muls.moving and recoil_muls.moving.hipfire or 1
	self._moving_crouching_recoil_mul = recoil_muls and recoil_muls.moving and recoil_muls.moving.crouching or 1
	self._moving_steelsight_recoil_mul = recoil_muls and recoil_muls.moving and recoil_muls.moving.steelsight or 1

	self._standing_hipfire_spread_mul = spread_muls and spread_muls.standing and spread_muls.standing.hipfire or 1
	self._standing_crouching_spread_mul = spread_muls and spread_muls.standing and spread_muls.standing.crouching or 1
	self._standing_steelsight_spread_mul = spread_muls and spread_muls.standing and spread_muls.standing.steelsight or 1

	self._moving_hipfire_spread_mul = spread_muls and spread_muls.moving and spread_muls.moving.hipfire or 1
	self._moving_crouching_spread_mul = spread_muls and spread_muls.moving and spread_muls.moving.crouching or 1
	self._moving_steelsight_spread_mul = spread_muls and spread_muls.moving and spread_muls.moving.steelsight or 1

	if self._ammo_data then
		if self._ammo_data.explosive_ammo ~= nil then
			self._explosive_ammo = self._ammo_data.explosive_ammo
		end
	end

	for _, stats in pairs(custom_stats) do
		if stats.steelsight_move_speed_mul then
			self._steelsight_move_speed_mul = stats.steelsight_move_speed_mul
		end

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

		if stats.fire_mode_mul then
			self._fire_mode_multipliers = stats.fire_mode_mul
		end

		if stats.ammo_max_mul then
			self._ammo_max_mul = (self._ammo_max_mul or 1) * stats.ammo_max_mul
		end

		if stats.steelsight_time_mul then
			self._steelsight_time_mul = (self._steelsight_time_mul or 1) * stats.steelsight_time_mul
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

-- Calculate weapon swap speed and sprint-to-fire speed based on concealment
function NewRaycastWeaponBase:concealment_to_handling()
	--[[
	local base_stats = self:weapon_tweak_data().stats
	local parts_stats = managers.weapon_factory:get_stats(self._factory_id, self._blueprint)

	local multiplier = 1

	local total_concealment = math.max((base_stats and base_stats.concealment or 0) + (parts_stats and parts_stats.concealment or 0), 0)
	local concealment_stat_table = tweak_data.weapon.stats and tweak_data.weapon.stats.concealment

	local concealment_lerp = total_concealment / #concealment_stat_table

	multiplier = multiplier * math.lerp(0.5, 1.5, concealment_lerp)

	return multiplier
]]
	return 1
end

-- Body Expertise only works on LMGs and Miniguns
function NewRaycastWeaponBase:get_add_head_shot_mul()
	if self:is_category("lmg", "minigun") then
		return managers.player:upgrade_value("weapon", "automatic_head_shot_add", nil)
	end

	return nil
end

function NewRaycastWeaponBase:steelsight_move_speed_multiplier()
	if managers.player:has_category_upgrade("weapon", "steelsight_move_speed_penalty_multiplier") then
		local speed_penalty = 1 - self._steelsight_move_speed_mul
		return (1 - speed_penalty * managers.player:upgrade_value("weapon", "steelsight_move_speed_penalty_multiplier", 1))
	end

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
		in_steelsight = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state:full_steelsight()
	end

	local weapon_tweak = self:weapon_tweak_data()

	for _, fire_mode in ipairs(self._fire_modes) do
		if self:fire_mode() == fire_mode then
			multiplier = multiplier * (self._fire_mode_multipliers and self._fire_mode_multipliers[fire_mode] and self._fire_mode_multipliers[fire_mode].recoil or 1)
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
		in_steelsight = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state:full_steelsight()
	end

	local weapon_tweak = self:weapon_tweak_data()

	for _, fire_mode in ipairs(self._fire_modes) do
		if self:fire_mode() == fire_mode then
			multiplier = multiplier * (self._fire_mode_multipliers and self._fire_mode_multipliers[fire_mode] and self._fire_mode_multipliers[fire_mode].spread or 1)
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

	if managers.player:current_state() and managers.player:current_state() == "bipod" then
		multiplier = multiplier * (weapon_tweak.stance_multipliers and weapon_tweak.stance_multipliers.spread and weapon_tweak.stance_multipliers.spread.bipod or 1)
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

	for _, fire_mode in ipairs(self._fire_modes) do
		if self:fire_mode() == fire_mode then
			multiplier = multiplier * (self._fire_mode_multipliers and self._fire_mode_multipliers[fire_mode] and self._fire_mode_multipliers[fire_mode].fire_rate or 1)
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
	local pm = managers.player

	multiplier = multiplier + 1 - self._reload_speed_multiplier

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		multiplier = multiplier + 1 - pm:upgrade_value(category, "reload_speed_multiplier", 1)

		if category == "shotgun" then -- shotgun reload speed stuff
			local current_weapon_is_double_barrel = self:_weapon_tweak_data_id() == "huntsman" or self:_weapon_tweak_data_id() == "b682" or self:_weapon_tweak_data_id() == "coach"

			if self._use_shotgun_reload or current_weapon_is_double_barrel then
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

function NewRaycastWeaponBase:enter_steelsight_speed_multiplier()
	local weapon_tweak = self:weapon_tweak_data()
	local categories = weapon_tweak.categories

	local steelsight_time = (tweak_data.player.TRANSITION_DURATION or 0.23) / (self._steelsight_time * (self._steelsight_time_mul or 1))

	local multiplier = 1

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
	local penetration_dmg_mul = weapon_tweak.penetration_damage_mul

	self._hit_through_enemy = self._hit_through_enemy or hit.unit:in_slot(self.enemy_mask)
	self._hit_through_wall = self._hit_through_wall or hit.unit:in_slot(self.wall_mask)
	self._hit_through_shield = self._hit_through_shield or hit.unit:in_slot(self.shield_mask)

	if self._hit_through_enemy then
		self._enemy_penetrations = (self._enemy_penetrations or 0) + 1

		if self._enemy_penetrations > 1 then
			local enemy_pen_mult = (penetration_dmg_mul and penetration_dmg_mul.enemy or 1) ^ math.max(1, self._enemy_penetrations - 1)

			multiplier = multiplier * enemy_pen_mult
		end
	end

	if self._hit_through_wall then
		self._wall_penetrations = (self._wall_penetrations or 0) + 1

		if self._wall_penetrations > 1 then
			local wall_pen_mult = (penetration_dmg_mul and penetration_dmg_mul.wall or 1) ^ math.max(1, self._wall_penetrations - 1)

			multiplier = multiplier * wall_pen_mult
		end
	end

	if self._hit_through_shield then
		self._shield_penetrations = (self._shield_penetrations or 0) + 1

		if self._shield_penetrations > 1 then
			local shield_pen_mult = (penetration_dmg_mul and penetration_dmg_mul.shield or 1) ^ math.max(1, self._shield_penetrations - 1)

			multiplier = multiplier * shield_pen_mult
		end
	end
	
	return Hooks:GetReturn() * multiplier
end)

-- percentage clip ammo increase upgrade
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

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value(category, "extra_ammo_multiplier", 1)
	end

	ammo_max_multiplier = ammo_max_multiplier * ammo_max_multiplier * (self._ammo_max_mul or 1)
	ammo_max_multiplier = ammo_max_multiplier + ammo_max_multiplier * (self._total_ammo_mod or 0)

	if managers.player:has_category_upgrade("player", "add_armor_stat_skill_ammo_mul") then
		ammo_max_multiplier = ammo_max_multiplier * managers.player:body_armor_value("skill_ammo_mul", nil, 1)
	end

	ammo_max_multiplier = managers.modifiers:modify_value("WeaponBase:GetMaxAmmoMultiplier", ammo_max_multiplier)
	local ammo_max_per_clip = self:calculate_ammo_max_per_clip()
	local ammo_max = math.round((tweak_data.weapon[self._name_id].AMMO_MAX + managers.player:upgrade_value(self._name_id, "clip_amount_increase") * ammo_max_per_clip) * ammo_max_multiplier)
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
