return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_xxxgen",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_ed1/pd2_env_ed1"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/election_day_1_blue.custom_xml",
	},
}
