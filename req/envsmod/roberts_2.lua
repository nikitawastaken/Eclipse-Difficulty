return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_bhd",
		"color_payday_classic",
		"color_heat",
	},
	environment_override = { -- File override
		["environments/env_csgo_de_bank/env_csgo_de_bank"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/roberts_2.custom_xml",
	},
}
