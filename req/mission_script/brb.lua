local interval = {
	values = {
		interval = 45,
	},
}
return {
	-- Combine some navigation areas
	[100287] = {
		ai_area = {
			{ 10, 11, 12, 15 },
			{ 13, 17, 27 },
			{ 5, 6, 7, 59, 8, 9, 18 },
			{ 36, 37 },
		},
	},
	--Don't trigger the spawngroup if the tarp has been cut (should prevent cops from spawning early)
	--yes, this makes the cops spawn early
	[101288] = {
		values = {
			enabled = false,
		},
	},
	-- Slow down inside spawns
	[100247] = interval,
	[100067] = interval,
	[100068] = interval,
}
