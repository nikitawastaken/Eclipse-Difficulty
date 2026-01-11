local preferred = Eclipse.preferred
local standard_spawn = {
	values = {
		interval = 10,
	},
}
return {
	[102064] = {
		ponr = {
			length = 60,
			player_mul = { 2.5, 1.75, 1.25, 1 },
		},
	},
	-- add SWATs that come out of the vans
	[102765] = {
		on_executed = {
			{ id = 102766, remove = true },
			{ id = 400001, delay = 0 },
			{ id = 400008, delay = 0 },
		},
	},
	-- Spawn group intervals
	[103530] = standard_spawn,
	[103531] = standard_spawn,
	[101583] = standard_spawn,
	[102299] = standard_spawn,
	[103423] = standard_spawn,
	[103424] = standard_spawn,
}
