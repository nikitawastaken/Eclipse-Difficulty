return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_nice_classic",
		"color_payday_classic",
		"color_payday",
	},
	environment_override = { -- day
		["environments/pd2_env_n2/pd2_env_n2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_facility_day.custom_xml",
	},
}
