return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_matrix_classic",
		"color_heat",
		"color_payday",		
	},
	environment_override = { -- matrix
		["environments/pd2_env_sunset/pd2_env_sunset"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_matrix.custom_xml",
		["environments/pd2_env_jew_street/pd2_env_jew_street"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_matrix.custom_xml",
		["environments/pd2_env_hox1_02/pd2_env_hox1_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_matrix.custom_xml",
	}
}