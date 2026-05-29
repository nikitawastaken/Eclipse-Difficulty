return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_nice_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_framing_frame_stage_2/pd2_env_framing_frame_stage_2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/safehouse_greed_xxxgen.custom_xml",
	}
}