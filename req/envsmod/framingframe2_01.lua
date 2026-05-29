return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_bhd",
		"color_xxxgen",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/framing_frame_2_1.custom_xml",
	}
}