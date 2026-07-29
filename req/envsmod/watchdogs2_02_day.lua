return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_payday",
	},
	environment_override = { -- File override
		["environments/pd2_env_wd2_evening/pd2_env_wd2_evening"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_2_2_day.custom_xml",
	},
}
