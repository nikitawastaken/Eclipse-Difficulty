return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd",
		"color_xxxgen",
		"color_matrix_classic",
		"color_xgen_classic",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["units/pd2_dlc_bph/environments/pd2_bph_env_exterior_fog"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/hells_island_dwpj.custom_xml",
		["units/pd2_dlc_bph/environments/pd2_env_bph_interior"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/hells_island_dwpj.custom_xml",
	},
}
