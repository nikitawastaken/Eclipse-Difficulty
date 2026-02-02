local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local skylight_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
return {
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 2, 32 },
			{ 8, 7, 9 },
			{ 26, 27 },
			{ 28, 29 },
			{ 28, 29 },
			{ 89, 91, 90 },
			{ 161, 164 },
			{ 160, 37 },
			{ 67, 68 },
			{ 63, 64 },
			{ 45, 44 },
		},
	},
	[100379] = {
		ponr = {
			length = 240,
			player_mul = { 2, 1.25, 1, 1 },
		},
	},
	[102786] = disabled,
	-- the BFD is running, start spawning interior snipers
	[100394] = {
		on_executed = {
			{ id = 400034, delay = 30, delay_rand = 60 },
		},
	},
	-- Delay enemy spawns
	-- Add a new loot drop point
	[100405] = disabled,
	[101907] = { -- start enemies delay end
		on_executed = {
			{ id = 100230, delay = 45 }, -- wall spawns
		},
	},
	[100224] = { -- Combat ON
		on_executed = {
			{ id = 101024, delay = 45 }, -- elevators
		},
		loot_drop = {
			{
				name = "loot_drop",
				position = Vector3(-4345, -4895, 15),
			},
		},
	},
	-- New reinforce points
	-- Remove vanilla reinforce
	[103204] = disabled,
	[103205] = disabled,
	[103206] = disabled,
	[103207] = disabled,
	[103209] = disabled,
	[100229] = { -- enemies add
		reinforce = {
			{
				name = "exterior_entrance",
				force = 4,
				position = Vector3(0, -8250, 0),
			},
			{
				name = "exterior_right",
				force = 2,
				position = Vector3(2100, -7700, 25),
			},
			{
				name = "exterior_left",
				force = 2,
				position = Vector3(-2100, -7700, 25),
			},
		},
	},
	[101620] = { -- assemble the winch
		reinforce = {
			{
				name = "interior_balcony_right",
				force = 2,
				position = Vector3(1330, -2440, 525),
			},
			{
				name = "interior_balcony_left",
				force = 2,
				position = Vector3(-1330, -2440, 525),
			},
			{
				name = "bar",
				force = 3,
				position = Vector3(50, -3975, 25),
			},
		},
	},
	-- Spawn group intervals
	[103218] = skylight_spawn,
	[102035] = cloaker_spawn,
	[102036] = cloaker_spawn,
	[102037] = cloaker_spawn,
	[102038] = cloaker_spawn,
}
