return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_payday",
		"color_bhd",
		"color_xxxgen"
	},
	environment_override = { -- File override
		["environments/pd2_env_pex/int/pd2_env_int_pex"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/mexico_indoors.custom_xml",
		["environments/pd2_env_pex/garage/pd2_env_garage_pex"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/mexico_indoors.custom_xml",
		["environments/pd2_env_pex/ext/pd2_env_ext_pex"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/mexico_outdoors.custom_xml",
	}
}