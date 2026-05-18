return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_bhd",
		"color_matrix_classic",
		"color_xxxgen",
		"color_matrix",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/framing_frame_2_3.custom_xml",
	}
}