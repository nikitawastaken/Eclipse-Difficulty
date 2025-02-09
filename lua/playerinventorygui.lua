-- Fix melee weapon knockdown stat display
Hooks:PreHook(PlayerInventoryGui, "set_melee_stats", "shc_set_melee_stats", function(self, panel, data)
	for _, v in pairs(data) do
		if v.name == "damage_effect" then
			v.multiple_of = nil
			return
		end
	end
end)

Hooks:PostHook(PlayerInventoryGui, "_update_stats", "eclipse__update_stats", function(self, name)
	if name == "primary" or name == "secondary" then
		local stats = {
			{
				round_value = true,
				name = "magazine",
				stat_name = "extra_ammo",
			},
			{
				round_value = true,
				name = "totalammo",
				stat_name = "total_ammo_mod",
			},
			{
				name = "pickup",
			},
			{
				inverted = true,
				name = "reload",
			},
			{
				round_value = true,
				name = "fire_rate",
			},
			{
				name = "damage",
			},
			{
				percent = true,
				name = "spread",
				offset = true,
				revert = true,
			},
			{
				percent = true,
				name = "recoil",
				offset = true,
				revert = true,
			},
			{
				index = true,
				name = "concealment",
			},
			{
				percent = false,
				name = "suppression",
				offset = true,
			},
		}
		self:set_weapon_stats(self._info_panel, stats)
		self:_update_info_weapon(name)
	end
end)

local function get_pellets_from_blueprint(name, blueprint, category, slot)
	local new_rays = WeaponDescription._get_custom_pellet_stats(name, category, slot, blueprint)
	if table.contains(tweak_data.weapon[name].categories, "grenade_launcher") then
		-- Grenade launchers have a base rays stat of 8 even though
		-- the stat is only used when sting grenades are equipped...
		return 1, tweak_data.weapon[name].rays
	else
		return tweak_data.weapon[name].rays, new_rays
	end
end

Hooks:PostHook(PlayerInventoryGui, "_update_info_weapon", "eclipse_playerinventorygui_update_info_weapon", function(self, name)
	local category = name == "primary" and "primaries" or "secondaries"
	-- Shotgun check
	local equipped_name
	if category == "primaries" then
		equipped_name = managers.blackmarket:equipped_primary().weapon_id
	else
		equipped_name = managers.blackmarket:equipped_secondary().weapon_id
	end

	local weapon_tweak = tweak_data.weapon[equipped_name]
	if not weapon_tweak then
		return
	end

	local shotgun = table.contains(weapon_tweak.categories, "shotgun")

	-- Maybe there's a less verbose way to get your equipped
	-- weapon's mods and filter them but I'm not sure
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(equipped_name)
	local equipped_item = managers.blackmarket:equipped_item(category)
	local equipped_slot = managers.blackmarket:equipped_weapon_slot(category)
	local equipped_blueprint = managers.blackmarket:get_weapon_blueprint(category, equipped_slot)
	local ammo_mods = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("ammo", factory_id, equipped_blueprint)
	local sting = false
	for _, id in ipairs(ammo_mods) do
		local part = managers.weapon_factory:_part_data(id, factory_id)
		if part.sub_type and part.sub_type == "ammo_hornet" then
			sting = true
		end
	end
	if not shotgun and not sting then
		return
	end

	-- Preliminary number calcs
	local base_stats, mods_stats, skill_stats = WeaponDescription._get_stats(equipped_item.weapon_id, category, equipped_slot)
	local total_damage = math.max(base_stats.damage.value + mods_stats.damage.value + skill_stats.damage.value, 0)
	local base_damage = base_stats.damage.value

	local base_rays, rays = get_pellets_from_blueprint(equipped_name, equipped_blueprint, category, equipped_slot)

	self._stats_texts.damage.total:set_text(total_damage .. "x" .. (rays or base_rays))
	if shotgun then
		-- Only shotguns actually use their base pellet stat
		-- GLs have a base pellet stat that's only used for
		-- sting grenades for some reason...
		self._stats_texts.damage.base:set_text(base_damage .. "x" .. base_rays)
	else
		self._stats_texts.damage.base:set_text(base_damage)
	end

	local value = math.max(base_stats.damage.value + mods_stats.damage.value + skill_stats.damage.value, 0) * (rays or 1)
	local base = base_stats.damage.value * (old_rays or 1)
	if base < value then
		self._stats_texts.damage.total:set_color(tweak_data.screen_colors.stats_positive)
	elseif value < base then
		self._stats_texts.damage.total:set_color(tweak_data.screen_colors.stats_negative)
	else
		self._stats_texts.damage.total:set_color(tweak_data.screen_colors.text)
	end
end)
