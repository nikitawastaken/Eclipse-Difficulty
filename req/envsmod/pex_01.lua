return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_pex/ext/pd2_env_ext_pex"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/pex_ext.custom_xml",
		["environments/pd2_env_pex/garage/pd2_env_garage_pex"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/pex_int_garage.custom_xml",
		["environments/pd2_env_pex/int/pd2_env_int_pex"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/pex_int.custom_xml",
	},
}
