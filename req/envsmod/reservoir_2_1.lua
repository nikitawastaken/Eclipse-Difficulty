return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xxxgen",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["units/pd2_dlc_rvd/environments/pd2_env_rvd/pd2_env_rvd_day2_exterior"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/rvd2_1.custom_xml",
		["units/pd2_dlc_rvd/environments/pd2_env_rvd/pd2_env_rvd_day2_inside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/rvd2_1.custom_xml",
	},
}