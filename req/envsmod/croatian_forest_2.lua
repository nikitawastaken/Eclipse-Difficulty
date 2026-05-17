return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_xxxgen",
		"color_nice",
		"color_heat",
		"color_payday",
	},
	environment_override = {
		["environments/pd2_env_ed1/pd2_env_ed1"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/forest_evening.custom_xml",
	}
}