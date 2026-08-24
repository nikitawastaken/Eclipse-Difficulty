return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_xxxgen",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_fork_01/pd2_env_fork_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dark_cloudy_outside.custom_xml",
		["environments/pd2_berry_underground/pd2_berry_underground"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dark_cloudy_inside.custom_xml",
	},
}
