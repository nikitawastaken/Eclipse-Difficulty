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
		ponr = 300,
		ponr_player_mul = {1.25, 1, 1, 1}
	}
}