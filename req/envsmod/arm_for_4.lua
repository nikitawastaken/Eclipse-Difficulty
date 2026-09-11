return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.15,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xxxgen",
		"color_payday",
	},
	environment_override = { -- orange_evening
		["environments/pd2_env_mountain/pd2_env_mountain"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_forest_orange_evening.custom_xml",
	},
}
