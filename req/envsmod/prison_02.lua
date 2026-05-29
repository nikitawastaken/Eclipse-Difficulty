return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_sin",
		"color_cgreyscale"
	},
	environment_override = { -- File override
		["environments/pd2_env_help/pd2_env_help_main"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dogma_prison.custom_xml",
		["environments/pd2_env_help/pd2_env_help_smoke"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/dogma_smoke.custom_xml",
	}
}