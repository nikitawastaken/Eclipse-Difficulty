return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_payday",
		"color_bhd_classic",
		"color_payday_classic",
		"color_nice_classic",
	},
	environment_override = { -- File override
		["environments/pd2_friend/pd2_friend"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/scarface_water_2.custom_xml",
	},
}
