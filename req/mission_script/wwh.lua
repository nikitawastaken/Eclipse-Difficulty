local slow_spawn = {
	values = {
		interval = 30,
	},
}
return {
	[100945] = {
		ponr = {
			length = 900,
			player_mul = { 2, 1.25, 1, 0.8 },
		},
	},
	-- disable the cancer ambush enemy spam that doesn't even work properly
	[100361] = {
		values = {
			enabled = false,
		},
	},
	-- slow down a few spawnpoints
	[100605] = slow_spawn,
	[100737] = slow_spawn,
	[100177] = slow_spawn,
}
