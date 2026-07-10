return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_bhd_classic",
		"color_payday_classic",
		"color_heat",
		"color_nice",
	},
	environment_override = { -- File override
		["environments/env_csgo_de_bank/env_csgo_de_bank"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/roberts_1.custom_xml",
	},
}
