return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_heat",
		"color_payday",	
		"color_heat_classic",
		"color_nice_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_run/run_inside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_3.custom_xml",
		["environments/pd2_run/run_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_3.custom_xml",
	}
}