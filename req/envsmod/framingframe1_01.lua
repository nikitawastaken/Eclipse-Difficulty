return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_sunsetstrip",
		"color_payday"
	},
	environment_override = { -- File override
		["environments/pd2_env_framing_frame_stage_2/pd2_env_framing_frame_stage_2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/framing_frame_1_1.custom_xml",
	}
}