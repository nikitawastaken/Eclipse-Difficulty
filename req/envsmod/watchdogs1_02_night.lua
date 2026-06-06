return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_1_2_night.custom_xml",
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_1_2_night.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/in_between/fog_very_faint_bright_white"] = {
			{
				position = Vector3(-1869, 321, -19),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-1936, 3661, -19),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-2080, -2027, -19),
				rotation = Rotation(0, 0, -0)
			}
		},
		["effects/envsmod/spotlight"] = {
			{
				position = Vector3(-2321, 277, 79),
				rotation = Rotation(-92, 7, 0)
			}
		},
		["effects/envsmod/spotlight_long"] = {
			{
				position = Vector3(-1723, 5255, 82),
				rotation = Rotation(166, 2, 0)
			},
			{
				position = Vector3(-2375, -3206, 79),
				rotation = Rotation(-19, 0, -0)
			}
		}
	},
}