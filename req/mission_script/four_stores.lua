local scripted_enemy = Eclipse.scripted_enemy
return {
	-- disable Titan cams
	[103683] = {
		values = {
			enabled = false,
		},
	},
	-- spawn points (from ASS)
	[101112] = { -- spawn 1
		on_executed = {
			{ id = 103242 },
		},
	},
	[101113] = {
		on_executed = {
			{ id = 103242 },
		},
		values = {
			enabled = true,
		},
	},
	[101115] = {
		on_executed = {
			{ id = 103242 },
		},
		values = {
			enabled = true,
		},
	},
	[103240] = { -- open the door if you spawn at spawn 3, not based on difficulty
		on_executed = {
			{ id = 103242, remove = true },
		},
	},
	[102929] = {
		values = {
			interval = 10,
		},
	},
	[101375] = {
		values = {
			interval = 30,
		},
		groups = preferred.no_cops_agents_shields_bulldozers,
	},
}
