return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_nice_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_morning_02/pd2_env_morning_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_oil_1_sunset.custom_xml",
	},
}
