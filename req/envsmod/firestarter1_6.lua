return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_payday_classic",
		"color_matrix_classic",
		"color_xgen_classic",
		"color_force",
		"color_e3_nice",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/firestarter1_6.custom_xml",
	},
}
