return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.15,
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice",
		"color_nice_classic",
		"color_payday_classic",
		"color_bhd_classic",
		"color_xxxgen",
	},
	environment_override = {
		["environments/pd2_env_sunset/pd2_env_sunset"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_cro_1.custom_xml",
	},
}
