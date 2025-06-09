local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local fence_spawn = {
	values = {
		interval = 5,
	},
}
local bush_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields,
}
local roof_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local sniper_amount = {
	values = {
		amount = easy and 1 or normal and 2 or 3,
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
			position = Vector3(800, -1200, 0),
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
			name = "upstairs1",
			force = 2,
			position = Vector3(1000, 400, 400),
		},
		{
			name = "upstairs2",
			force = 2,
			position = Vector3(450, -550, 400),
		},
		{
			name = "kitchen",
			force = 2,
			position = Vector3(400, 1200, 400),
		},
	},
}
return {
	[100981] = {
		values = { -- initial diff
			difficulty = 0.33,
		},
	},
	[102510] = { -- 1st wave complete
		difficulty = 0.66,
		on_executed = {
			{ id = 400003, delay = 0, delay_rand = 15 }, -- custom roof preferreds
			{ id = 400004, delay = 15, delay_rand = 30 }, -- custom window preferreds
		},
	},
	[102511] = { -- 2nd wave complete
		difficulty = 1,
	},
	-- Change how preferreds are distributed
	[100982] = { -- preferred
		on_executed = {
			{ id = 100987, remove = true }, -- preferred add 1
			{ id = 400001, delay = 0, delay_rand = 0 }, -- custom street preferreds
			{ id = 400002, delay = 0, delay_rand = 15 }, -- custom bush preferreds
		},
	},
	-- Add new reinforce
	[100979] = {
		reinforce = {
			{
				name = "touch_grass1",
				force = 2,
				position = Vector3(-1500, 800, 300),
			},
			{
				name = "touch_grass2",
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
	--[[set sniper amounts
	[102450] = sniper_amount,
	[102451] = sniper_amount,
	]]
	-- Spawn group delays
	[101178] = fence_spawn,
	[100994] = fence_spawn,
	[100993] = bush_spawn,
	[101131] = bush_spawn,
	[101038] = roof_spawn,
	[101204] = roof_spawn,
	[101656] = roof_spawn,
	[101859] = window_spawn,
	[101864] = window_spawn,
}
