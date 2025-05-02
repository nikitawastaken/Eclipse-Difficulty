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
	local weapon_tweak = tweak_data.weapon[name]
	local pickup_multiplier = managers.player:upgrade_value("player", "pick_up_ammo_multiplier", 1)

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
	local mul = tweak_data.weapon[name].steelsight_speed_multiplier or 1
	return tweak_data.weapon[name].steelsight_time * mul
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
	return tweak_data.weapon[name].rays
end

local old_weapon_desc_base_stats = WeaponDescription._get_base_stats
function WeaponDescription._get_base_stats(name)
	local result = old_weapon_desc_base_stats(name)
	local weapon_tweak = tweak_data.weapon[name]

	-- Custom fire rate multiplier
	if weapon_tweak.fire_rate_multiplier then
		result.fire_rate.value = result.fire_rate.value * weapon_tweak.fire_rate_multiplier
	end
	return result
end

local old_weapon_desc_mods_stats = WeaponDescription._get_mods_stats
function WeaponDescription._get_mods_stats(name, base, mods, bonus)
	local result = old_weapon_desc_mods_stats(name, base, mods, bonus)

	if base.reload and mods then
		local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
		local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)

		for _, mod in ipairs(mods) do
			local part_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(mod, factory_id, default_blueprint)
			if part_data and part_data.custom_stats and part_data.custom_stats.reload_speed_multiplier then
				local multiplier_addend = base.reload.value - (base.reload.value * part_data.custom_stats.reload_speed_multiplier)
				result.reload.value = result.reload.value + multiplier_addend
			end
		end
	end
	return result
end

-- percentage ammo increase upgrade
function WeaponDescription.get_weapon_ammo_info(weapon_id, extra_ammo, total_ammo_mod)
	local weapon_tweak_data = tweak_data.weapon[weapon_id]
	local ammo_max_multiplier = managers.player:upgrade_value("player", "extra_ammo_multiplier", 1)
	local primary_category = weapon_tweak_data.categories[1]
	local category_skill_in_effect = false
	local category_multiplier = 1

	for _, category in ipairs(weapon_tweak_data.categories) do
		if managers.player:has_category_upgrade(category, "extra_ammo_multiplier") then
			category_multiplier = category_multiplier + managers.player:upgrade_value(category, "extra_ammo_multiplier", 1) - 1
			category_skill_in_effect = true
		end
	end

	ammo_max_multiplier = ammo_max_multiplier * category_multiplier

	if managers.player:has_category_upgrade("player", "add_armor_stat_skill_ammo_mul") then
		ammo_max_multiplier = ammo_max_multiplier * managers.player:body_armor_value("skill_ammo_mul", nil, 1)
	end

	local function get_ammo_max_per_clip(weapon_id)
		local function upgrade_blocked(category, upgrade)
			if not weapon_tweak_data.upgrade_blocks then
				return false
			end

			if not weapon_tweak_data.upgrade_blocks[category] then
				return false
			end

			return table.contains(weapon_tweak_data.upgrade_blocks[category], upgrade)
		end

		local clip_base = weapon_tweak_data.CLIP_AMMO_MAX
		local clip_mod = extra_ammo and tweak_data.weapon.stats.extra_ammo[extra_ammo] or 0
		local clip_skill = managers.player:upgrade_value(weapon_id, "clip_ammo_increase")
		local clip_skill_mul = 1

		if not upgrade_blocked("weapon", "clip_ammo_increase") then
			clip_skill_mul = managers.player:upgrade_value("weapon", "clip_ammo_increase", 1)
		end

		for _, category in ipairs(weapon_tweak_data.categories) do
			if not upgrade_blocked(category, "clip_ammo_increase") then
				clip_skill = clip_skill + managers.player:upgrade_value(category, "clip_ammo_increase", 0)
			end
		end

		return (clip_base + clip_mod + clip_skill) * clip_skill_mul
	end

	local ammo_max_per_clip = get_ammo_max_per_clip(weapon_id)
	local ammo_max = tweak_data.weapon[weapon_id].AMMO_MAX
	local ammo_from_mods = ammo_max * (total_ammo_mod and tweak_data.weapon.stats.total_ammo_mod[total_ammo_mod] or 0)
	ammo_max = (ammo_max + ammo_from_mods + managers.player:upgrade_value(weapon_id, "clip_amount_increase") * ammo_max_per_clip) * ammo_max_multiplier
	ammo_max_per_clip = math.min(ammo_max_per_clip, ammo_max)
	local ammo_data = {
		base = tweak_data.weapon[weapon_id].AMMO_MAX,
		mod = ammo_from_mods + managers.player:upgrade_value(weapon_id, "clip_amount_increase") * ammo_max_per_clip,
	}
	ammo_data.skill = (ammo_data.base + ammo_data.mod) * ammo_max_multiplier - ammo_data.base - ammo_data.mod
	ammo_data.skill_in_effect = managers.player:has_category_upgrade("player", "extra_ammo_multiplier")
		or category_skill_in_effect
		or managers.player:has_category_upgrade("player", "add_armor_stat_skill_ammo_mul")

	return ammo_max_per_clip, ammo_max, ammo_data
end

local function is_weapon_category(weapon_tweak, ...)
	local arg = {
		...,
	}
	local categories = weapon_tweak.categories

	for i = 1, #arg do
		if table.contains(categories, arg[i]) then
			return true
		end
	end

	return false
end

function WeaponDescription._get_skill_stats(name, category, slot, base_stats, mods_stats, silencer, single_mod, auto_mod, blueprint)
	local skill_stats = {}
	local tweak_stats = tweak_data.weapon.stats

	for _, stat in pairs(WeaponDescription._stats_shown) do
		skill_stats[stat.name] = {
			value = 0,
		}
	end

	local detection_risk = 0

	if category then
		local custom_data = {
			[category] = managers.blackmarket:get_crafted_category_slot(category, slot),
		}
		detection_risk = managers.blackmarket:get_suspicion_offset_from_custom_data(custom_data, tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
		detection_risk = detection_risk * 100
	end

	local base_value, base_index, modifier, multiplier = nil
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
	local weapon_tweak = tweak_data.weapon[name]
	local primary_category = weapon_tweak.categories[1]

	for _, stat in ipairs(WeaponDescription._stats_shown) do
		if weapon_tweak.stats[stat.stat_name or stat.name] or stat.name == "totalammo" or stat.name == "fire_rate" then
			if stat.name == "magazine" then
				skill_stats[stat.name].value = managers.player:upgrade_value(name, "clip_ammo_increase", 0)
				local has_magazine = weapon_tweak.has_magazine
				local add_modifier = false

				if is_weapon_category(weapon_tweak, "shotgun") and has_magazine then
					skill_stats[stat.name].value = skill_stats[stat.name].value + managers.player:upgrade_value("shotgun", "magazine_capacity_inc", 0)
					add_modifier = managers.player:has_category_upgrade("shotgun", "magazine_capacity_inc")

					if primary_category == "akimbo" then
						skill_stats[stat.name].value = skill_stats[stat.name].value * 2
					end
				elseif is_weapon_category(weapon_tweak, "pistol") and not is_weapon_category(weapon_tweak, "revolver") and managers.player:has_category_upgrade("pistol", "magazine_capacity_inc") then
					skill_stats[stat.name].value = skill_stats[stat.name].value + managers.player:upgrade_value("pistol", "magazine_capacity_inc", 0)

					if primary_category == "akimbo" then
						skill_stats[stat.name].value = skill_stats[stat.name].value * 2
					end

					add_modifier = true
				elseif is_weapon_category(weapon_tweak, "smg", "assault_rifle", "lmg") then
					skill_stats[stat.name].value = skill_stats[stat.name].value + managers.player:upgrade_value("player", "automatic_mag_increase", 0)
					add_modifier = managers.player:has_category_upgrade("player", "automatic_mag_increase")

					if primary_category == "akimbo" then
						skill_stats[stat.name].value = skill_stats[stat.name].value * 2
					end
				end

				if not weapon_tweak.upgrade_blocks or not weapon_tweak.upgrade_blocks.weapon or not table.contains(weapon_tweak.upgrade_blocks.weapon, "clip_ammo_increase") then
					skill_stats[stat.name].value = math.ceil(base_stats[stat.name].value * (managers.player:upgrade_value("weapon", "clip_ammo_increase", 1) - 1))
				end

				if not weapon_tweak.upgrade_blocks or not weapon_tweak.upgrade_blocks[primary_category] or not table.contains(weapon_tweak.upgrade_blocks[primary_category], "clip_ammo_increase") then
					skill_stats[stat.name].value = skill_stats[stat.name].value + managers.player:upgrade_value(primary_category, "clip_ammo_increase", 0)
				end

				skill_stats[stat.name].skill_in_effect = managers.player:has_category_upgrade(name, "clip_ammo_increase")
					or managers.player:has_category_upgrade("weapon", "clip_ammo_increase")
					or add_modifier
			elseif stat.name == "totalammo" then
				-- Nothing
			elseif stat.name == "reload" then
				local skill_in_effect = false
				local mult = 1

				for _, category in ipairs(weapon_tweak.categories) do
					if managers.player:has_category_upgrade(category, "reload_speed_multiplier") then
						mult = mult + 1 - managers.player:upgrade_value(category, "reload_speed_multiplier", 1)
						skill_in_effect = true
					end
				end

				mult = 1 / managers.blackmarket:_convert_add_to_mul(mult)
				local diff = base_stats[stat.name].value * mult - base_stats[stat.name].value
				skill_stats[stat.name].value = skill_stats[stat.name].value + diff
				skill_stats[stat.name].skill_in_effect = skill_in_effect
			else
				base_value = math.max(base_stats[stat.name].value + mods_stats[stat.name].value, 0)

				if base_stats[stat.name].index and mods_stats[stat.name].index then
					base_index = base_stats[stat.name].index + mods_stats[stat.name].index
				end

				multiplier = 1
				modifier = 0
				local is_single_shot = managers.weapon_factory:has_perk("fire_mode_single", factory_id, blueprint)

				if stat.name == "damage" then
					multiplier = managers.blackmarket:damage_multiplier(name, weapon_tweak.categories, silencer, detection_risk, nil, blueprint)
					modifier =
						math.floor(managers.blackmarket:damage_addend(name, weapon_tweak.categories, silencer, detection_risk, nil, blueprint) * tweak_data.gui.stats_present_multiplier * multiplier)
				elseif stat.name == "spread" then
					local fire_mode = single_mod and "single" or auto_mod and "auto" or weapon_tweak.FIRE_MODE or "single"
					multiplier = managers.blackmarket:accuracy_multiplier(name, weapon_tweak.categories, silencer, nil, nil, fire_mode, blueprint, nil, is_single_shot)
					modifier = managers.blackmarket:accuracy_addend(name, weapon_tweak.categories, base_index, silencer, nil, fire_mode, blueprint, nil, is_single_shot)
						* tweak_data.gui.stats_present_multiplier
				elseif stat.name == "recoil" then
					multiplier = managers.blackmarket:recoil_multiplier(name, weapon_tweak.categories, silencer, blueprint)
					modifier = managers.blackmarket:recoil_addend(name, weapon_tweak.categories, base_index, silencer, blueprint, nil, is_single_shot) * tweak_data.gui.stats_present_multiplier
				elseif stat.name == "suppression" then
					multiplier = managers.blackmarket:threat_multiplier(name, weapon_tweak.categories, silencer)
				elseif stat.name == "concealment" then
					if silencer and managers.player:has_category_upgrade("player", "silencer_concealment_increase") then
						modifier = managers.player:upgrade_value("player", "silencer_concealment_increase", 0)
					end

					if silencer and managers.player:has_category_upgrade("player", "silencer_concealment_penalty_decrease") then
						local stats = managers.weapon_factory:get_perk_stats("silencer", factory_id, blueprint)

						if stats and stats.concealment then
							modifier = modifier + math.min(managers.player:upgrade_value("player", "silencer_concealment_penalty_decrease", 0), math.abs(stats.concealment))
						end
					end
				elseif stat.name == "fire_rate" then
					base_value = math.max(base_stats[stat.name].value, 0)

					if base_stats[stat.name].index then
						base_index = base_stats[stat.name].index
					end

					multiplier = managers.blackmarket:fire_rate_multiplier(name, weapon_tweak.categories, silencer, detection_risk, nil, blueprint)
				end

				if modifier ~= 0 then
					local offset = math.min(tweak_stats[stat.name][1], tweak_stats[stat.name][#tweak_stats[stat.name]]) * tweak_data.gui.stats_present_multiplier

					if stat.revert then
						modifier = -modifier
					end

					if stat.percent then
						local max_stat = stat.index and #tweak_stats[stat.name]
							or math.max(tweak_stats[stat.name][1], tweak_stats[stat.name][#tweak_stats[stat.name]]) * tweak_data.gui.stats_present_multiplier

						if stat.offset then
							max_stat = max_stat - offset
						end

						local ratio = modifier / max_stat
						modifier = ratio * 100
					end
				end

				if stat.revert then
					multiplier = 1 / math.max(multiplier, 0.01)
				end

				skill_stats[stat.name].skill_in_effect = multiplier ~= 1 or modifier ~= 0
				skill_stats[stat.name].value = modifier + base_value * multiplier - base_value
			end
		end
	end

	return skill_stats
end
