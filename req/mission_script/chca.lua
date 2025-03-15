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
local bow_spawn = {
	values = {
		interval = 15,
	},
}
local lifeboat_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields,
}
local elevator_spawn = {
	values = {
		interval = 20,
	},
}
local courtyard_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local casino_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local spa_ceiling_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local balcony_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local spa_window_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local vent_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- delay police response
	[100022] = {
		on_executed = {
			{ id = 100109, delay = 30 },
		},
	},
	-- reenforce points
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
	-- escape reenforce/harasser stuff
	[100918] = {
		on_executed = {
			{ id = 100890, remove = true },
		},
	},
	[101449] = { --escape signalled
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
	-- enable unused snipers
	[100371] = enabled,
	[100372] = enabled,
	-- spawn group delays
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
