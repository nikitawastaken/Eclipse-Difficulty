return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday_classic",
		"color_plus",
		"color_force",
		"color_e3nice",
		"color_matrix_classic",
		"color_xgen",
	},
	environment_override = { -- File override
		["environments/pd2_env_framing_frame_stage_3/pd2_env_framing_frame_stage_3"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/framing_frame3_daytime.custom_xml",
	},
}
