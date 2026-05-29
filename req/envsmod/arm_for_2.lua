return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_bhd_classic",
		"color_heat_classic",
		"color_nice_classic",
		"color_payday_classic",
		"color_xgen_classic",
		"color_plus",
		"color_force",
		"color_e3nice",
	},
	environment_override = { -- bright_morning
		["environments/pd2_env_mountain/pd2_env_mountain"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_forest_bright_morning.custom_xml",
	}
}