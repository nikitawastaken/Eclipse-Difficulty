return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
		"color_payday_classic",
		"color_xgen",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/breakingballot_02.custom_xml",
	},
}
