return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_matrix_classic",
		"color_heat_classic",
		"color_nice_classic",
		"color_payday_classic",
		"color_bhd_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_2_night_matrix.custom_xml",
	},
}
