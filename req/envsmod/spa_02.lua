return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_payday_classic",
		"color_xgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_spa/pd2_env_spa_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/brooklyn10-10_evening.custom_xml",
		["environments/pd2_env_spa/pd2_env_spa_a"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/brooklyn10-10_evening.custom_xml",
		["environments/pd2_env_spa/pd2_env_spa_basement"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/brooklyn10-10_evening.custom_xml",
	},
}
