local preferred = Eclipse.preferred
local wall_spawn = {
	values = {
		interval = 10,
	},
}
local sewer_spawn = {
	values = {
		interval = 30,
	},
}
local roof_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[100104] = {
		values = {
			enabled = false,
		},
	},
	[100980] = {
		ponr = {
			length = 60,
			player_mul = { 1.67, 1.34, 1, 1 },
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
