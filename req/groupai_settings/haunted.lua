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
			value = { "spawn_kill_max_dis" },
			tweak = {
				mode = "subtract",
				modifier = 500,
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
				amount = 0.25,
				delay = 0,
				time = 60,
			},
			{
				amount = 0.75,
				delay = 15,
				time = { 480, 600 },
			},
		},
		addends = {
			on_enemy_weapons_hot = {
				amount = 0,
				delay = 0, -- Reduce the preset's delay
				time = 0,
			},
		},
		allowed_addends = {
			on_enemy_weapons_hot = false,
			on_entered_regroup = false,
			on_entered_sustain = false,
		},
	},
}
