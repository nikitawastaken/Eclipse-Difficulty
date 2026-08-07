local generate_big_lobby_balance_muls = Eclipse.utils.generate_big_lobby_balance_muls
local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
local step_time_balance_mul = { 1.3, 1.15, 1, 0.85 }
return {
	task_data_mod = {
		{
			groupai_state = "all",
			value = { "assault", "force" },
			tweak = {
				mode = "subtract",
				modifier = { 0, 1, 2 },
			},
		},
		{
			groupai_state = "all",
			value = { "assault", "force_balance_mul" },
			tweak = {
				mode = "replace",
				modifier = generate_big_lobby_balance_muls({
					{ 0.55, 1 },
					{ 0.7, 2 },
					{ 0.85, 3 },
					{ 1, 4 },
					{ 1.25, 10 },
					{ 1.5, 16 },
					{ 2, 22 },
				}, 0.025),
			},
		},
		{
			groupai_state = "none",
			value = { "use_deployable_reenforce" },
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
		steps = {
			{
				amount = 0.25,
				delay = 15,
				time = 30,
			},
			{
				amount = 0.25,
				delay = 5,
				time = { 30, 45 },
				time_balance_mul = step_time_balance_mul,
			},
			{
				amount = 0.25,
				delay = 5,
				time = { 45, 60 },
				time_balance_mul = step_time_balance_mul,
			},
			{
				amount = 0.25,
				delay = 5,
				time = { 60, 75 },
				time_balance_mul = step_time_balance_mul,
			},
		},
		addends = {
			on_enemy_weapons_hot = {
				amount = 0,
				delay = 15, -- Decrease the preset's delay
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
