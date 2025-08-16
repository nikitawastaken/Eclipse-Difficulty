local preferred = Eclipse.preferred
local standard_spawn = {
	values = {
		interval = 10,
	},
}
local upper_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.only_swats_tasers,
}
return {
	[102064] = {
		ponr = {
			length = 30,
			player_mul = { 4, 3, 2, 1 },
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
	-- spawn point delays
	[103530] = standard_spawn,
	[103531] = standard_spawn,
	[101583] = upper_spawn,
	[102299] = upper_spawn,
	[103423] = upper_spawn,
	[103424] = upper_spawn,
}
