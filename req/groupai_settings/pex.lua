local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
return { -- Poison Brew
	task_data_mod = {
		{
			groupai_state = "all", 
			value = { "assault", "sustain_duration_min" },
			tweak = { 
				mode = "replace", 
				modifier = get_difficulty_specific_value({
					{ 75, 120, 150 },
					{ 90, 135, 165 },
					{ 105, 150, 180 },
					{ 120, 165, 195 },
					{ 135, 180, 210 },
				}),
			},
		},
		{
			groupai_state = "all", 
			value = { "assault", "sustain_duration_max" },
			tweak = { 
				mode = "replace", 
				modifier = get_difficulty_specific_value({
					{ 75, 120, 150 },
					{ 90, 135, 165 },
					{ 105, 150, 180 },
					{ 120, 165, 195 },
					{ 135, 180, 210 },
				}),
			},
		},
	},
}