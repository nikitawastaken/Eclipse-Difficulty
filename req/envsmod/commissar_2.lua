return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.24,
	color_grading = { -- Randomized color gradings
		"color_xgen",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_res/pd2_res"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/commissar_2.custom_xml",
	},
}
