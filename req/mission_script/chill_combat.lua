local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local money_pile_reinforce01 = {
	reinforce = {
		{
			name = "garage",
			force = 2,
			position = Vector3(300, 1200, 0),
		},
		{
			name = "armory",
			force = 2,
			position = Vector3(900, -1100, 0),
		},
		{
			name = "staircase",
			force = 2,
			position = Vector3(2050, -600, 200),
		},
	},
}
local money_pile_reinforce02 = {
	reinforce = {
		{
			name = "upstairs01",
			force = 2,
			position = Vector3(1000, 400, 400),
		},
		{
			name = "upstairs02",
			force = 2,
			position = Vector3(500, -550, 400),
		},
		{
			name = "kitchen",
			force = 2,
			position = Vector3(400, 1350, 400),
		},
	},
}
local street_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local bush_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local roof_vertical_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_horizontal_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local no_align_pos = {
	values = {
		align_position = false,
	},
}

return {
	-- Add new reinforce
	[100979] = {
		reinforce = {
			{
				name = "touch_grass01",
				force = 2,
				position = Vector3(-1500, 800, 300),
			},
			{
				name = "touch_grass02",
				force = 2,
				position = Vector3(-500, 2150, 300),
			},
		},
	},
	-- Upstairs money piles
	[101362] = money_pile_reinforce01,
	[101363] = money_pile_reinforce01,
	[101364] = money_pile_reinforce01,
	-- Downstairs money piles
	[101349] = money_pile_reinforce02,
	[101367] = money_pile_reinforce02,
	-- Disable vanilla reinforce
	[101646] = disabled,
	[102590] = disabled,
	-- Add spawn groups gradually instead of all in one preferred
	[100982] = { -- preferred
		on_executed = {
			{ id = 400000, delay = 0, delay_rand = 0 },
			{ id = 100987, remove = true }, -- ai_enemy_prefered_add_001
		},
	},
	-- disable 'align_position' for select navlinks
	[101006] = no_align_pos,
	[101007] = no_align_pos,
	[101008] = no_align_pos,
	[101009] = no_align_pos,
	[101010] = no_align_pos,
	[101011] = no_align_pos,
	[101012] = no_align_pos,
	[101013] = no_align_pos,
	[101189] = no_align_pos,
	[101193] = no_align_pos,
	[101192] = no_align_pos,
	[101198] = no_align_pos,
	[101200] = no_align_pos,
	-- disable vanilla's bags to defend objective (it's handled by a new one in mission_script_add)
	[101600] = disabled,
	-- Spawn group intervals
	[101178] = street_spawn,
	[100994] = street_spawn,
	[100993] = bush_spawn,
	[101131] = bush_spawn,
	[101038] = roof_vertical_spawn,
	[101204] = roof_vertical_spawn,
	[101859] = roof_horizontal_spawn,
	[101864] = roof_horizontal_spawn,
}
