return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_payday_classic",
	},
	environment_override = {
		["environments/suburbia_env/suburbia_env"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_classic.custom_xml",
		["environments/pd2_pal_outdoor/pd2_pal_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/counterfeit_classic.custom_xml",
		["environments/pd2_pal_indoor/pd2_pal_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/cft_classic_inside.custom_xml",
		["environments/pd2_pal_basement/pd2_pal_basement"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/cft_classic_basement.custom_xml",
	},
}
