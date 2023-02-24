_G.CloneClass(WeaponDescription)
function WeaponDescription._get_mods_stats(name, base_stats, equipped_mods, bonus_stats)
	local mods_stats = WeaponDescription.orig._get_mods_stats(name, base_stats, equipped_mods, bonus_stats)

	if equipped_mods then
		local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
		local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
		local part_data = nil

		local clip_multiplier = 1
		for _, mod in ipairs(equipped_mods) do
			part_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(mod, factory_id, default_blueprint)

			if part_data and part_data.custom_stats then
				if part_data.custom_stats.clip_multiplier then
					clip_multiplier = part_data.custom_stats.clip_multiplier
				end
			end
		end

		local extra_ammo = base_stats.magazine.value * (clip_multiplier - 1)
		mods_stats.magazine.value = mods_stats.magazine.value + math.ceil(extra_ammo)
	end

	return mods_stats
end


function WeaponDescription._get_weapon_mod_stats(mod_name, weapon_name, base_stats, mods_stats, equipped_mods)
	local mod_stats = WeaponDescription.orig._get_weapon_mod_stats(mod_name, weapon_name, base_stats, mods_stats, equipped_mods)

	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(weapon_name)
	local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
	local part_data = nil

	for _, mod in pairs(mod_stats) do
		part_data = nil

		if mod.name then
			part_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(mod.name, factory_id, default_blueprint)
		end

		local clip_multiplier = 1
		if part_data and part_data.custom_stats then
			if part_data.custom_stats.clip_multiplier then
				clip_multiplier = part_data.custom_stats.clip_multiplier
			end
		end

		local extra_ammo = base_stats.magazine.value * (clip_multiplier - 1)
		mod.magazine = mod.magazine + math.ceil(extra_ammo)
	end

	return mod_stats
end