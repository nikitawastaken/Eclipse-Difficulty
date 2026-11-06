return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_force_plus",
		"color_payday_classic",
		"color_heat_classic",
		"color_bhd_classic",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_env_villa_vivaldi/pd2_env_villa_vivaldi"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/big_oil_2_night_blue.custom_xml",
	},
}
