return {
	task_data_mod = {
		{
			groupai_state = "none",
			value = { "spawn_kill_cooldown" },
			tweak = {
				mode = "add",
				modifier = 5,
			},
		},
	},
	special_limit_mod = {
		{
			value = { "special_unit_spawn_limits", "shield" },
			tweak = {
				mode = "subtract",
				modifier = 1,
			},
		},
		{
			value = { "special_unit_spawn_limits", "marksman" },
			tweak = {
				mode = "subtract",
				modifier = 1,
			},
		},
	},
}
