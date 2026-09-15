return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_payday_classic",
		"color_bhd_classic",
		"color_xgen",
		"color_nice",
		"color_payday",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/escape_park_day_4.custom_xml",
	},
}
