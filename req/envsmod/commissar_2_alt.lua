return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.24,
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_xxxgen",
		"color_bhd",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_res/pd2_res"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/commissar_2_alt.custom_xml",
	},
}
