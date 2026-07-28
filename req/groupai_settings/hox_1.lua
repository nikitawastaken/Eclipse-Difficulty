return {
	difficulty_scaling_mod = {
		steps = {
			{
				amount = 0.25,
				delay = 15,
				time = 5,
			},
			{
				amount = 0.25,
				delay = 30,
				time = { 150, 180 },
			},
			{
				amount = 0.25,
				delay = 45,
				time = { 180, 210 },
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
