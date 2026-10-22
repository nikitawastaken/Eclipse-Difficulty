return {
	task_data_mod = {
		{
			groupai_state = "none",
			value = { "init_reenforce_delay" },
			tweak = {
				mode = "multiply",
				modifier = 0,
			},
		},
		{
			groupai_state = "all",
			value = { "reenforce", "interval" },
			tweak = {
				mode = "replace",
				modifier = 10,
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 1,
				delay = 15,
				time = { 60, 90 },
			},
		},
	},
}
