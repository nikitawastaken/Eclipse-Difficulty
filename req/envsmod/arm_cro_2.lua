return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.40,
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice",
		"color_xgen",
		"color_xxxgen",
	},
	environment_override = {
		["environments/pd2_env_sunset/pd2_env_sunset"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_cro_2.custom_xml",
	},
}
