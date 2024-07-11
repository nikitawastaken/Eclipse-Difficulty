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
				stat_name = "extra_ammo"
			},
			{
				round_value = true,
				name = "totalammo",
				stat_name = "total_ammo_mod"
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
				name = "fire_rate"
			},
			{
				name = "damage"
			},
			{
				percent = true,
				name = "spread",
				offset = true,
				revert = true
			},
			{
				percent = true,
				name = "recoil",
				offset = true,
				revert = true
			},
			{
				index = true,
				name = "concealment"
			},
			{
				percent = false,
				name = "suppression",
				offset = true
			}
		}
		self:set_weapon_stats(self._info_panel, stats)
		self:_update_info_weapon(name)
	end
end)
