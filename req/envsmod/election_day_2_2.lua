return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_nice_classic",
		"color_matrix_classic",
		"color_bhd",
		"color_heat",
		"color_xgen",
		"color_xxxgen",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_ed2/pd2_env_ed2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/election_day_1_blue.custom_xml",
	},
}
