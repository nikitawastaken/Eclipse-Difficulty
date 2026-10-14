return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_heat",
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_kosugi/pd2_kosugi"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/shadow_raid_cloudy.custom_xml",
	},
}
