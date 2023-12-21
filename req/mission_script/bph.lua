return {
	-- Allow bot navigation earlier
	[102736] = {
		on_executed = {
			{ id = 103049, delay = 1 }
		}
	},
	[101161] = {
		values = {
			enabled = false
		},
	},
	[100268] = {
		ponr = {
			length = 300,
			player_mul = {1.25, 1, 1, 1}
		}
	},
	-- longer spawnpoint (those on top of the player) delays at the starting sequence
	[100741] = {
		values = {
			interval = 20
		}
	},
	[100131] = {
		values = {
			interval = 20
		}
	}
}
