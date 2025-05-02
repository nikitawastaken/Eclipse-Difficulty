local preferred = Eclipse.preferred
local flank_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_bulldozers,
}
local warehouse_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields,
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Spawn group delays
	[100132] = flank_spawn,
	[103919] = flank_spawn,
	[100007] = warehouse_spawn,
	[100131] = roof_spawn,
	[101008] = roof_spawn,
	[101153] = roof_spawn,
	[101473] = roof_spawn,
}
