return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_tequila_sunrise",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_mex_environments/pd2_mex_outdoor_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/border_crossing_mexico.custom_xml",
		["environments/pd2_mex_environments/pd2_env_mex_sunset"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/border_crossing_arizona.custom_xml",
	},
}
