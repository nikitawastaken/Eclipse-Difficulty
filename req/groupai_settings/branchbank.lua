--[[ 
local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
return {
	task_data_mod = {
		{
			groupai_state = "all", -- "none", "street", "safehouse", "besiege", "ponr"
			value = { "assault", "force" },
			tweak = { 
				mode = "replace", -- "replace", "add", "subtract", "multiply"
				modifier = get_difficulty_specific_value({
					{ 2, 8, 14 },
					{ 2, 8, 14 },
					{ 4, 10, 16 },
					{ 67, 67, 67 },
					{ 8, 14, 20 },
				}),
			},
		},
		{
			groupai_state = "besiege", -- "none", "street", "safehouse", "besiege", "ponr"
			value = { "assault", "spawn_rate" },
			tweak = {
				mode = "multiply", -- "add", "subtract", "multiply"
				modifier = 0,
			},
		},
		{
			groupai_state = "besiege", -- "none", "street", "safehouse", "besiege", "ponr"
			value = { "reenforce", "interval" },
			tweak = {
				mode = "multiply", -- "add", "subtract", "multiply"
				modifier = 0,
			},
		},
		{
			groupai_state = "none", -- "none", "street", "safehouse", "besiege", "ponr"
			value = { "cs_grenade_lifetime" },
			tweak = {
				mode = "add", -- "add", "subtract", "multiply"
				modifier = 15,
			},
		},
	},
	special_limit_mod = {
		{
			value = { "special_unit_spawn_limits", "marksman" },
			tweak = { 
				mode = "add",
				modifier = 5,
			},
		},
		{
			value = { "ponr_state_special_limit_add", "medic" },
			tweak = {
				mode = "add",
				modifier = 5,
			},
		},
	},
	tactics_mod = {
		{
			value = { "_tactics", "swat_def" },
			tweak = { 
				rescue = true,
			},
		},
	},
	difficulty_scaling_mod = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.5,
				delay = 60, -- Increase the preset's delay
				time = 120,
			},
		},
	},
}
]]