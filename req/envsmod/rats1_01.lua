return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_payday",
		"color_bhd_classic",
		"color_heat_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_rat_night/pd2_env_rat_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/rats_1_1.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/night_time/fog_very_faint_bright_white"] = {
			{
				position = Vector3(593, -1342, 1096),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(910, 212, 1225),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(2116, 2035, 1305),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(2527, 3239, 1555),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(1238, 3315, 1523),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(245, 2564, 1633),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(2470, -1367, 1091),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-1766, -4434, 967),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-2084, -430, 1348),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-1292, 253, 1302),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-1046, 1786, 1477),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-2400, 2018, 1594),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(632, 1440, 1302),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-1452, -2133, 1247),
				rotation = Rotation(0, 0, -0)
			}
		}
	},
}