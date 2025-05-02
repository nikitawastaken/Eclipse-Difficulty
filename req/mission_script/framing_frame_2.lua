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
}
