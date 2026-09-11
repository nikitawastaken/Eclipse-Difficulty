return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.15,
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_xgen",
		"color_payday",
		"color_nice",
	},
	environment_override = { -- File override
		["environments/pd2_lxa_river/pd2_lxa_river"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/aftershock_1.custom_xml",
	},
}
