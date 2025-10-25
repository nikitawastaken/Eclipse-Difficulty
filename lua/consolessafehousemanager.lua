Hooks:PostHook(ConsolesSafehouseManager, "init", "eclipse_init", function(self)
	self.rewards_experience_ratio = self.rewards_experience_ratio * 0.25
end)