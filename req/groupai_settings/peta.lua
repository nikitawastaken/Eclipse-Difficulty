return {
	task_data_mod = {
		{
			groupai_state = "all",
			value = { "assault", "delay_balance_mul" },
			tweak = {
				mode = "replace",
				modifier = { 1.6, 1.4, 1.2, 1 },
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
