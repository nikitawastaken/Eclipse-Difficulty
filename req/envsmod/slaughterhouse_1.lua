return {
	color_grading = { -- Randomized color gradings
		"color_nice",
		"color_bhd",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_nice_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- this heist is an absolute fucking mess
		["environments/pd2_dinner_room/pd2_dinner_room"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughter_1_main_ext.custom_xml",
		["environments/pd2_dinner_outdoor/pd2_dinner_outdoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughter_1_main_ext.custom_xml",
		["environments/pd2_dinner_outdoor_middle/pd2_dinner_outdoor_middle"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughter_1_main_ext_nosun.custom_xml",
		["environments/pd2_dinner_office/pd2_dinner_office"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughter_1_office_int.custom_xml",
		["environments/pd2_dinner_slaughterhouse/pd2_dinner_slaughterhouse"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughter_1_main_int.custom_xml",
		["environments/pd2_dinner_outdoor_ending/pd2_dinner_outdoor_ending"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/slaughter_1_main_ext.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
		["effects/envsmod/godrays/cheap_godray_swine_a"] = {
			{
				position = Vector3(-6918, 5948, 771),
				rotation = Rotation(75, -43, 0),
			},
			{
				position = Vector3(-6918, 6380, 771),
				rotation = Rotation(75, -43, 0),
			},
			{
				position = Vector3(-6918, 6889, 771),
				rotation = Rotation(75, -43, 0),
			},
			{
				position = Vector3(-6918, 7447, 771),
				rotation = Rotation(75, -43, 0),
			},
			{
				position = Vector3(-6918, 7921, 771),
				rotation = Rotation(75, -43, 0),
			},
			{
				position = Vector3(-6918, 8596, 771),
				rotation = Rotation(75, -43, 0),
			},
		},
		["effects/envsmod/godrays/cheap_godray_swine_b"] = {
			{
				position = Vector3(-6918, 6168, 771),
				rotation = Rotation(75, -43, 0),
			},
			{
				position = Vector3(-6918, 6648, 771),
				rotation = Rotation(75, -43, 0),
			},
			{
				position = Vector3(-6918, 7154, 771),
				rotation = Rotation(75, -43, 0),
			},
			{
				position = Vector3(-6918, 7682, 771),
				rotation = Rotation(75, -43, 0),
			},
			{
				position = Vector3(-6918, 8227, 771),
				rotation = Rotation(75, -43, 0),
			},
			{
				position = Vector3(-6918, 8853, 771),
				rotation = Rotation(75, -43, 0),
			},
		},
		["effects/envsmod/birds"] = {
			{
				position = Vector3(1100, -950, 2608),
				rotation = Rotation(55, 45, -47),
			},
			{
				position = Vector3(-13425, 11425, 1951),
				rotation = Rotation(-92, 0, -16),
			},
			{
				position = Vector3(-23000, -150, 277),
				rotation = Rotation(-92, 0, -16),
			},
		},
	},
}
