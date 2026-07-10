return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_morning_02/pd2_env_morning_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_oil_1_day_2.custom_xml",
	},
}
