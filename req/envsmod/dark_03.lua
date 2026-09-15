return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_xxxgen",
		"color_matrix_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_fork_01/pd2_env_fork_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dark_blue_outside.custom_xml",
		["environments/pd2_berry_underground/pd2_berry_underground"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dark_blue_outside.custom_xml",
	},
}
