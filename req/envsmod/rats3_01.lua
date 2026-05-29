return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_rat_night_stage_3/pd2_env_rat_night_stage_3"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/rats_3_1.custom_xml",
	}
}