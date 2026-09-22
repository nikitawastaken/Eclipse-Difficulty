return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_bhd_classic",
		"color_matrix_classic",
		"color_payday_classic",
		"color_nice_classic",
	},
	environment_override = { -- day
		["environments/pd2_env_auc/pd2_env_auc_ext"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/auc_05.custom_xml",
		["environments/pd2_env_auc/pd2_env_auc_int"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/auc_05.custom_xml",
	},
}
