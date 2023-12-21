return {
	[100304] = {
		reinforce = {
			{
				name = "main_hall",
				force = 5,
				position = Vector3(-120, -2400, 100)
			}
		}
	},
	[100286] = {
		reinforce = {
			{
				name = "main_hall"
			}
		},
		-- add point of no return
		ponr = {
			length = 300,
			player_mul = {1.6, 1.2, 1, 0.8}
		}
	},
	-- slow down the spawnpoints in weaponlab
	[107981] = {
		values = {
			interval = 20
		}
	},
	[100133] = {
		values = {
			interval = 20
		}
	},
	[100941] = {
		values = {
			interval = 20
		}
	},
	[107911] = {
		values = {
			interval = 10
		}
	},
	[107983] = {
		values = {
			interval = 20
		}
	},
	[102407] = {
		values = {
			interval = 20
		}
	},
	-- slow down the spawnpoints in computerlab
	[100128] = {
		values = {
			interval = 20
		}
	},
	[107977] = {
		values = {
			interval = 20
		}
	},
	[100130] = {
		values = {
			interval = 10
		}
	},
	[107913] = {
		values = {
			interval = 10
		}
	},
	-- slightly in archeologylab too
	[100131] = {
		values = {
			interval = 10
		}
	},
	-- slow down the top spawnpoints in the starting sequence
	[101074] = {
		values = {
			interval = 15
		}
	},
	[101350] = {
		values = {
			interval = 15
		}
	}
}
