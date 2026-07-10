return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_sin_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_help/pd2_env_help_main"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/sin_prison.custom_xml",
		["environments/pd2_env_help/pd2_env_help_smoke"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/void_prison.custom_xml",
	},
}
