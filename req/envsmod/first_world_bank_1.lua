return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xxxgen",
		"color_matrix_classic",
		"color_payday",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_red/pd2_red"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/first_world_bank_1.custom_xml",
		["environments/pd2_red_indoor/pd2_red_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/first_world_bank_1.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/cheap_godray_fwb"] = {
			{
				position = Vector3(-2851, 979, 1275),
				rotation = Rotation(-30, 0, 50)
			},
			{
				position = Vector3(-2851, 504, 1275),
				rotation = Rotation(-30, 0, 50)
			},
			{
				position = Vector3(-2851, 54, 1275),
				rotation = Rotation(-30, 0, 50)
			},
			{
				position = Vector3(-2851, -395, 1275),
				rotation = Rotation(-30, 0, 50)
			},
			{
				position = Vector3(-2851, -820, 1275),
				rotation = Rotation(-30, 0, 50)
			},
			{
				position = Vector3(-2851, 1925, 1291),
				rotation = Rotation(-30, 0, 50)
			},
			{
				position = Vector3(-2851, 2379, 1275),
				rotation = Rotation(-30, 0, 50)
			},
			{
				position = Vector3(-2851, 2829, 1275),
				rotation = Rotation(-30, 0, 50)
			}
		}
	},
}