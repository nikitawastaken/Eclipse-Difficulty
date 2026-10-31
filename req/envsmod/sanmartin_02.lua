return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_tequila_sunrise",
	},
	environment_override = { -- File override
		["environments/pd2_env_bex/ext/pd2_env_bex_int"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bex_sunny_evening_inside.custom_xml",
		["environments/pd2_env_bex/int/pd2_env_bex_ext"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/bex_sunny_evening_outside.custom_xml",
	},
}
