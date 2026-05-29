return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_rat_night/pd2_env_rat_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/rats_2_1.custom_xml",
	}
}