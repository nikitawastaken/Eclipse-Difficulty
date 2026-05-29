return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_payday",
		"color_xgen",
		"color_xxxgen",
		"color_bhd_classic",
		"color_nice_classic",
		"color_xgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_2_evening.custom_xml",
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_2_evening.custom_xml",
	}
}