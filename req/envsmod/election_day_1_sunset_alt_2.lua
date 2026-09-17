return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_nice_classic",
		"color_payday_classic",
		"color_xgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_ed1/pd2_env_ed1"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/election_day_1_sunset_alt_2.custom_xml",
	},
}
