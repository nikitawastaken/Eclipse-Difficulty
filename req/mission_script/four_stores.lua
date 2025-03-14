local scripted_enemy = Eclipse.scripted_enemy
return {
	-- Combine some navigation areas
	[101230] = {
		ai_area = {
			{ 59, 62 },
			{ 54, 55, 125, 126 },
			{ 46, 42, 50, 44, 36, 49, 45, 43, 48, 90, 47, 51 },
			{ 79, 80, 78, 77, 37, 16 },
			{ 35, 34 },
			{ 94, 95, 33, 32, 30, 31 },
			{ 40, 41, 96, 97, 98 },
			{ 39, 38 },
			{ 26, 29, 27 },
			{ 24, 25, 100, 23, 22 },
			{ 18, 20 },
			{ 61, 17, 15, 14 },
			{ 13, 9, 8 },
			{ 11, 81, 82, 83, 86, 84, 85, 87, 88, 89 },
			{ 5, 6, 92, 4, 3 },
			{ 66, 67, 60, 118, 117, 116 },
			{ 120, 121, 119, 123 },
			{ 103, 102, 105, 104, 106, 69 },
			{ 76, 111 },
			{ 130, 129 },
			{ 108, 109 },
			{ 131, 128, 101 },
			{ 107, 74, 133, 12, 19, 21 },
			{ 64, 135, 63, 58, 134 },
			{ 52, 53 },
		},
	},
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
