return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_heat",
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_nice_classic",
		"color_payday_classic",
		"color_xgen_classic",
		"color_xxxgen_classic",
		"color_plus",
		"color_force",
		"color_e3nice",
	},
	environment_override = { -- sunset
		["environments/pd2_env_foggy_bright/pd2_env_foggy_bright"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_und_sunset2.custom_xml",
	} -- use in_between blue fog here
}