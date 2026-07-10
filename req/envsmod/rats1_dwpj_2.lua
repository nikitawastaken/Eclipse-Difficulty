return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_sin_classic",
		"color_sepia",
	},
	environment_override = { -- File override
		["environments/pd2_env_rat_night/pd2_env_rat_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/rats_1_dwpj_2.custom_xml",
	},
}
