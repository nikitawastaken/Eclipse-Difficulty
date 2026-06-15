return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_payday",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_dinner_room/pd2_dinner_room"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_start_exterior.custom_xml",
		["environments/pd2_dinner_outdoor/pd2_dinner_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_start_exterior.custom_xml",
		["environments/pd2_dinner_outdoor_middle/pd2_dinner_outdoor_middle"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_start_exterior.custom_xml",
		["environments/pd2_dinner_office/pd2_dinner_office"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_middle_interior.custom_xml",
		["environments/pd2_dinner_slaughterhouse/pd2_dinner_slaughterhouse"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_middle_interior.custom_xml",
		["environments/pd2_dinner_outdoor_ending/pd2_dinner_outdoor_ending"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughterhouse_ending_exterior_sunny.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/godrays/cheap_godray_swine_a"] = {
			{
				position = Vector3(-6918, 5948, 771),
				rotation = Rotation(75, -43, 0)
			},
			{
				position = Vector3(-6918, 6380, 771),
				rotation = Rotation(75, -43, 0)
			},
			{
				position = Vector3(-6918, 6889, 771),
				rotation = Rotation(75, -43, 0)
			},
			{
				position = Vector3(-6918, 7447, 771),
				rotation = Rotation(75, -43, 0)
			},
			{
				position = Vector3(-6918, 7921, 771),
				rotation = Rotation(75, -43, 0)
			},
			{
				position = Vector3(-6918, 8596, 771),
				rotation = Rotation(75, -43, 0)
			}
		},
		["effects/envsmod/godrays/cheap_godray_swine_b"] = {
			{
				position = Vector3(-6918, 6168, 771),
				rotation = Rotation(75, -43, 0)
			},
			{
				position = Vector3(-6918, 6648, 771),
				rotation = Rotation(75, -43, 0)
			},
			{
				position = Vector3(-6918, 7154, 771),
				rotation = Rotation(75, -43, 0)
			},
			{
				position = Vector3(-6918, 7682, 771),
				rotation = Rotation(75, -43, 0)
			},
			{
				position = Vector3(-6918, 8227, 771),
				rotation = Rotation(75, -43, 0)
			},
			{
				position = Vector3(-6918, 8853, 771),
				rotation = Rotation(75, -43, 0)
			}
		}
	}
}