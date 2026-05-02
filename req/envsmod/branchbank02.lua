return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_payday_classic",
		"color_payday",		
	},
	environment_override = { -- File override
		["environments/pd2_env_mid_day/pd2_env_mid_day"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/branchbank02.custom_xml",
	},
	particles = { -- Fog effects and such
		["effects/environment_smoke_blue_env"] = {
			{
				position = Vector3(-7203, -6372, 87),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-10365, -800, 87),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(4199, -799, 87),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(799, 6154, 89),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(5422, 3657, 77),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-997, -6281, 81),
				rotation = Rotation(0, 0, -0)
			},
			{
				position = Vector3(-3763, -5730, 118),
				rotation = Rotation(0, 0, -0)
			},

		}
	},
}