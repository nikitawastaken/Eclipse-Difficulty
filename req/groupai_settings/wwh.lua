local generate_big_lobby_balance_muls = Eclipse.utils.generate_big_lobby_balance_muls
local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
local step_time_mul = get_difficulty_specific_value({ 1.1, 1.1, 1, 0.9, 0.8 })
local step_time_balance_mul = { 1.3, 1.2, 1.1, 1 }

return {
	task_data_mod = {
		{
			groupai_state = "all",
			value = { "assault", "force_balance_mul" },
			tweak = {
				mode = "replace",
				modifier = generate_big_lobby_balance_muls({
					{ 0.4, 1 },
					{ 0.6, 2 },
					{ 0.8, 3 },
					{ 1, 4 },
					{ 1.5, 10 },
					{ 2, 16 },
					{ 3, 22 },
				}, 0.025),
			},
		},
	},
	difficulty_scaling_mod = {
		steps = {
			{
				amount = 0.25,
				delay = 45,
				time = 60,
			},
			{
				amount = 0.25,
				delay = 15,
				time = { 90, 120 },
				time_mul = step_time_mul,
				time_balance_mul = step_time_balance_mul,
			},
			{
				amount = 0.25,
				delay = 30,
				time = { 150, 180 },
				time_mul = step_time_mul,
				time_balance_mul = step_time_balance_mul,
			},
			{
				amount = 0.25,
				delay = 45,
				time = { 240, 300 },
				time_mul = step_time_mul,
				time_balance_mul = step_time_balance_mul,
			},
		},
		addends = {
			on_enemy_weapons_hot = {
				amount = 0,
				delay = 45,
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
