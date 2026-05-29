return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_res/pd2_res"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/commissar.custom_xml",
	}
}