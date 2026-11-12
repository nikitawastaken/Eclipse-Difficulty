return {
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_bhd_classic",
		"color_heat_classic",
		"color_nice_classic",
		"color_payday_classic",
		"color_plus",
		"color_force_plus",
	},
	environment_override = {
		["environments/pd2_wwh/pd2_wwh"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/wwh_sun.custom_xml",
		["environments/pd2_wwh/pd2_wwh_train"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/wwh_sun_indoor.custom_xml",
	},
}
