return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/firestarter2_2.custom_xml",
	}
}