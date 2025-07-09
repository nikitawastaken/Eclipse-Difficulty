local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local wall_spawn = {
	values = {
		interval = 10,
	},
}
local roof_spawn = {
	values = {
		interval = 20,
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
		difficulty = 0.25,
		reinforce = {
			{
				name = "fast_food",
				force = 2,
				position = Vector3(2050, -3150, 25),
			},
			{
				name = "carshop",
				force = 2,
				position = Vector3(1600, 750, 25),
			},
			{
				name = "gas_station",
				force = 2,
				position = Vector3(-1650, 2000, 25),
			},
			{
				name = "hardware",
				force = 2,
				position = Vector3(-1000, 150, 25),
			},
		},
		on_executed = { -- delay besiege
			{ id = 100426, delay = 30 },
		},
	},
	-- Tweak difficulty scaling (it's aids in vanilla)
	[100661] = { -- pallet discovered
		difficulty_add = 0.25,
	},
	[100424] = disabled, -- diff 0.75
	[100124] = disabled, -- diff 1
	-- Introduce roof preferreds after the 1st wave
	[102470] = {
		on_executed = {
			{ id = 100531, remove = true }, -- Car Shop preferred
			{ id = 100534, remove = true }, -- Hardware preferred
		},
	},
	[100123] = { -- Assault ended
		on_executed = {
			{ id = 100531, delay = 0, delay_rand = 30 }, -- Car Shop preferred
			{ id = 100534, delay = 0, delay_rand = 30 }, -- Hardware preferred
		},
	},
	-- Spawn group delays
	[100403] = wall_spawn,
	[100408] = wall_spawn,
	[100409] = wall_spawn,
	[100411] = wall_spawn,
	[100412] = wall_spawn,
	[100413] = wall_spawn,
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
