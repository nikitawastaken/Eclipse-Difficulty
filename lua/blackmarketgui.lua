-- Fix melee weapon knockdown stat display
Hooks:PreHook(BlackMarketGui, "reload", "shc_reload", function (self)
	self._shc_patch = nil
end)

Hooks:PreHook(BlackMarketGui, "on_slot_selected", "shc_on_slot_selected", function (self)
	if self._shc_patch then
		return
	end
	for _, v in pairs(self._mweapon_stats_shown) do
		if v.name == "damage_effect" then
			v.multiple_of = nil
			self._shc_patch = true
			return
		end
	end
end)