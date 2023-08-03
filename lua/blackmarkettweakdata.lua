Hooks:PostHook(BlackMarketTweakData, "init", "eclipse_init", function(self)
	-- nuke silent sentry gun
	self.deployables.sentry_gun_silent = nil
end)
