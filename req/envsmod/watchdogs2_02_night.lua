return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_heat_classic",
		"color_payday_classic",
		"color_bhd_classic",
		"color_xxxgen",
		"color_nice_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_2_2_night.custom_xml",
	},
}
