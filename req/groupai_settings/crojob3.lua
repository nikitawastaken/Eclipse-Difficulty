return {
	task_data_mod = {
		{
			groupai_state = "none",
			value = { "difficulty_scaling", "addend_delay_balance_muls", "on_enemy_weapons_hot" },
			tweak = {
				mode = "replace",
				modifier = { 1.3, 1.2, 1.1, 1 },			
			},
		},
		{
			groupai_state = "all",
			value = { "assault", "delay_balance_mul" },
			tweak = {
				mode = "replace",
				modifier = { 1.5, 1.3, 1.1, 1 },
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
