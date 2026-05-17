return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd",
		"color_heat",
		"color_xxxgen",
		"color_payday",		
	},
	environment_override = { -- supercloudy
		["environments/pd2_env_sunset/pd2_env_sunset"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_supercloudy_outdoors.custom_xml",
		["environments/pd2_env_jew_street/pd2_env_jew_street"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_supercloudy_indoors.custom_xml",
		["environments/pd2_env_hox1_02/pd2_env_hox1_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_supercloudy_indoors.custom_xml",
	}
}