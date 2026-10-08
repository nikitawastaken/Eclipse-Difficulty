return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.1,
	color_grading = { -- Randomized color gradings
		"color_heat_classic",
	},
	environment_override = { -- File override
		["environments/pd2_run/run_inside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_2.custom_xml",
		["environments/pd2_run/run_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_2.custom_xml",
	},
}
