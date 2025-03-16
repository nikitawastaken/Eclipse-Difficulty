local preferred = Eclipse.preferred
local construction_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_bulldozers,
}
local bridge_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents,
}
local window_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Combine some navigation areas
	[100287] = {
		ai_area = {
			{ 10, 11, 12, 15 },
			{ 13, 17, 27 },
			{ 5, 6, 7, 59, 8, 9, 18 },
			{ 36, 37 },
		},
	},
	--Don't trigger the spawngroup if the tarp has been cut (should prevent cops from spawning early)
	--Yes, this makes the cops spawn early
	[101288] = {
		values = {
			enabled = false,
		},
	},
	-- Add early reinforce around the bank
	[100001] = {
		reinforce = {
			{
				name = "parking_lot",
				force = 3,
				position = Vector3(-1950, -2750, 10),
			},
			{
				name = "construction",
				force = 3,
				position = Vector3(3100, -3750, 10),
			},
		},
	},
	-- spawn point delays
	[100461] = construction_spawn,
	[100168] = bridge_spawn,
	[100369] = bridge_spawn,
	[100429] = bridge_spawn,
	[100435] = bridge_spawn,
	[100441] = bridge_spawn,
	[100454] = bridge_spawn,
	[100455] = bridge_spawn,
	[100247] = window_spawn,
	[100067] = window_spawn,
	[100068] = window_spawn,
}
