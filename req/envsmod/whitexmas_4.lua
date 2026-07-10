return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_bhd",
		"color_xxxgen",
	},
	environment_override = {
		["environments/pd2_env_pines/pd2_env_pines"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/whitexmas_bluenight.custom_xml",
	},
}
