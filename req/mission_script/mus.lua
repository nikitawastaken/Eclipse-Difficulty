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
	groups = preferred.no_cops_agents,
}
local staircase_window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local matrix_window_spawn = {
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local exhibit_rappel_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents,
}
local last_rappel_spawn = {
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local hallway_rappel_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 4, 52 },
			{ 136, 129 },
			{ 153, 139 },
			{ 140, 154 },
		},
	},
	-- Add new reinforce
	[100109] = { -- Police arrived
		reinforce = {
			{
				name = "entrance",
				force = 4,
				position = Vector3(-3450, 200, -700),
			},
		},
	},
	[102154] = { -- 1st timelock done
		difficulty = 0.75,
		on_executed = {
			{ id = 100345, delay = 0 }, -- Bain diff increase dialogue
			{ id = 100128, delay = 10, delay_rand = 20 }, -- add 40
			{ id = 100130, delay = 10, delay_rand = 20 }, -- add 41
			{ id = 102129, delay = 20, delay_rand = 40 }, -- add 11
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
	[100116] = {
		on_executed = {
			{ id = 100122, delay = 60 },
		},
	},
	-- remove exhibition room rappels from one security room's on_executed
	[102137] = { -- security room 3
		on_executed = {
			{ id = 102128, remove = true }, -- add 10
		},
	},
	-- disable vanilla difficulty scaling
	[100124] = disabled,
	[100125] = disabled,
	-- don't remove front spawns
	[102131] = { -- security room 1
		on_executed = {
			{ id = 102159, remove = true }, 
		},
	},
	[102137] = { -- security room 3
		on_executed = {
			{ id = 102159, remove = true }, 
		},
	},
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
	[100007] = staircase_window_spawn,
	[102418] = staircase_window_spawn,
	[102399] = matrix_window_spawn,
	[102400] = matrix_window_spawn,
	[100019] = exhibit_rappel_spawn,
	[100809] = exhibit_rappel_spawn,
	[100021] = exhibit_rappel_spawn,
	[100810] = exhibit_rappel_spawn,
	[101959] = hallway_rappel_spawn,
	[101946] = hallway_rappel_spawn,	
	[101924] = last_rappel_spawn,
	[101941] = last_rappel_spawn,
	[101942] = last_rappel_spawn,
	[101943] = last_rappel_spawn,	
}
