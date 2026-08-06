return {
	task_data_mod = {
		{
			groupai_state = "all",
			value = { "assault", "delay_balance_mul" },
			tweak = {
				mode = "replace",
				modifier = { 1.45, 1.3, 1.15, 1 },
			},
		},
		{
			groupai_state = "all",
			value = { "assault", "hostage_hesitation_delay" },
			tweak = {
				mode = "add",
				modifier = 2.5,
			},
		},
	},
}
