return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_xxxgen",
		"color_matrix_classic",
		"color_payday",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_plus",
		"color_force",
	},
	environment_override = { -- facility_1
		["environments/pd2_env_n2/pd2_env_n2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_facility_1.custom_xml",
	}
}