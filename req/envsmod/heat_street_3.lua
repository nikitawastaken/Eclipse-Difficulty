return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.25,
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
	},
	environment_override = { -- File override
		["environments/pd2_run/run_inside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_3.custom_xml",
		["environments/pd2_run/run_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_3.custom_xml",
	},
}
