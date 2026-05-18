return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_xgen",
		"color_matrix",
		"color_payday",		
	},
	environment_override = { -- File override
		["environments/pd2_env_framing_frame_stage_2/pd2_env_framing_frame_stage_2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/framing_frame_1_2.custom_xml",
	}
}