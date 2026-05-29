return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday_classic",
		"color_xxxgen_classic",
		"color_bhd",
		"color_bhd_classic",
		"color_heat_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/firestarter1_2.custom_xml",
	}
}