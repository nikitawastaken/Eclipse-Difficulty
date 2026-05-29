return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_heat",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_mad_outdoor/pd2_mad_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/mad_outside.custom_xml",
		["environments/pd2_mad_lab/pd2_mad_lab"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/mad_indoors.custom_xml",
	}
}