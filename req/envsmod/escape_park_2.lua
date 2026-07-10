return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_heat_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/escape_park_2.custom_xml",
	},
}
