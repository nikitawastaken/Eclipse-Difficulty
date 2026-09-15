return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_payday",
		"color_payday_classic",
	},
	environment_override = {
		["environments/pd2_env_ed1/pd2_env_ed1"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/forest.custom_xml",
	},
}
