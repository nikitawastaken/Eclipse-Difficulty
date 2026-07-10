return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_payday",
		"color_e3nice",
		"color_force",
		"color_plus",
		"color_payday_classic",
		"color_nice_classic",
		"color_heat_classic",
		"color_bhd_classic",
	},
	environment_override = { -- sunny
		["environments/pd2_env_n2/pd2_env_n2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_facility_sunny.custom_xml",
	},
}
