return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_bhd_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_chas/pd2_env_chas_ext"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/chas_blue.custom_xml",
	},
}
