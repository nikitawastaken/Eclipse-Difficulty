return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/escape_garage.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/spotlight_long"] = {
			{
				position = Vector3(-685, 1903, 550),
				rotation = Rotation(-90, 6, 0),
			},
		},
		["effects/envsmod/night_time/fog_very_faint_bright_white"] = {
			{
				position = Vector3(46, 1972, 530),
				rotation = Rotation(-92, 7, 0),
			},
			{
				position = Vector3(1102, 2173, 532),
				rotation = Rotation(-92, 7, 0),
			},
		},
		["effects/envsmod/night_time/fog_very_faint_white"] = {
			{
				position = Vector3(220, -376, 450),
				rotation = Rotation(166, 2, 0),
			},
			{
				position = Vector3(1217, -497, 450),
				rotation = Rotation(-19, 0, -0),
			},
			{
				position = Vector3(-1046, 261, 450),
				rotation = Rotation(-19, 0, -0),
			},
		},
	},
}
