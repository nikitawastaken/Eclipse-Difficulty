return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_xgen",
		"color_xxxgen",
		"color_payday",
	},
	environment_override = { -- File override
		["environments/pd2_env_hox1_01/pd2_env_hox1_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/hox1_blue_exterior.custom_xml",
		["environments/pd2_env_hox1_02/pd2_env_hox1_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/hox1_blue_garage.custom_xml",
	}
}