return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_lxy_gala_01/pd2_env_lxy_gala_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/yacht_sun_indoors.custom_xml",
		["environments/pd2_env_lxy_lowerdeck_01/pd2_env_lxy_lowerdeck_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/yacht_sun_indoors.custom_xml",
		["environments/pd2_env_lxy_gala_02/pd2_env_lxy_gala_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/yacht_sun_indoors.custom_xml",
		["environments/pd2_env_lxy_stern_01/pd2_env_lxy_stern_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/yacht_sun.custom_xml",
	},
}
