return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_payday",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_mex_environments/pd2_env_mex_sunset"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/mexico_outdoors.custom_xml",
	},
}
