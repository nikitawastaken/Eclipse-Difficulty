-- credit for most of the stuff here goes to resmod
local eclipse_custom_stats = {
	{
		name = "pickup",
	},
	{
		name = "steelsight_time",
	},
}
for _, stat in ipairs(eclipse_custom_stats) do
	table.insert(WeaponDescription._stats_shown, stat)
end

local function convert_add_to_mul(value)
	if value > 1 then
		return 1 / value
	elseif value < 1 then
		return math.abs(value - 1) + 1
	else
		return 1
	end
end

function WeaponDescription._get_base_pickup(weapon, name)
	local weapon_tweak = tweak_data.weapon[name]
	local average_pickup = (weapon_tweak.AMMO_PICKUP[1] + weapon_tweak.AMMO_PICKUP[2]) * 0.5

	return average_pickup
end

function WeaponDescription._get_mods_pickup(weapon, name, base_stats)
	local weapon_tweak = tweak_data.weapon[name]
	local ammo_data = managers.weapon_factory:get_ammo_data_from_weapon(weapon.factory_id, weapon.blueprint) or {}
	local min_pickup = weapon_tweak.AMMO_PICKUP[1] * (ammo_data.ammo_pickup_min_mul or 1)
	local max_pickup = weapon_tweak.AMMO_PICKUP[2] * (ammo_data.ammo_pickup_max_mul or 1)
	local custom_data = managers.weapon_factory:get_custom_stats_from_weapon(weapon.factory_id, weapon.blueprint) or {}

	for part_id, stats in pairs(custom_data) do
		if stats.ammo_pickup_min_mul then
			min_pickup = min_pickup * stats.ammo_pickup_min_mul
		end
		if stats.ammo_pickup_max_mul then
			max_pickup = max_pickup * stats.ammo_pickup_max_mul
		end
	end

	local average_pickup = (min_pickup + max_pickup) * 0.5

	return average_pickup - base_stats.pickup.value
end

function WeaponDescription._get_skill_pickup(weapon, name, base_stats, mods_stats)
	local pickup_multiplier = managers.player:upgrade_value("player", "fully_loaded_pick_up_multiplier", 1)

	local weapon_tweak = tweak_data.weapon[name]
	for _, category in ipairs(weapon_tweak.categories) do
		pickup_multiplier = pickup_multiplier + managers.player:upgrade_value(category, "pick_up_multiplier", 1) - 1
	end

	if pickup_multiplier > 1 then
		local ammo_data = managers.weapon_factory:get_ammo_data_from_weapon(weapon.factory_id, weapon.blueprint) or {}
		local min_pickup = weapon_tweak.AMMO_PICKUP[1] * (ammo_data.ammo_pickup_min_mul or 1) * pickup_multiplier
		local max_pickup = weapon_tweak.AMMO_PICKUP[2] * (ammo_data.ammo_pickup_max_mul or 1) * pickup_multiplier
		local custom_data = managers.weapon_factory:get_custom_stats_from_weapon(weapon.factory_id, weapon.blueprint) or {}

		for part_id, stats in pairs(custom_data) do
			if stats.ammo_pickup_min_mul then
				min_pickup = min_pickup * stats.ammo_pickup_min_mul
			end
			if stats.ammo_pickup_max_mul then
				max_pickup = max_pickup * stats.ammo_pickup_max_mul
			end
		end

		local average_pickup = (min_pickup + max_pickup) * 0.5

		return true, average_pickup - mods_stats.pickup.value - base_stats.pickup.value
	else
		return false, 0
	end
end

function WeaponDescription._get_base_steelsight_time(weapon, name)
	return tweak_data.weapon[name].steelsight_time
end

function WeaponDescription._get_mods_steelsight_time(weapon, name, base_stats)
	-- Currently no mods affect ads time
	return 0
end

function WeaponDescription._get_skill_steelsight_time(weapon, name, base_stats, mods_stats)
	local multiplier = 1
	local categories = tweak_data.weapon[name].categories

	for _, category in ipairs(categories) do
		multiplier = multiplier + 1 - managers.player:upgrade_value(category, "enter_steelsight_speed_multiplier", 1)
	end

	multiplier = multiplier + 1 - managers.player:temporary_upgrade_value("temporary", "combat_medic_enter_steelsight_speed_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value(weapon.factory_id, "enter_steelsight_speed_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "enter_steelsight_speed_multiplier", 1)

	if managers.weapon_factory:has_perk("silencer", weapon.factory_id, weapon.blueprint) then
		multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "silencer_enter_steelsight_speed_multiplier", 1)

		for _, category in ipairs(categories) do
			multiplier = multiplier + 1 - managers.player:upgrade_value(category, "silencer_enter_steelsight_speed_multiplier", 1)
		end
	end

	multiplier = convert_add_to_mul(multiplier)

	local result = base_stats.steelsight_time.value / multiplier - mods_stats.steelsight_time.value
	-- Some jank to make sure we don't end up with +0 or -0 on the stats
	-- that also happens to double as a way to test if there exists a skill multiplier
	local new = math.round(base_stats.steelsight_time.value, 0.01)
	local cur = math.round(result, 0.01)
	if new == cur then
		return false, 0
	else
		return true, result - base_stats.steelsight_time.value
	end
end

function WeaponDescription._get_stats(name, category, slot, blueprint)
	local equipped_mods = nil
	local silencer = false
	local single_mod = false
	local auto_mod = false
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
	local blueprint = blueprint or slot and managers.blackmarket:get_weapon_blueprint(category, slot) or managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
	local cosmetics = managers.blackmarket:get_weapon_cosmetics(category, slot)
	local bonus_stats = {}

	if cosmetics and cosmetics.id and cosmetics.bonus and not managers.job:is_current_job_competitive() and not managers.weapon_factory:has_perk("bonus", factory_id, blueprint) then
		bonus_stats = tweak_data:get_raw_value("economy", "bonuses", tweak_data.blackmarket.weapon_skins[cosmetics.id].bonus, "stats") or {}
	end

	if blueprint then
		equipped_mods = deep_clone(blueprint)
		local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
		local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)

		if equipped_mods then
			silencer = managers.weapon_factory:has_perk("silencer", factory_id, equipped_mods)
			single_mod = managers.weapon_factory:has_perk("fire_mode_single", factory_id, equipped_mods)
			auto_mod = managers.weapon_factory:has_perk("fire_mode_auto", factory_id, equipped_mods)
		end
	end

	local base_stats = WeaponDescription._get_base_stats(name)
	local mods_stats = WeaponDescription._get_mods_stats(name, base_stats, equipped_mods, bonus_stats)
	local skill_stats = WeaponDescription._get_skill_stats(name, category, slot, base_stats, mods_stats, silencer, single_mod, auto_mod, blueprint)
	local clip_ammo, max_ammo, ammo_data = WeaponDescription.get_weapon_ammo_info(name, tweak_data.weapon[name].stats.extra_ammo, base_stats.totalammo.index + mods_stats.totalammo.index)
	base_stats.totalammo.value = ammo_data.base
	mods_stats.totalammo.value = ammo_data.mod
	skill_stats.totalammo.value = ammo_data.skill
	skill_stats.totalammo.skill_in_effect = ammo_data.skill_in_effect

	local weapon = {
		factory_id = factory_id,
		blueprint = blueprint,
	}

	base_stats.pickup.value = WeaponDescription._get_base_pickup(weapon, name)
	mods_stats.pickup.value = WeaponDescription._get_mods_pickup(weapon, name, base_stats)
	skill_stats.pickup.skill_in_effect, skill_stats.pickup.value = WeaponDescription._get_skill_pickup(weapon, name, base_stats, mods_stats)

	base_stats.steelsight_time.value = WeaponDescription._get_base_steelsight_time(weapon, name)
	mods_stats.steelsight_time.value = WeaponDescription._get_mods_steelsight_time(weapon, name, base_stats)
	skill_stats.steelsight_time.skill_in_effect, skill_stats.steelsight_time.value = WeaponDescription._get_skill_steelsight_time(weapon, name, base_stats, mods_stats)

	local my_clip = base_stats.magazine.value + mods_stats.magazine.value + skill_stats.magazine.value

	if max_ammo < my_clip then
		mods_stats.magazine.value = mods_stats.magazine.value + max_ammo - my_clip
	end

	return base_stats, mods_stats, skill_stats
end

function WeaponDescription._get_custom_pellet_stats(name, category, slot, blueprint)
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
	local blueprint = blueprint or slot and managers.blackmarket:get_weapon_blueprint(category, slot) or managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
	if not blueprint then
		return
	end

	local equipped_mods = deep_clone(blueprint)
	local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)

	local part_data = nil
	for _, mod in ipairs(equipped_mods) do
		part_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(mod, factory_id, default_blueprint)
		if part_data then
			if part_data.custom_stats and part_data.custom_stats.rays then
				return part_data.custom_stats.rays
			end
		end
	end
end
