local preferred = Eclipse.preferred
local initial_diff = {
	values = {
		difficulty = 0.33,
	},
}
local reinforcement_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_cops_agents,
}
local wall_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields_bulldozers,
}
return {
	[101580] = initial_diff,
	[102090] = initial_diff,
	[101582] = { -- random helicopter
		difficulty = 0.66,
	},
	-- Loot secure difficulty spike
	[101582] = {
		values = {
			difficulty = 1,
		},
	},
	-- Spawn group delays
	[102037] = reinforcement_spawn,
	[102049] = reinforcement_spawn,
	[102060] = reinforcement_spawn,
	[102071] = reinforcement_spawn,
	[100634] = wall_spawn,
	[102326] = wall_spawn,
}
