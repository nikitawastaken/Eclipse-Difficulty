return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
		"color_payday_classic",
		"color_force",
	},
	environment_override = { -- File override
		["environments/pd2_env_jry/pd2_env_jry"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/birth_of_sky.custom_xml",
		["core/environments/default"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/birth_of_sky_sewers.custom_xml",
	},
}
