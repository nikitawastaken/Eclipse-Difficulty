return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_payday",		
	},
	environment_override = { -- File override
		["environments/pd2_run/run_inside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_1.custom_xml",
		["environments/pd2_run/run_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_1.custom_xml",
	}
}