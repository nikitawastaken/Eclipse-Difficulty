return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_plus",
		"color_e3nice",
		"color_force",
		"color_payday_classic",
		"color_xxxgen",
		"color_xgen",
		"color_nice",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/escape_overpass_dusk.custom_xml",
	},
}
