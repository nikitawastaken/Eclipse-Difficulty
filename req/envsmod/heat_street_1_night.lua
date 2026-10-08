return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.15,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_payday",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_run/run_inside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_1_nightheat.custom_xml",
		["environments/pd2_run/run_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/heat_street_1_nightheat.custom_xml",
	},
}
