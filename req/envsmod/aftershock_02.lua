return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_payday",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_lxa_river/pd2_lxa_river"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/aftershock_2.custom_xml",
	}
}