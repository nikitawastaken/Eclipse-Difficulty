return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.24,
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
		"color_payday_classic",
		"color_matrix_classic",
		"color_xxxgen",
		"color_xgen",
		"color_bhd",
	},
	environment_override = { -- File override
		["environments/pd2_chca_night/int/pd2_chca_int_default"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/chca_1.custom_xml",
		["environments/pd2_chca_night/ext/pd2_chca_ext"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/chca_1_ext.custom_xml",
		["environments/pd2_chca_night/int/pd2_chca_int_casino"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/chca_1.custom_xml",
		["environments/pd2_chca_night/int/pd2_chca_int_crewdeck"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/chca_1.custom_xml",
		["environments/pd2_chca_night/int/pd2_chca_int_default"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/chca_1.custom_xml",
		["environments/pd2_chca_night/int/pd2_chca_int_spa"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/chca_1.custom_xml",
		["environments/pd2_chca_night/ext/pd2_chca_ext_courtyard"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/chca_1.custom_xml",
	},
}