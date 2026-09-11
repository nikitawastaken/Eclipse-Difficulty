return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_xxxgen",
		"color_payday_classic",
	},
	environment_override = { -- bright_morning
		["environments/pd2_env_mountain/pd2_env_mountain"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_forest_bright_morning.custom_xml",
	},
}
