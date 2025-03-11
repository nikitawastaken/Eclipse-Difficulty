local preferred = Eclipse.preferred
local rappel_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields_bulldozers,
}
local skylight_spawn = {
	values = {
		interval = 25,
	},
}
return {
	-- Fix harasser respawn delay
	[102807] = {
		on_executed = {
			{ id = 102804, delay = 30 },
		},
	},
	-- slow down some repel spawnpoints
	[100147] = rappel_spawn,
	[100145] = rappel_spawn,
	[100132] = rappel_spawn,
	[100021] = rappel_spawn,
	[100148] = skylight_spawn,
	[100146] = skylight_spawn,
	[100131] = skylight_spawn,
	[100149] = {
		values = {
			interval = 45,
		},
		groups = preferred.no_shields_bulldozers,
	},
}
