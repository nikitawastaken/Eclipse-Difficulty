return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_nice",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
	},
	environment_override = { -- File override
		["environments/env_csgo_de_bank/env_csgo_de_bank"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/roberts_3.custom_xml",
	},
}
