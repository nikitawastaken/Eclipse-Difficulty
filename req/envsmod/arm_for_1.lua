return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_xgen",
		"color_payday_classic",
		"color_xxxgen_classic",
		"color_plus",
		"color_force",
	},
	environment_override = { -- forest
		["environments/pd2_env_mountain/pd2_env_mountain"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_forest.custom_xml",
	},
}
