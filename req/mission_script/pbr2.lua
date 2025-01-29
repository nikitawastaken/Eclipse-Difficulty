local ground_spawn = {
	values = {
		interval = 20
	}
}
	
return {
	[100104] = {
		values = {
			enabled = false
		  }
	},
	[100980] = {
		ponr = {
			length = 60,
			player_mul = { 1.67, 1.34, 1, 1 }
		}
	},
	-- slow down a bunch of ground level spawnpoints
	[100411] = ground_spawn,
	[100403] = ground_spawn,
	[100412] = ground_spawn,
	[100413] = ground_spawn,
	[100409] = ground_spawn,
	[100408] = ground_spawn,
}
