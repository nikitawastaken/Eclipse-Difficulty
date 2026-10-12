return {
	flashlights_on = false, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
	},
	environment_override = { -- sunset
		["environments/pd2_env_foggy_bright/pd2_env_foggy_bright"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/arm_und_alpha.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/birds"] = {
			{
				position = Vector3(4600, -2025, 1722),
				rotation = Rotation(37, 23, -21),
			},
		},
	},
}
