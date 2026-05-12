return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",		
		"color_matrix_classic",		
	},
	environment_override = { -- File override
		["environments/pd2_hlm1/pd2_hlm1"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/hotlinemiami_1_blueevening.custom_xml",
	}
}