return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_plus",
		"color_e3nice",
		"color_payday_classic",
		"color_force_plus",
		"color_xgen",
		"color_nice_classic",
		"color_matrix_classic",
		"color_xxxgen",
		"color_xgen",
		"color_bhd",
		"color_nice",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/firestarter3_2.custom_xml",
	},
}
