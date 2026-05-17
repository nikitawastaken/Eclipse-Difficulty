return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_payday",
	},
	environment_override = {
		["environments/env_core_inside_01/env_core_inside_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/stealingxmas_bluenight.custom_xml",
	}
}