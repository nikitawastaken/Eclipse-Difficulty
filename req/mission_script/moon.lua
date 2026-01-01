local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local disabled = {
	values = {
		enabled = false,
	},
}
local exclude_cop_agents_shields_dozers = {
	so_access_filter = so_access.acrobatic,
}
local entrance_spawn = {
	values = {
		interval = 15,
	},
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
	groups = preferred.only_cloakers_single,
}
return {
	-- Add new reinforce
	[100768] = { -- Santa has been untied
		reinforce = {
			{
				name = "santa",
				force = 3,
				position = Vector3(-365, -275, -100),
			},
			{
				name = "escalator01",
				force = 2,
				position = Vector3(225, -2850, 0),
			},
			{
				name = "escalator02",
				force = 2,
				position = Vector3(-2750, 175, 0),
			},
		},
	},
	[100699] = { -- flare placed
		on_executed = {
			{ id = 400002, delay = 0, delay_rand = 15 }, -- custom roof preferreds
		},
	},
	-- Rework preferreds, separate street spawns from roof spawns
	[100129] = { -- preferred
		on_executed = {
			{ id = 100127, remove = true }, -- default preferreds
			{ id = 400001, delay = 0 }, -- custom street preferreds
		},
	},
	-- begin the cloaker hunt at the start of the first assault
	[100842] = {
		values = {
			trigger_times = 1,
		},
		on_executed = {
			{ id = 400039, delay = 0 },
		},
	},
	-- e_nl_up_1m_down_5m_swing
	[103784] = exclude_cop_agents_shields_dozers,
	[103785] = exclude_cop_agents_shields_dozers,
	[103786] = exclude_cop_agents_shields_dozers,
	[103790] = exclude_cop_agents_shields_dozers,
	[103791] = exclude_cop_agents_shields_dozers,
	[103792] = exclude_cop_agents_shields_dozers,
	-- Spawn group intervals
	-- This heist is quite compact, so having 0s (5s) spawn groups is a bit overkill, especially when you reach the roof, things get pretty messy up there.
	[100131] = entrance_spawn,
	[100130] = entrance_spawn,
	[100133] = entrance_spawn,
	[100128] = entrance_spawn,
	[100007] = roof_spawn,
	[100019] = roof_spawn,
	[100132] = roof_spawn,
	[101470] = roof_spawn,
	[400028] = cloaker_spawn,
	[400029] = cloaker_spawn,
	[400030] = cloaker_spawn,
	[400031] = cloaker_spawn,
	[400032] = cloaker_spawn,
	[400033] = cloaker_spawn,
	[400034] = cloaker_spawn,
	[400035] = cloaker_spawn,
	[400036] = cloaker_spawn,
}
