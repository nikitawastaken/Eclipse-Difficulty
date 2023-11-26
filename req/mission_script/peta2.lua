return {
	-- slow down a few spawnpoints
	[100130] = {
		values = {
			interval = 20
		}
	},
	[100128] = {
		values = {
			interval = 20
		}
	},
	[100694] = {
		values = {
			interval = 20
		}
	},
	[101217] = {
		values = {
			interval = 20
		}
	},
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
	-- add point of no return
	[100580] = {
		ponr = 120,
		ponr_player_mul = {2, 1.25, 1, 1}
	},
	[101707] = {
		values = {
			enabled = false
		}
	}
}
