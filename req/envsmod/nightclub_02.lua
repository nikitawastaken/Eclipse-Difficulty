return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_heat",
		"color_nice",
		"color_bhd",
		"color_xxxgen",
		"color_payday",		
		"color_heat_classic",
		"color_payday_classic",
		"color_xxxgen_classic",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/nightclub_2.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/payday2/environment/club_smoke_machine"] = {
			{
				position = Vector3(2779, -5599, 78),
				rotation = Rotation(88, -17, 0)
			},
			{
				position = Vector3(2779, -5599, 78),
				rotation = Rotation(47, -17, 0)
			},
			{
				position = Vector3(2779, -5599, 78),
				rotation = Rotation(137, -17, 0)
			}
		}
	},
}