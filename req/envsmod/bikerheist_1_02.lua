return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_payday",
	},
	environment_override = { -- File override
		["environments/pd2_env_born_indoor_bar/pd2_env_born_indoor_bar"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_mexico.custom_xml",
		["environments/pd2_env_born_outdoor_darker/pd2_env_born_outdoor_darker"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_mexico.custom_xml",
		["environments/pd2_env_born_outdoor/pd2_env_born_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_mexico.custom_xml",
	},
}
