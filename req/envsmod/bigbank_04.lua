return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.15,
	color_grading = { -- Randomized color gradings
		"color_heat_classic",
		"color_payday_classic",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_env_bigbank/pd2_env_bigbank"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_bank_dark.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/birds"] = {
			{
				position = Vector3(7863, 6312, 4069),
				rotation = Rotation(-176, 18, 8),
			},
			{
				position = Vector3(9596, -1926, 4003),
				rotation = Rotation(69, 11, -11),
			},
			{
				position = Vector3(-1052, -13146, 315),
				rotation = Rotation(-24, 23, -17),
			},
		},
	},
}
