return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_payday",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_matrix",
		"color_matrix_classic",
	},
	environment_override = {
		["environments/pd2_env_foggy_bright/pd2_env_foggy_bright"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_und1.custom_xml",
	}
}