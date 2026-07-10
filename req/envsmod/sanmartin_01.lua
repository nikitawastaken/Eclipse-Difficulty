return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_payday",
		"color_bhd",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_env_bex/ext/pd2_env_bex_ext"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/mexico_outdoors.custom_xml",
		["environments/pd2_env_bex/int/pd2_env_bex_int"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/mexico_indoors.custom_xml",
	},
}
