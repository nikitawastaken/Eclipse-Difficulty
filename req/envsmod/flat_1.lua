return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_xxxgen",
		"color_xgen",
		"color_payday",
	},
	environment_override = { -- File override
		["environments/pd2_flat_indoor/pd2_flat_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/panicroom_1_interior.custom_xml",
		["environments/pd2_flat/pd2_flat"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/panicroom_1_exterior.custom_xml",
	}
}