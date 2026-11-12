return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_plus",
		"color_payday_classic",
		"color_e3nice",
		"color_xxxgen",
		"color_nice",
	},
	environment_override = { -- File override
		["environments/pd2_env_rat_night/pd2_env_rat_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/rats_2_3.custom_xml",
	},
}
