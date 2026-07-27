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
			groupai_state = "none", 
			value = { "cs_grenade_chance_times" },
			tweak = { 
				mode = "multiply", 
				modifier = 2,
			},
		},
		{
			groupai_state = "none", 
			value = { "smoke_grenade_lifetime" },
			tweak = { 
				mode = "subtract", 
				modifier = get_difficulty_specific_value({
					1.5,
					1.5,
					3,
					4.5,
					4.5,
				}),
			},
		},
	},
	special_limit_mod = {
		{
			value = { "special_unit_spawn_limits", "shield" },
			tweak = { 
				mode = "subtract",
				modifier = 2,
			},
		},
		{
			value = { "special_unit_spawn_limits", "marksman" },
			tweak = { 
				mode = "subtract",
				modifier = 2,
			},
		},
	},
	tactics_mod = {
		{
			value = { "_tactics", "beat_cop" },
			tweak = { 
				ranged_fire = false,
			},
		},
		{
			value = { "_tactics", "swat_def" },
			tweak = { 
				ranged_fire = false,
			},
		},
		{
			value = { "_tactics", "swat_spt" },
			tweak = { 
				ranged_fire = false,
			},
		},
		{
			value = { "_tactics", "shield_def" },
			tweak = { 
				ranged_fire = false,
			},
		},
		{
			value = { "_tactics", "shield_spt" },
			tweak = { 
				ranged_fire = false,
			},
		},
		{
			value = { "_tactics", "taser_spt" },
			tweak = { 
				ranged_fire = false,
			},
		},
		{
			value = { "_tactics", "bulldozer_spt" },
			tweak = { 
				ranged_fire = false,
			},
		},
		{
			value = { "_tactics", "marksman" },
			tweak = { 
				ranged_fire = false,
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0,
				delay = 30,
				time = 0,
			},
		},
	},
}