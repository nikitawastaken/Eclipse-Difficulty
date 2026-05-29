return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_heat",
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_bhd_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
		"color_plus",
		"color_force",
	},
	environment_override = { -- forest_evening
		["environments/pd2_env_mountain/pd2_env_mountain"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_forest_evening.custom_xml",
	}
}