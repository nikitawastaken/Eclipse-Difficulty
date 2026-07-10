return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_bhd",
		"color_xxxgen",
		"color_payday",
		"color_bhd_classic",
		"color_nice_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
		"color_plus",
		"color_force",
	},
	environment_override = { -- File override
		["environments/pd2_flat_indoor/pd2_flat_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/panicroom_2_interior.custom_xml",
		["environments/pd2_flat/pd2_flat"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/panicroom_2_exterior.custom_xml",
	},
}
