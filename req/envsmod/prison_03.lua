return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_bhd",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_help/pd2_env_help_main"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/cathedral_prison.custom_xml",
	},
}
