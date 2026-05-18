return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_matrix_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_midday/pd2_env_midday"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_hcm_1.custom_xml",
	}
}