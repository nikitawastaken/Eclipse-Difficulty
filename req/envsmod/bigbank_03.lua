return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.15,
	color_grading = { -- Randomized color gradings
		"color_xgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_bigbank/pd2_env_bigbank"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_bank_brown.custom_xml",
	},
}
