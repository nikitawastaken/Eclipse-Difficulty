return {
	flashlights_on = false, -- Flashlights
	color_grading = { -- Randomized color gradings
		"color_payday",
		"color_nice",
		"color_xgen",
		"color_xxxgen",
		"color_matrix_classic",
		"color_bhd_classic",
		"color_heat_classic",
		"color_payday_classic",
	},
	environment_override = { -- File override
		["environments/pd2_red/pd2_red"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/first_world_bank_1_night.custom_xml",
		["environments/pd2_red_indoor/pd2_red_indoor"] = tostring(Eclipse.mod_path) .. "assets/environments/custom/first_world_bank_1_night.custom_xml",
	},
	effect_spawner = { -- Fog effects and such
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
