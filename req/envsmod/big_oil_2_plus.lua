return {
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_plus",
		"color_tequila_sunrise",
		"color_force_plus",
		"color_e3nice",
		"color_xgen_classic",
		"color_payday_classic",
		"color_heat_classic",
		"color_matrix_classic",
		"color_nice",
	},
	environment_override = { -- File override
		["environments/pd2_env_villa_vivaldi/pd2_env_villa_vivaldi"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_oil_2_default_plus.custom_xml",
	},
}
