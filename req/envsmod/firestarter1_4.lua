return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_payday",
		"color_payday_classic",
		"color_xxxgen_classic",
		"color_force",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/firestarter1_4.custom_xml",
	}
}