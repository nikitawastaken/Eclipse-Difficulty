return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_matrix_classic",
		"color_xxxgen",
		"color_payday",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_plus",
		"color_force",
	},
	environment_override = { -- File override
		["units/pd2_dlc_dah/environments/pd2_dah_outdoor/pd2_dah_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/diamond_heist_fix2.custom_xml",
	}
}