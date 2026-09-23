return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday_classic",
		"color_nice",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/family_2.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/birds"] = {
			{
				position = Vector3(-7730, 379, 3055),
				rotation = Rotation(-52, 20, -18),
			},
			{
				position = Vector3(-5263, 7576, 2763),
				rotation = Rotation(-85, 23, -23),
			},
			{
				position = Vector3(6179, -6041, 3020),
				rotation = Rotation(68, 20, -13),
			},
		},
	},
}
