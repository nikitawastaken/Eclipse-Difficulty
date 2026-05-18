return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_heat",
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
	},
	environment_override = { -- sunset
		["environments/pd2_env_foggy_bright/pd2_env_foggy_bright"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_und_sunset2.custom_xml",
	}
}