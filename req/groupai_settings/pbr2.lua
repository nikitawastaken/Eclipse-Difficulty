return {
	special_limit_mod = {
		{
			value = { "special_unit_spawn_limits", "marksman" },
			tweak = { 
				mode = "subtract",
				modifier = 1,
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.375,
				delay = 60,
				time = 60,
			},
		},
		allowed_addends = {
			on_entered_regroup = false,
		},
	},
}