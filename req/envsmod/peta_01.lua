return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_nice",
		"color_xxxgen",
		"color_payday",
		"color_bhd_classic",
		"color_heat_classic",
		"color_nice_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_peta1_outside/env_peta1_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/petah.custom_xml",
		["environments/pd2_peta1_smoke/pd2_peta1_smoke"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/petah_horse.custom_xml",
	},
}
