return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.2,
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice",
		"color_xgen",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_lxa_river/pd2_lxa_river"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/aftershock_3.custom_xml",
	},
}
