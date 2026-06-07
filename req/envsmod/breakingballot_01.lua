return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
		"color_payday_classic",
		"color_matrix_classic",
		"color_xgen",
		"color_nice",
		"color_heat",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/breakingballot_01.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/godrays/cheap_godray_ballot"] = {
			{
				position = Vector3(-878, 1981, 627),
				rotation = Rotation(-30, 0, 50)
			},
			{
				position = Vector3(-578, 1981, 627),
				rotation = Rotation(-30, 0, 50)
			},
			{
				position = Vector3(-275, 1981, 627),
				rotation = Rotation(-30, 0, 50)
			},
			{
				position = Vector3(27, 1981, 627),
				rotation = Rotation(-30, 0, 50)
			}
		}
	},
}