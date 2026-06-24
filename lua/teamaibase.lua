-- add basic upgrades to make domination work
TeamAIBase.set_upgrade_value = HuskPlayerBase.set_upgrade_value
TeamAIBase.upgrade_value = HuskPlayerBase.upgrade_value
TeamAIBase.upgrade_level = HuskPlayerBase.upgrade_level

Hooks:PostHook(TeamAIBase, "init", "eclipse_init", function (self)
	self._upgrades = self._upgrades or {}
	self._upgrade_levels = self._upgrade_levels or {}
	self._temporary_upgrades = self._temporary_upgrades or {}
	self._temporary_upgrades_map = self._temporary_upgrades_map or {}
	if managers.player:has_category_upgrade("player", "intimidate_enemies") then
		self:set_upgrade_value("player", "intimidate_enemies", 1)
	end
end)
