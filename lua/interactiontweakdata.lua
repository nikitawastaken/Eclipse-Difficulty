Hooks:PostHook(InteractionTweakData, "init", "eclipse_init", function(self)
	self.revive.timer = 4.5
	self.drill_upgrade.timer = 0
	self.lance_upgrade.timer = 0
	self.gen_int_saw_upgrade.timer = 0

	self.hostage_trade.contour_preset = "hostage_trade_uncustody"
	self.hostage_trade.contour_flash_interval = 0.5
	self.hostage_trade_resources = deep_clone(self.hostage_trade)
	self.hostage_trade_resources.contour_preset = "hostage_trade_resources"
	self.hostage_trade_resources.text_id = "debug_interact_trade_resources"

	self.grenade_crate.timer = 3.5
end)
