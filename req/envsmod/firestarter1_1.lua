return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_bhd",
		"color_xxxgen",
		"color_matrix",
		"color_matrix_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/firestarter1_1.custom_xml",
	}
}