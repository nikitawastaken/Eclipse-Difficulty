return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday_classic",
		"color_nice_classic",
		"color_bhd_classic",
		"color_xxxgen",
		"color_xgen",
		"color_payday",
	},
	environment_override = { -- File override
		["environments/pd2_env_morning_02/pd2_env_morning_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_oil_1_mexico.custom_xml",
	},
}
