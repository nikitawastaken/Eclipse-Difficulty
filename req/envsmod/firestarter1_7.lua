return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_bhd",
		"color_heat_classic",
		"color_payday_classic",
		"color_force",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/firestarter1_7.custom_xml",
	},
}
