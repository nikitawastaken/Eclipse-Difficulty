local preferred = Eclipse.preferred
local van_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_cops_agents,
}
local street_spawn = {
	values = {
		interval = 10,
	},
}
local avalon_spawn = {
	values = {
		interval = 15,
	},
}
local upper_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local building_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- add point of no return
	[100580] = {
		ponr = {
			length = 600,
			player_mul = { 1.8, 1.5, 1.3, 1.2 },
		},
	},
	-- Add new reinforce
	[102850] = { -- in garage
		reinforce = {
			{
				name = "car",
				force = 3,
				position = Vector3(10600, 5500, -2400),
			},
		},
	},
	[102128] = {
		difficulty_add = 0.05,
	},
	-- Spawn group delays
	[101719] = street_spawn,
	[101728] = street_spawn,
	[101731] = street_spawn,
	[100128] = van_spawn,
	[100130] = van_spawn,
	[100131] = van_spawn,
	[100132] = van_spawn,
	[101791] = avalon_spawn,
	[101722] = upper_spawn,
	[101725] = upper_spawn,
	[101737] = upper_spawn,
	[101789] = upper_spawn,
	[101734] = building_spawn,
}
