return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_payday_classic",
		"color_payday",
		"color_nice_classic",
		"color_e3nice",
		"color_force",
		"color_plus",
	},
	environment_override = { -- File override
		["environments/pd2_env_bigbank/pd2_env_bigbank"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_bank.custom_xml",
	}
}