return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen"
	},
	environment_override = { -- File override
		["environments/env_nail/env_nail"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/lab_rats_xxxgen.custom_xml",
	}
}