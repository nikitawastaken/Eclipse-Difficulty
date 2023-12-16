return {
	-- add point of no return and disable endless assault
	[100875] = {
		ponr = {
			length = 240,
			player_mul = {1.5, 1, 0.85, 0.75}
		},
	},
	[100877] = {
		values = {
			enabled = false
		}
	},
	-- Slow down window spawns
	[100750] = {
		values = {
			interval = 20
		}
	},
	[101012] = {
		values = {
			interval = 20
		}
	},
	[102138] = {
		values = {
			interval = 20
		}
	},
	[104338] = {
		values = {
			interval = 20
		}
	},
	-- slow down repel spawns at the start
	[107261] = {
		values = {
			interval = 20
		}
	},
	[107260] = {
		values = {
			interval = 20
		}
	},
	-- slow down repel spawns at the end
	[104347] = {
		values = {
			interval = 20
		}
	},
	[102151] = {
		values = {
			interval = 20
		}
	},
}
