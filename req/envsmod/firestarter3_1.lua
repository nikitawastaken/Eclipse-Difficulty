return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_xgen_classic",
		"color_plus",
		"color_e3nice",
		"color_force",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/firestarter3_1.custom_xml",
	},
}
