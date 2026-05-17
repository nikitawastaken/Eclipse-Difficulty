return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_heat",
		"color_payday",
	},
	environment_override = {
		["environments/env_core_inside_01/env_core_inside_01"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/stealingxmas_coldsunrise.custom_xml",
	}
}