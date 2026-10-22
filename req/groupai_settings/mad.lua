return {
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 1 / 3,
				delay = 30, -- Reduce the preset's delay
				time = 60,
			},
		},
		allowed_addends = {
			on_entered_regroup = false,
		},
	},
}
