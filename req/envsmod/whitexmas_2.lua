return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_xxxgen",
		"color_xgen",
		"color_bhd",
		"color_payday_classic",
	},
	environment_override = {
		["environments/pd2_env_pines/pd2_env_pines"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/whitexmas_orangeevening.custom_xml",
	},
}
