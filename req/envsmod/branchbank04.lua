return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.15,
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_nice_classic",
		"color_bhd_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/branchbank_betalike.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/birds"] = {
			{
				position = Vector3(-4468, -3465, 2556),
				rotation = Rotation(8, 8, -0),
			},
		},
	},
}
