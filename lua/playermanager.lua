local old_upgrade_value = PlayerManager.upgrade_value

function PlayerManager:upgrade_value(category, upgrade, ...)
	local _upgrade_value = old_upgrade_value(self, category, upgrade, ...)
	if category == "player" and upgrade == "pick_up_ammo_multiplier" and self:has_category_upgrade("player", "addition_ammo_eclipse") then
		_upgrade_value = _upgrade_value + self:upgrade_value("player", "addition_ammo_eclipse", 0)
	end
	return _upgrade_value
end