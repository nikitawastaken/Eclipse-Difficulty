return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xxxgen",
		"color_bhd",
		"color_payday",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
		"color_plus",
		"color_force",
	},
	environment_override = { -- File override
		["units/pd2_dlc_brb/environments/pd2_env_brb_interior_bank"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/brb_glow_interior.custom_xml",
		["units/pd2_dlc_brb/environments/pd2_env_brb_exterior_v4"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/brb_glow_exterior.custom_xml",
	}
}