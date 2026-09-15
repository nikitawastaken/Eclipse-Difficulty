return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.4,
	color_grading = { -- Randomized color gradings
		"color_payday",
	},
	environment_override = {
		["environments/pd2_env_ed1/pd2_env_ed1"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/forest_night.custom_xml",
	},
}
