return {
	task_data_mod = {
		{
			groupai_state = "none", 
			value = { "smoke_grenade_timeout" },
			tweak = { 
				mode = "subtract", 
				modifier = { 5, 10 },
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.25,
				delay = 60, -- Increase the preset's delay
				time = 60,
			},
		},
	},
}