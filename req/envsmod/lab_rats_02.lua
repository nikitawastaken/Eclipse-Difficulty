return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_heat_classic",
		"color_nice_classic",
	},
	environment_override = { -- File override
		["environments/env_nail/env_nail"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/lab_rats_hell.custom_xml",
	},
}
