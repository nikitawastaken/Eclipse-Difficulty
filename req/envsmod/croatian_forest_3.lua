return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_xxxgen",
		"color_nice_classic",
	},
	environment_override = {
		["environments/pd2_env_ed1/pd2_env_ed1"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/forest_dusk.custom_xml",
	},
}
