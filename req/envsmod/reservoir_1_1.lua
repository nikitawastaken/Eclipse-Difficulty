return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_payday_classic",
		"color_nice_classic",
		"color_xgen",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["units/pd2_dlc_rvd/environments/pd2_env_rvd/pd2_env_rvd_day1_exterior"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/rvd1_orange.custom_xml",
		["units/pd2_dlc_rvd/environments/pd2_env_rvd/pd2_env_rvd_day1_inside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/rvd1_orange.custom_xml",
	},
}
