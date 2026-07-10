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
		["effects/envsmod/godrays/cheap_godray_fwb"] = {
			{
				position = Vector3(-2851, 979, 1275),
				rotation = Rotation(-30, 0, 50),
			},
			{
				position = Vector3(-2851, 504, 1275),
				rotation = Rotation(-30, 0, 50),
			},
			{
				position = Vector3(-2851, 54, 1275),
				rotation = Rotation(-30, 0, 50),
			},
			{
				position = Vector3(-2851, -395, 1275),
				rotation = Rotation(-30, 0, 50),
			},
			{
				position = Vector3(-2851, -820, 1275),
				rotation = Rotation(-30, 0, 50),
			},
			{
				position = Vector3(-2851, 1925, 1291),
				rotation = Rotation(-30, 0, 50),
			},
			{
				position = Vector3(-2851, 2379, 1275),
				rotation = Rotation(-30, 0, 50),
			},
			{
				position = Vector3(-2851, 2829, 1275),
				rotation = Rotation(-30, 0, 50),
			},
		},
		["effects/envsmod/godrays/cheap_godray_fwb2"] = {
			{
				position = Vector3(2292, -4381, -15),
				rotation = Rotation(0, -11, 0),
			},
		},
		["effects/envsmod/day_time/fog_very_faint_blue"] = {
			{
				position = Vector3(2145, 1186, -610),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(1334, 2159, -610),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(2145, 7, -610),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(3755, -107, -610),
				rotation = Rotation(0, 0, 0),
			},
		},
		["effects/envsmod/godrays/cheap_godray_lamp"] = {
			{
				position = Vector3(3642, 143, -149),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(2973, 143, -149),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(2975, -462, -149),
				rotation = Rotation(0, 0, 0),
			},
			{
				position = Vector3(4250, -462, -160),
				rotation = Rotation(0, 0, 0),
			},
		},
	},
}
