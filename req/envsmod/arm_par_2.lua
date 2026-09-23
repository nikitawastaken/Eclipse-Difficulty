return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_midday/pd2_env_midday"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_par_2.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/birds"] = {
			{
				position = Vector3(-4435, -5457, 3223),
				rotation = Rotation(-4, 6, -7),
			},
			{
				position = Vector3(6828, -637, 3085),
				rotation = Rotation(121, 5, -5),
			},
		},
	},
}
