return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xxxgen",
		"color_matrix_classic",
		"color_payday",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_red/pd2_red"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/first_world_bank_1.custom_xml",
		["environments/pd2_red_indoor/pd2_red_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/first_world_bank_1.custom_xml",
	}
}