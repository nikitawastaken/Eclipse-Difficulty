return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_force_plus",
	},
	environment_override = { -- File override
		["environments/pd2_env_framing_frame_stage_3/pd2_env_framing_frame_stage_3"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/framing_frame3_daytime_force_plus.custom_xml",
	},
}
