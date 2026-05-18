return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
	},
	environment_override = { -- day
		["environments/pd2_env_n2/pd2_env_n2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_facility_day.custom_xml",
	}
}