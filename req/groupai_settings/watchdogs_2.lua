return {
	special_limit_mod = {
		{
			value = { "special_unit_spawn_limits", "shield" },
			tweak = { 
				mode = "add",
				modifier = 1,
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.5,
				delay = 15, -- Reduce the preset's delay
				time = 120,
			},
		},
	},
}