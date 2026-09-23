return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.15,
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_xgen",
		"color_payday",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_lxa_river/pd2_lxa_river"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/aftershock_2.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/birds"] = {
			{
				position = Vector3(-4482, -8306, 1833),
				rotation = Rotation(-36, 2, -5),
			},
			{
				position = Vector3(-3475, -1900, 2064),
				rotation = Rotation(-55, 8, -10),
			},
			{
				position = Vector3(8725, 13600, 2738),
				rotation = Rotation(-129, 7, -5),
			},
		},
	},
}
