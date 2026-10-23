return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_plus",
		"color_force",
		"color_e3nice",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs1_2.custom_xml",
	},
}
