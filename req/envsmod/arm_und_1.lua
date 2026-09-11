return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_payday",
		"color_bhd",
		"color_bhd_classic",
		"color_heat_classic",
		"color_nice_classic",
		"color_payday_classic",
	},
	environment_override = {
		["environments/pd2_env_foggy_bright/pd2_env_foggy_bright"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_und1.custom_xml",
	},
}
