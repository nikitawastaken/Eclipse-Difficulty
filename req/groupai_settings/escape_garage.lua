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
}
