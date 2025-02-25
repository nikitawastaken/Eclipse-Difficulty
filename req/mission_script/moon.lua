local entrance_spawn = {
	values = {
		interval = 20,
	},
}
local roof_spawn = {
	values = {
		interval = 20,
	},
}

return {
	-- slow down a few roof spawnpoints
	[101470] = roof_spawn,
	[100007] = roof_spawn,
	[100019] = roof_spawn,
	[100132] = roof_spawn,
	-- slow down main entrance spawnpoints
	[100131] = entrance_spawn,
	[100130] = entrance_spawn,
	[100133] = entrance_spawn,
	[100128] = entrance_spawn,
}
