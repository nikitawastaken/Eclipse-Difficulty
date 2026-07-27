local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
return {
	task_data_mod = {
		{
			groupai_state = "none", 
			value = { "use_equipment_reenforce" },
			tweak = { 
				mode = "replace", 
				modifier = false,
			},
		},
		{
			groupai_state = "all", 
			value = { "assault", "sustain_duration_min" },
			tweak = { 
				mode = "replace", 
				modifier = get_difficulty_specific_value({
					{ 30, 60, 120 },
					{ 30, 60, 120 },
					{ 45, 80, 140 },
					{ 60, 100, 160 },
					{ 75, 120, 180 },
				}),
			},
		},
		{
			groupai_state = "all", 
			value = { "assault", "sustain_duration_max" },
			tweak = { 
				mode = "replace", 
				modifier = get_difficulty_specific_value({
					{ 30, 60, 120 },
					{ 30, 60, 120 },
					{ 45, 80, 140 },
					{ 60, 100, 160 },
					{ 75, 120, 180 },
				}),
			},
		},
		{
			groupai_state = "besiege", 
			value = { "assault", "delay" },
			tweak = { 
				mode = "add", 
				modifier = { 0, 5, 5 },
			},
		},
	},
	special_limit_mod = {
		{
			value = { "special_unit_spawn_limits", "taser" },
			tweak = { 
				mode = "add",
				modifier = 2,
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.375,
				delay = 0, -- Reduce the preset's delay
				time = 30,
			},
		},
		allowed_addends = {
			on_entered_regroup = false,
		},
	},
}