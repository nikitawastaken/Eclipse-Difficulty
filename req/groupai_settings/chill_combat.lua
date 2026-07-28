return {
	task_data_mod = {
		{
			groupai_state = "none",
			value = { "cs_grenade_timeout" },
			tweak = {
				mode = "subtract",
				modifier = { 15, 30 },
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 1 / 3,
				delay = 15,
				time = 60,
			},
			on_entered_regroup = {
				amount = 1 / 3,
				delay = 0,
				time = 60,
			},
		},
	},
	tactics_mod = {
		{
			value = { "_tactics", "swat_def" },
			tweak = {
				rescue = true,
			},
		},
		{
			value = { "_tactics", "swat_agg" },
			tweak = {
				rescue = true,
			},
		},
		{
			value = { "_tactics", "swat_snk" },
			tweak = {
				rescue = true,
			},
		},
		{
			value = { "_tactics", "swat_snk_agg" },
			tweak = {
				rescue = true,
			},
		},
	},
}
