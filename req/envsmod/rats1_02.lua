return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_heat",
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic"
	},
	environment_override = { -- File override
		["environments/pd2_env_rat_night/pd2_env_rat_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/rats_1_2.custom_xml",
	}
}