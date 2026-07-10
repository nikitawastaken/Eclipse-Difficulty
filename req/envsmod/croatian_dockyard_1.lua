return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice_classic",
		"color_payday_classic",
		"color_xgen_classic",
		"color_xxxgen_classic",
		"color_plus",
		"color_e3nice",
		"color_force",
	},
	environment_override = { -- sunny
		["environments/pd2_env_sunset/pd2_env_sunset"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_sunny.custom_xml",
		["environments/pd2_env_jew_street/pd2_env_jew_street"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_sunny.custom_xml",
		["environments/pd2_env_hox1_02/pd2_env_hox1_02"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dockyard_sunny.custom_xml",
	},
}
