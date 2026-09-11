return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_payday",
		"color_matrix_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_born_indoor_bar/pd2_env_born_indoor_bar"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_sunny_indoor.custom_xml",
		["environments/pd2_env_born_outdoor_darker/pd2_env_born_outdoor_darker"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_sunny_outdoor.custom_xml",
		["environments/pd2_env_born_outdoor/pd2_env_born_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_sunny_outdoor.custom_xml",
	},
}
