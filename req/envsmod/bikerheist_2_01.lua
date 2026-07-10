return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_payday",
		"color_nice_classic",
		"color_payday_classic",
		"color_plus",
		"color_force",
		"color_e3nice",
	},
	environment_override = { -- File override
		["environments/pd2_env_chew_2/pd2_env_chew_2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_sunny_train.custom_xml",
	},
}
