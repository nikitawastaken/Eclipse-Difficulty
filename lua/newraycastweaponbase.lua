function NewRaycastWeaponBase:movement_penalty()
	if managers.player:has_category_upgrade("player", "no_movement_penalty") then
		return 1
	else
		return self._movement_penalty or 1
	end
end

-- remove ARs from BE
local ids_auto = Idstring("auto")
function NewRaycastWeaponBase:get_add_head_shot_mul()
	if self:is_category("smg", "lmg", "minigun") and self._fire_mode == ids_auto or self:is_category("bow", "saw") then
		return managers.player:upgrade_value("weapon", "automatic_head_shot_add", nil)
	end

	return nil
end

Hooks:PostHook(NewRaycastWeaponBase, "init", "eclipse_init", function(self)
	self._shots_fired_consecutively = 0
end)

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

	self._shots_fired_consecutively = self._shots_fired_consecutively + 1

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
	local user_unit = self._setup and self._setup.user_unit

	if user_unit then
		is_moving = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state._moving
	end

	local multiplier = managers.blackmarket:recoil_multiplier(self._name_id, self:weapon_tweak_data().categories, self._silencer, self._blueprint, is_moving)

	if self._alt_fire_active and self._alt_fire_data then
		multiplier = multiplier * (self._alt_fire_data.recoil_mul or 1)
	end

	-- spray recoil reduction upgrade
	for _, category in ipairs(self:weapon_tweak_data().categories) do
		multiplier = multiplier * math.max(tweak_data.upgrades.max_spray_recoil_reduction, (1 - (managers.player:upgrade_value(category, "spray_recoil_multiplier", 0) * self._shots_fired_consecutively)))
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

	if not current_state:in_steelsight() then -- change the upgrade to hipfire instead of movement
		mul = mul + 1 - pm:upgrade_value("player", "weapon_movement_stability", 1)
	end

	mul = mul + 1 - pm:get_property("desperado", 1)

	return self:_convert_add_to_mul(mul)
end