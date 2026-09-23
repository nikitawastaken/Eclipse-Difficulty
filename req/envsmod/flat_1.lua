return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_xgen",
		"color_payday",
		"color_payday_classic",
		"color_matrix_classic",
		"color_nice",
		"color_heat_classic",
	},
	environment_override = { -- File override
		["environments/pd2_flat_indoor/pd2_flat_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/panicroom_1_interior.custom_xml",
		["environments/pd2_flat/pd2_flat"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/panicroom_1_exterior.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/birds"] = {
			{
				position = Vector3(-3943, -3979, 2191),
				rotation = Rotation(-1, 25, -25),
			},
			{
				position = Vector3(7672, -4264, 2272),
				rotation = Rotation(127, 20, -32),
			},
			{
				position = Vector3(-4771, 9878, 2794),
				rotation = Rotation(-71, 12, -5),
			},
		},
	},
}
