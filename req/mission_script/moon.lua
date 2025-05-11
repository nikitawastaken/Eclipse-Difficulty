local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local exclude_shields_dozers = {
	so_access_filter = { "cop", "fbi", "swat", "taser", "spooc" },
}
local entrance_spawn = {
	values = {
		interval = 15,
	},
}
local roof_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Add new reinforce
	[100768] = { -- Santa has been untied
		reinforce = {
			{
				name = "santa",
				force = 2,
				position = Vector3(-367, -278, -98),
			},
		},
	},
	[100699] = { -- flare placed
		on_executed = {
			{ id = 400002, delay = 0 }, -- custom roof preferreds
		},
		reinforce = {
			{
				name = "escalator1",
				force = 3,
				position = Vector3(225, -2850, 0),
			},
			{
				name = "escalator2",
				force = 3,
				position = Vector3(-2750, 175, 0),
			},
		},
	},
	[101334] = { -- skylight has been blown up
		reinforce = {
			{
				name = "roof1",
				force = 2,
				position = Vector3(-600, -600, 1050),
			},
			{
				name = "roof2",
				force = 2,
				position = Vector3(600, 600, 1050),
			},
		},
	},		
	-- Rework preferreds, separate street spawns from roof spawns
	[100129] = { -- preferred
		on_executed = {
			{ id = 100127, remove = true }, -- default preferreds
			{ id = 400001, delay = 0 }, -- custom street preferreds
		},
	},	
	-- e_nl_up_1m_down_5m_swing
	[103784] = exclude_shields_dozers,
	[103785] = exclude_shields_dozers,
	[103786] = exclude_shields_dozers,
	[103790] = exclude_shields_dozers,
	[103791] = exclude_shields_dozers,
	[103792] = exclude_shields_dozers,
	-- Spawn group delays
	-- This heist is quite compact, so having 0s (5s) spawn groups is a bit overkill, especially when you reach the roof, things get pretty messy up there.
	[100131] = entrance_spawn,
	[100130] = entrance_spawn,
	[100133] = entrance_spawn,
	[100128] = entrance_spawn,
	[100007] = roof_spawn,
	[100019] = roof_spawn,
	[100132] = roof_spawn,
	[101470] = roof_spawn,
}
