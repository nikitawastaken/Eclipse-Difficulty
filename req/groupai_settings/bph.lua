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
	difficulty_scaling_mod = {
		steps = {
			{
				amount = 0.2,
				delay = 15,
				time = 5,
			},
			{
				amount = 0.2,
				delay = 150,
				time = 75,
			},
			{
				amount = 0.2,
				delay = 75,
				time = 75,
			},
			{
				amount = 0.2,
				delay = 75,
				time = 75,
			},
			{
				amount = 0.2,
				delay = 75,
				time = 75,
			},
		},
		addends = {
			on_enemy_weapons_hot = {
				amount = 0,
				delay = 15,
				time = 0,
			},
		},
		allowed_addends = {
			on_enemy_weapons_hot = false,
			on_entered_sustain = false,
			on_entered_regroup = false,
		},
	},
}
