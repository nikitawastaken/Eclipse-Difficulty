return {
	flashlights_on = false, -- Flashlights
	saturation_value = 0.24,
	color_grading = { -- Randomized color gradings
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_res/pd2_res"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/commissar_5.custom_xml",
	},
}
