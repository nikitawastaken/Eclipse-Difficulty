return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_bhd_classic",
		"color_heat_classic",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/birds"] = {
			{
				position = Vector3(-2485, -3823, 999),
				rotation = Rotation(-127, 31, -47),
			},
			{
				position = Vector3(3956, -2720, 1177),
				rotation = Rotation(61, 35, -44),
			},
			{
				position = Vector3(-5695, 16350, -534),
				rotation = Rotation(-47, 25, -15),
			},
		},
	},
}
