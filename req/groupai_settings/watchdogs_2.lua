local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
return {
	task_data_mod = {
		{
			groupai_state = "all",
			value = { "assault", "delay" }, -- Julespig
			tweak = {
				mode = "replace",
				modifier = get_difficulty_specific_value({
					{ 40, 35, 30 },
					{ 35, 30, 25 },
					{ 30, 25, 20 },
					{ 25, 20, 15 },
					{ 20, 15, 10 },
				}),
			},
		},
	},
	special_limit_mod = {
		{
			value = { "special_unit_spawn_limits", "shield" },
			tweak = {
				mode = "add",
				modifier = 1,
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.5,
				delay = 15, -- Reduce the preset's delay
				time = 120,
			},
		},
	},
}
