return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_env_bigbank/pd2_env_bigbank"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_bank_1.custom_xml",
	},
}
