return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_bhd_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
		"color_force",
	},
	environment_override = { -- File override
		["environments/pd2_env_chew_2/pd2_env_chew_2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_train_misty.custom_xml",
	}
}