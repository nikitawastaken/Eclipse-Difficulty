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
local elevator_spawn = {
	values = {
		interval = 15,
	},
}
local bow_spawn = {
	values = {
		interval = 15,
	},
}
local lifeboat_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local spa_window_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local balcony_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local courtyard_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents,
}
local casino_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents,
}
local spa_ceiling_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents,
}
local vent_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Reenforce points
	[103167] = disabled,
	[103168] = disabled,
	[103169] = disabled,
	[103170] = disabled,
	[103172] = disabled,
	[100109] = {
		reinforce = {
			{
				name = "elevator",
				force = 2,
				position = Vector3(-9300, 9800, 0),
			},
			{
				name = "corridor_right",
				force = 2,
				position = Vector3(-7500, 6800, 20),
			},
			{
				name = "corridor_left",
				force = 2,
				position = Vector3(-11100, 6800, 20),
			},
			{
				name = "casino",
				force = 3,
				position = Vector3(-9300, 2500, 100),
			},
			{
				name = "courtyard",
				force = 3,
				position = Vector3(-9300, 8500, 0),
			},
		},
	},
	-- Escape reenforce/harasser stuff
	[100918] = {
		on_executed = {
			{ id = 100890, remove = true },
		},
	},
	[101449] = { --Escape signalled
		on_executed = {
			{ id = 100890 },
		},
		reinforce = {
			{ name = "elevator" },
			{ name = "corridor_right" },
			{ name = "corridor_left" },
			{ name = "casino" },
			{ name = "courtyard" },
			{
				name = "helipad",
				force = 4,
				position = Vector3(-9300, 17000, 100),
			},
			{
				name = "spa_outside1",
				force = 2,
				position = Vector3(-7500, 15500, 0),
			},
			{
				name = "spa_outside2",
				force = 2,
				position = Vector3(-11000, 15500, 0),
			},
		},
	},
	-- Enable unused snipers
	[100371] = enabled,
	[100372] = enabled,
	-- Spawn group delays
	-- The Black Cat is one of the newer heists, so its spawn groups are not spread out at all and reach players almost immediately.
	-- The shortest interval is 15s, for reference on most heists that would be 5s. It's not uncommon even for post-Jules heists to have 15s spawn groups, but the revival era team was seemingly pretty clueless in this respect.
	-- Rappels right next to the usual player holdout spots (Spa, Corridors around the main courtyard) are slowed down and heavily restricted. No Bulldozers spawning right next to you.
	-- I also slowed down the courtyard spawns since that area gets crowded super fast. Originally they were as slow as corridor/spa window groups, but I figured it would impact the frequency of some groups too harshly.
	[100786] = bow_spawn,
	[101471] = bow_spawn,
	[100792] = bow_spawn,
	[100131] = bow_spawn,
	[100648] = lifeboat_spawn,
	[100704] = lifeboat_spawn,
	[100712] = lifeboat_spawn,
	[100693] = lifeboat_spawn,
	[100019] = casino_spawn,
	[100757] = courtyard_spawn,
	[100758] = courtyard_spawn,
	[100759] = courtyard_spawn,
	[100692] = balcony_spawn,
	[100007] = balcony_spawn,
	[100312] = balcony_spawn,
	[100325] = balcony_spawn,
	[100766] = balcony_spawn,
	[100768] = balcony_spawn,
	[100647] = elevator_spawn,
	[100132] = spa_window_spawn,
	[100133] = spa_window_spawn,
	[100779] = spa_ceiling_spawn,
	[101468] = spa_ceiling_spawn,
	[101470] = vent_spawn,
}
