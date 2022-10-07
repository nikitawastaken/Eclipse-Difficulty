Hooks:PostHook(BlackMarketTweakData, "init", "eclipse_init", function(self)

	-- obey weapon movement speed penalty
	for _, weap_data in pairs(self.melee_weapons) do
		weap_data.stats.remove_weapon_movement_penalty = nil
	end

	-- nuke silent sentry gun
	self.deployables.sentry_gun_silent = nil
end)