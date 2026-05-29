return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_bhd",
		"color_payday",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_2_2_day.custom_xml",
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_2_2_day.custom_xml",
	}
}