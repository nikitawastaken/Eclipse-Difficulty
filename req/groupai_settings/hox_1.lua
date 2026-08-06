local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
local step_time_mul = get_difficulty_specific_value({ 1.1, 1.1, 1, 0.9, 0.8 })
local step_time_balance_mul = { 1.3, 1.2, 1.1, 1 }
return {
	difficulty_scaling_mod = {
		steps = {
			{
				amount = 0.25,
				delay = 15,
				time = 15,
			},
			{
				amount = 0.25,
				delay = 30,
				time = { 60, 90 },
				delay_mul = step_time_mul,
				delay_balance_mul = step_time_balance_mul,
			},
			{
				amount = 0.25,
				delay = 45,
				time = { 150, 180 },
				delay_mul = step_time_mul,
				delay_balance_mul = step_time_balance_mul,
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
			on_entered_regroup = false,
			on_entered_sustain = false,
		},
	},
}
