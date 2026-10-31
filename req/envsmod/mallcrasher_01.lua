return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/mallcrasher_bhdclassic.custom_xml",
	},
}
