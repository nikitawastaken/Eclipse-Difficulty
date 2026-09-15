return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xxxgen",
		"color_matrix_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
		"color_payday",
	},
	environment_override = { -- matrix
		["environments/pd2_env_sunset/pd2_env_sunset"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_docks.custom_xml",
		["environments/pd2_env_jew_street/pd2_env_jew_street"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_docks.custom_xml",
		["environments/pd2_env_hox1_02/pd2_env_hox1_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_docks.custom_xml",
	},
}
