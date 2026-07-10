return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_matrix_classic",
		"color_payday",
		"color_xxxgen",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = {
		["environments/suburbia_env/suburbia_env"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit.custom_xml",
		["environments/pd2_pal_outdoor/pd2_pal_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit.custom_xml",
		["environments/pd2_pal_indoor/pd2_pal_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_inside.custom_xml",
		["environments/pd2_pal_basement/pd2_pal_basement"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_basement.custom_xml",
	},
}
