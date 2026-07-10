return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_bhd_classic",
		"color_payday_classic",
		"color_plus",
		"color_force",
	},
	environment_override = { -- orange_evening
		["environments/pd2_env_mountain/pd2_env_mountain"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_forest_orange_evening.custom_xml",
	},
}
