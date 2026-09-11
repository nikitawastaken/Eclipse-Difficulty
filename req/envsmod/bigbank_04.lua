return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.15,
	color_grading = { -- Randomized color gradings
		"color_heat_classic",
		"color_payday_classic",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_env_bigbank/pd2_env_bigbank"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_bank_dark.custom_xml",
	},
}
