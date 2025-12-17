Hooks:PostHook(AttentionTweakData, "_init_team_AI", "eclipse_init_team_AI", function(self)
	self.settings.team_enemy_cbt.weight_mul = 0.75
	self.settings.minion_team_enemy_cbt = deep_clone(self.settings.team_enemy_cbt)
	self.settings.minion_team_enemy_cbt.weight_mul = 0.5
end)
