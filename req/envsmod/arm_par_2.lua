return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_heat",
		"color_e3nice",
		"color_nice_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_plus",
		"color_force",
	},
	environment_override = { -- File override
		["environments/pd2_env_midday/pd2_env_midday"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_par_2.custom_xml",
	},
}
