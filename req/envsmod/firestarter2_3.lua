return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_bhd",
		"color_xgen",
		"color_heat_classic",
		"color_xxxgen",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/firestarter2_3.custom_xml",
	},
}
