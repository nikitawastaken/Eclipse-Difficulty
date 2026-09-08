return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_matrix_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_bigbank/pd2_env_bigbank"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_bank_kiwami.custom_xml",
	},
}
