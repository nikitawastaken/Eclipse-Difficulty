return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_matrix_classic",
	},
	environment_override = { -- File override
		["environments/pd2_red/pd2_red"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/first_world_bank_dwpj_matrix.custom_xml",
		["environments/pd2_red_indoor/pd2_red_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/first_world_bank_dwpj_matrix.custom_xml",
	},
}
