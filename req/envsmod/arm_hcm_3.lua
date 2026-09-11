return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_midday/pd2_env_midday"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_hcm_3.custom_xml",
	},
}
