return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice",
		"color_xxxgen",
		"color_nice_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_morning_02/pd2_env_morning_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_oil_1_warm_evening.custom_xml",
	},
}