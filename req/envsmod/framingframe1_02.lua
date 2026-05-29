return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_xgen",
		"color_payday",
		"color_bhd_classic",
		"color_payday_classic",
		"color_xgen_classic",
		"color_xxxgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_framing_frame_stage_2/pd2_env_framing_frame_stage_2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/framing_frame_1_2.custom_xml",
	}
}