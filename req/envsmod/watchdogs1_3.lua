return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_plus",
		"color_force",
		"color_e3nice",
		"color_heat_classic",
		"color_xgen_classic",
		"color_xxxgen_classic",
		"color_nice",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_1_3.custom_xml",
	},
}
