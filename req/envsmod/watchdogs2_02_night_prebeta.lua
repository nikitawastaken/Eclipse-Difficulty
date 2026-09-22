return {
	flashlights_on = true, -- Flashlights
	saturation_value = -0.2,
	color_grading = { -- Randomized color gradings
		"color_bhd_classic",
		"color_payday_classic",
		"color_heat_classic",
		"color_xxxgen",
		"color_xgen",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/watchdogs_2_night_darkngriddy.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/night_time/fog_very_faint_bright_white"] = {
			{
				position = Vector3(-1993, 109, 36),
				rotation = Rotation(0, 0, -0),
			},
			{
				position = Vector3(-1993, 3972, 36),
				rotation = Rotation(0, 0, -0),
			},
			{
				position = Vector3(-1993, 6040, 36),
				rotation = Rotation(0, 0, -0),
			},
			{
				position = Vector3(-1993, 7748, 36),
				rotation = Rotation(0, 0, -0),
			},
			{
				position = Vector3(-4174, -14, 36),
				rotation = Rotation(0, 0, -0),
			},
			{
				position = Vector3(-6599, -14, 36),
				rotation = Rotation(0, 0, -0),
			},
			{
				position = Vector3(-2073, -2357, 36),
				rotation = Rotation(0, 0, -0),
			},
			{
				position = Vector3(-2073, -4638, 36),
				rotation = Rotation(0, 0, -0),
			},
			{
				position = Vector3(-2073, -6127, 36),
				rotation = Rotation(0, 0, -0),
			},
			{
				position = Vector3(644, -956, 82),
				rotation = Rotation(0, 0, -0),
			},
			{
				position = Vector3(364, 706, 82),
				rotation = Rotation(0, 0, -0),
			},
		},
	},
}
