return {
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 44, 84, 85 },
			{ 103, 104, 105, 106 },
			{ 97, 99 },
			{ 52, 86 },
		},
	},
	[100022] = {
		ponr = {
			length = 3000,
			player_mul = { 1.75, 1.25, 1.125, 1 },
		},
	},
	-- Increase delay on side door spawns
	[103347] = {
		values = {
			interval = 30,
		},
	},
	[103348] = {
		values = {
			interval = 30,
		},
	},
	[103360] = {
		values = {
			enabled = false,
		},
	},
	[101416] = {
		values = {
			enabled = false,
		},
	},
	-- slow down the spawnpoints in peoc (ones that are close to the staircase)
	[100694] = {
		values = {
			interval = 30,
		},
	},
	[102557] = {
		values = {
			interval = 20,
		},
	},
}
