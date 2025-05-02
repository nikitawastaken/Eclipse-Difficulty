local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local courtyard_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local window_spawn1 = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local window_spawn2 = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local skylight_spawn1 = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local skylight_spawn2 = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Add new reinforce
	[100109] = { -- Police arrived
		reinforce = {
			{
				name = "entrance",
				force = 3,
				position = Vector3(-3450, 200, -700),
			},
		},
	},
	[102154] = { -- 1st timelock done
		difficulty = 0.75,
		on_executed = {
			{ id = 100345, delay = 0 }, -- Bain diff increase dialogue
		},
		reinforce = {
			{
				name = "south",
				force = 2,
				position = Vector3(-1300, 200, -350),
			},
			{
				name = "west",
				force = 2,
				position = Vector3(0, 2900, -300),
			},
			{
				name = "north",
				force = 2,
				position = Vector3(1200, 200, -350),
			},
			{
				name = "east",
				force = 2,
				position = Vector3(0, -2500, -300),
			},
		},
	},
	[101733] = { -- opened the door to the diamond room
		difficulty = 1,
		on_executed = {
			{ id = 100345, delay = 0 }, -- Bain diff increase dialogue
		},
	},
	-- prevent cops from spawning too soon
	[100022] = {
		on_executed = {
			{ id = 100109, delay = 30 },
		},
	},
	-- remove exhibition room rappels from one security room's on_executed
	[102137] = { -- security room 3
		on_executed = {
			{ id = 102128, remove = true }, -- add 10
		},
	},
	-- delay pillar room rappel preferreds
	[102154] = {
		on_executed = {
			{ id = 100128, delay = 30, delay_rand = 10 }, -- add 40
			{ id = 100130, delay = 30, delay_rand = 10 }, -- add 41
			{ id = 102129, delay = 20, delay_rand = 10 }, -- add 11
		},
	},
	-- disable vanilla difficulty scaling
	[100124] = disabled,
	[100125] = disabled,
	-- don't remove front spawns
	[102159] = disabled,
	-- remove sketchy cheat spawns
	[102317] = disabled,
	[101258] = disabled,
	[102225] = disabled,
	[102224] = disabled,
	[102226] = disabled,
	-- Spawn group delays
	[100786] = courtyard_spawn,
	[100789] = courtyard_spawn,
	[100790] = courtyard_spawn,
	[100791] = courtyard_spawn,
	[100007] = window_spawn1,
	[102418] = window_spawn1,
	[102399] = window_spawn2,
	[102400] = window_spawn2,
	[100019] = skylight_spawn1,
	[100809] = skylight_spawn1,
	[100021] = skylight_spawn1,
	[100810] = skylight_spawn1,
	[101924] = skylight_spawn2,
	[101941] = skylight_spawn2,
	[101943] = skylight_spawn2,
	[101942] = skylight_spawn2,
	[101959] = skylight_spawn2,
	[101946] = skylight_spawn2,
}
