local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
return {
	task_data_mod = {
		{
			groupai_state = "all", 
			value = { "assault", "sustain_duration_min" },
			tweak = { 
				mode = "replace", 
				modifier = get_difficulty_specific_value({
					{ 60, 120, 160 },
					{ 75, 140, 180 },
					{ 90, 160, 200 },
					{ 105, 180, 220 },
					{ 120, 200, 240 },
				}),
			},
		},
		{
			groupai_state = "all", 
			value = { "assault", "sustain_duration_max" },
			tweak = { 
				mode = "replace", 
				modifier = get_difficulty_specific_value({
					{ 60, 120, 160 },
					{ 75, 140, 180 },
					{ 90, 160, 200 },
					{ 105, 180, 220 },
					{ 120, 200, 240 },
				}),
			},
		},
		{
			groupai_state = "none", 
			value = { "cs_grenade_chance_times" },
			tweak = { 
				mode = "add", 
				modifier = 15,
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.25,
				delay = 30, -- Reduce the preset's delay
				time = 60,
			},
		},
	},
}