return {
	flashlights_on = true, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_glace/glace_outside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/gridge_ext_1.custom_xml",
		["environments/pd2_glace/glace_inside"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/gridge_int_1.custom_xml",
	},
}
