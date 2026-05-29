return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_payday",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_plus",
		"color_force",
		"color_e3nice",
	},
	environment_override = {
		["environments/pd2_env_sunset/pd2_env_sunset"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_cro_2.custom_xml",
	}
}