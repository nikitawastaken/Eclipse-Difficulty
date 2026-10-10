return {
	saturation_value = -0.1,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_nice_classic",
	},
	environment_override = { -- File override
		["units/pd2_dlc_des/environments/des_indoor/des_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/des_indoor.custom_xml",
		["units/pd2_dlc_des/environments/des_indoor_02/des_indoor_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/des_indoor_02.custom_xml",
		["units/pd2_dlc_des/environments/des_outdoor/des_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/des_outdoor.custom_xml",
	},
}
