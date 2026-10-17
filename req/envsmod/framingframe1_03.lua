return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_framing_frame_stage_2/pd2_env_framing_frame_stage_2"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/framing_frame_1_3.custom_xml",
	},
}
