return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_payday_classic",
		"color_bhd_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_bex/ext/pd2_env_bex_ext"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/sanmartin_01_ext.custom_xml",
		["environments/pd2_env_bex/int/pd2_env_bex_int"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/sanmartin_01_int.custom_xml",
		["environments/pd2_env_bex/int_vault/pd2_env_bex_int_vault"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/sanmartin_01_int_vault.custom_xml",
	},
}
