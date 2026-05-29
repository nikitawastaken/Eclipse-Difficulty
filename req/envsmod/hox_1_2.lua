return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_heat",
		"color_nice_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
		"color_plus",
	},
	environment_override = { -- File override
		["environments/pd2_env_hox1_01/pd2_env_hox1_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/hox1_midday_exterior.custom_xml",
		["environments/pd2_env_hox1_02/pd2_env_hox1_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/hox1_midday_garage.custom_xml",
	}
}