return {
	-- disable Titan cams
	[103683] = {
		values = {
			enabled = false
		}
	},
	-- spawn points (from ASS)
	[101112] = {  -- spawn 1
		on_executed = {
			{ id = 103242 },
		},
	},
	[101113] = {  -- spawn 2
		on_executed = {
			{ id = 103242 }
		},
		values = {
			enabled = true,
		},
	},
	[101115] = {  -- spawn 4
		on_executed = {
			{ id = 103242 }
		},
		values = {
			enabled = true,
		},
	},
	[103240] = {  -- open the door if you spawn at spawn 3, not based on difficulty
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
		groups = {
			tac_shield_wall = false,
			tac_shield_wall_ranged = false,
			tac_shield_wall_charge = false,
		},
	}
}