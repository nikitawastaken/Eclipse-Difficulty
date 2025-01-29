local bridge_spawn = {
	values = {
		interval = 20
	}
}

return {
	-- add point of no return
	[100580] = {
		ponr = {
			length = 120,
			player_mul = { 2, 1.25, 1, 1 }
		}
	},
	-- slow down a few spawnpoints
	[100130] = bridge_spawn,
	[100128] = bridge_spawn,
	[100694] = bridge_spawn,
	[101217] = bridge_spawn,
	[102374] = {
		values = {
			elements = {
				102376,
				102377,
				102378,
				102379,
				102380
			}
		}
	},
	[101707] = {
		values = {
			enabled = false
		}
	}
}
