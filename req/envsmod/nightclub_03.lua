return {
	flashlights_on = true, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_matrix_classic",
		"color_xxxgen",
		"color_xgen",
		"color_bhd",
		"color_nice",
		"color_payday",
		"color_matrix",
	},
	environment_override = { -- File override
		["environments/pd2_env_night/pd2_env_night"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/nightclub_3.custom_xml",
	},
	particles = { -- Fog effects and such
		["effects/payday2/environment/club_smoke_machine"] = {
			{
				position = Vector3(2779, -5599, 78),
				rotation = Rotation(88, -17, 0) --0, 0, -0,707107
			},
			{
				position = Vector3(2779, -5599, 78),
				rotation = Rotation(47, -17, 0) --0, 0, -0,707107
			},
			{
				position = Vector3(2779, -5599, 78),
				rotation = Rotation(137, -17, 0) --0, 0, -0,707107
			}
		}
	},
}