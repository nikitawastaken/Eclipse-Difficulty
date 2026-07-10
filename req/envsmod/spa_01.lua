return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_nice_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_spa/pd2_env_spa_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/brooklyn10-10.custom_xml",
		["environments/pd2_env_spa/pd2_env_spa_a"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/brooklyn10-10.custom_xml",
		["environments/pd2_env_spa/pd2_env_spa_basement"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/brooklyn10-10.custom_xml",
	},
}
