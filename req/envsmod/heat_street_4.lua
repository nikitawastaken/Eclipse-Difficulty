return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_heat_classic",
		"color_nice_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_run/run_inside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_4.custom_xml",
		["environments/pd2_run/run_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_4.custom_xml",
	},
}
