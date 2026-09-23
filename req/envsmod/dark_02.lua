return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_xxxgen",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_fork_01/pd2_env_fork_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dark_cloudy_outside.custom_xml",
		["environments/pd2_berry_underground/pd2_berry_underground"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dark_cloudy_inside.custom_xml",
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
