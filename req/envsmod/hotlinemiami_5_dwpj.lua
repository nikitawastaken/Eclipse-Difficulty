return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_hlm1/pd2_hlm1"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/hotlinemiami_1_dwpj.custom_xml",
	}
}