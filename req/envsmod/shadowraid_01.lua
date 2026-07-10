return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_xgen",
		"color_xxxgen",
	},
	environment_override = { -- File override
		["environments/pd2_kosugi/pd2_kosugi"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/shadow_raid_1.custom_xml",
	},
}
