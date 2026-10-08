return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.15,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_nice_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_lxa_river/pd2_lxa_river"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/aftershock_1.custom_xml",
	},
}