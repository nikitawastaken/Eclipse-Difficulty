return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.40,
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice",
		"color_xgen",
		"color_payday_classic",
		"color_bhd_classic",
		"color_dinero_classic",
		"color_xxxgen",
	},
	environment_override = {
		["environments/pd2_env_sunset/pd2_env_sunset"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_cro_1_night.custom_xml",
	},
}
