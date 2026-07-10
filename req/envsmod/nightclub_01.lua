return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_xxxgen",
		"color_payday",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/nightclub_1.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/payday2/environment/club_smoke_machine"] = {
			{
				position = Vector3(2779, -5599, 78),
				rotation = Rotation(88, -17, 0),
			},
			{
				position = Vector3(2779, -5599, 78),
				rotation = Rotation(47, -17, 0),
			},
			{
				position = Vector3(2779, -5599, 78),
				rotation = Rotation(137, -17, 0),
			},
		},
		["effects/envsmod/night_time/fog_very_faint_white"] = {
			{
				position = Vector3(2435, -3396, 245),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(1124, -3396, 245),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(-198, -3396, 245),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(-1771, -3396, 245),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(-2860, -3396, 245),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(3488, -3396, 245),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(4362, -4520, 245),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(4362, -6008, 245),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(4362, -7212, 245),
				rotation = Rotation(0, 0, 0),
			},
		},
	},
}
