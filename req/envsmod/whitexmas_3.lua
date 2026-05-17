return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_xxxgen",
		"color_xgen",
		"color_bhd",
	},
	environment_override = {
		["environments/pd2_env_pines/pd2_env_pines"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/whitexmas_pinkevening.custom_xml",
	}
}