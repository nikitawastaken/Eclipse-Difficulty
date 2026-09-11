return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_matrix_classic",
		"color_payday",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = { -- facility_1
		["environments/pd2_env_n2/pd2_env_n2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_facility_1.custom_xml",
	},
}
