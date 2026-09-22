return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = { -- day
		["environments/pd2_env_auc/pd2_env_auc_ext"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/auc_01.custom_xml",
	},
}
