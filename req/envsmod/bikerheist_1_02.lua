return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_payday",
		"color_nice_classic",
		"color_payday_classic",
		"color_plus",
		"color_force",
		"color_e3nice",
	},
	environment_override = { -- File override
		["environments/pd2_env_born_indoor_bar/pd2_env_born_indoor_bar"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_mexico.custom_xml",
		["environments/pd2_env_born_outdoor_darker/pd2_env_born_outdoor_darker"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_mexico.custom_xml",
		["environments/pd2_env_born_outdoor/pd2_env_born_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bikerheist_mexico.custom_xml",
	},
}
