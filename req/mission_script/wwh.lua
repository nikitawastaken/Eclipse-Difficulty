return {
	-- disable the cancer ambush enemy spam that doesn't even work properly
	[100361] = {
		values = {
			enabled = false
		}
	},
	[100945] = {
		ponr = 900,
		ponr_player_mul = {2, 1.25, 1, 0.8}
	},
	-- slow down a few spawnpoints
	[100605] = {
		values = {
			interval = 30
		}
	},
	[100737] = {
		values = {
			interval = 30
		}
	},
	[100177] = {
		values = {
			interval = 30
		}
	},
}
