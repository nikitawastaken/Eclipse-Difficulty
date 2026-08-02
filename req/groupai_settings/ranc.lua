return {
	task_data_mod = {
		{
			groupai_state = "all",
			value = { "assault", "force" },
			tweak = {
				mode = "add",
				modifier = { 4, 2, 0 },
			},
		},
		{
			groupai_state = "all",
			value = { "reenforce", "interval" },
			tweak = {
				mode = "subtract",
				modifier = { 0, 5, 10 },
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.375,
				delay = 45,
				time = 90,
			},
		},
		allowed_addends = {
			on_entered_regroup = false,
		},
	},
}
