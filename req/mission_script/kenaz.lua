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
	[100379] = {
		ponr = {
			length = 240,
			player_mul = { 2, 1.25, 1, 1 },
		},
		-- drill done
		reinforce = {
			{
				name = "security01",
				force = 2,
				position = Vector3(-1100, 1500, 100),
			},
			{
				name = "security02",
				force = 2,
				position = Vector3(950, 1500, 100),
			},
		},
	},
	[102786] = disabled,
	-- the BFD is running, start spawning interior snipers
	[100394] = {
		on_executed = {
			{ id = 400034, delay = 20, delay_rand = 40 },
		},
	},
	-- Delay enemy spawns
	[100224] = { -- Combat ON
		on_executed = {
			{ id = 101024, delay = 40 }, -- elevators
		},
	},
	[101907] = { -- start enemies delay end
		on_executed = {
			{ id = 100230, delay = 40 }, -- wall spawns
		},
	},
	-- Remove vanilla reinforce
	[103204] = disabled,
	[103205] = disabled,
	[103206] = disabled,
	[103207] = disabled,
	[103209] = disabled,
	-- New reinforce points
	[100229] = { -- enemies add
		reinforce = {
			{
				name = "exterior_entrance",
				force = 4,
				position = Vector3(0, -6550, 0),
			},
			{
				name = "exterior_right",
				force = 3,
				position = Vector3(2450, -5500, 25),
			},
			{
				name = "exterior_left",
				force = 3,
				position = Vector3(-3150, -5550, 20),
			},
		},
	},
	[101620] = { -- assemble the winch
		reinforce = {
			{
				name = "interior_balcony01",
				force = 2,
				position = Vector3(1330, -2440, 550),
			},
			{
				name = "interior_balcony02",
				force = 2,
				position = Vector3(-1310, -2440, 550),
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
