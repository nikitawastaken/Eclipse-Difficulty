local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local roof_spawn = {
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
local sewer_spawn = {
	values = {
		interval = 30,
	},
}
return {
	[100104] = disabled,
	[100980] = {
		ponr = {
			length = 60,
			player_mul = { 1.67, 1.34, 1, 1 },
		},
	},
	-- Add new reinforce
	[100653] = { -- Players are on the ground
		reinforce = {
			{
				name = "fast_food",
				force = 3,
				position = Vector3(2050, -3150, 25),
			},
			{
				name = "carshop",
				force = 3,
				position = Vector3(1600, 750, 25),
			},
			{
				name = "gas_station",
				force = 3,
				position = Vector3(-1650, 2000, 25),
			},
			{
				name = "hardware",
				force = 3,
				position = Vector3(-1000, 150, 25),
			},
		},
	},
	-- Introduce roof preferreds after the 1st wave
	[102470] = {
		on_executed = {
			{ id = 100531, remove = true }, -- Car Shop preferred
			{ id = 100534, remove = true }, -- Hardware preferred
		},
	},
	[100123] = { -- Assault ended
		on_executed = {
			{ id = 100531, delay = 0, delay_rand = 15 }, -- Car Shop preferred
			{ id = 100534, delay = 0, delay_rand = 15 }, -- Hardware preferred
		},
	},
	-- Spawn group intervals
	[100411] = wall_spawn,
	[100403] = wall_spawn,
	[100412] = wall_spawn,
	[100413] = wall_spawn,
	[100409] = wall_spawn,
	[100408] = wall_spawn,
	[100405] = roof_spawn,
	[100406] = roof_spawn,
	[100414] = roof_spawn,
	[100415] = roof_spawn,
	[100078] = sewer_spawn,
	[100080] = sewer_spawn,
	[100082] = sewer_spawn,
	[100088] = sewer_spawn,
	[100089] = sewer_spawn,
	[100094] = sewer_spawn,
}
