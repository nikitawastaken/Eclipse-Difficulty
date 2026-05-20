return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
	},
	environment_override = { -- orange_evening
		["environments/pd2_env_mountain/pd2_env_mountain"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_forest_orange_evening.custom_xml",
	}
}