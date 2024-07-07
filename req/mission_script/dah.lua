return {
	-- enable pretty much all of the spawnpoints on the map from the very beginning, except those in the vault
	-- should be impossible to spawncamp the heist that way
	[104385] = {
		values = {
			enabled = true
		}
	},
	[104386] = {
		values = {
			enabled = true
		}
	},
	[104387] = {
		values = {
			enabled = true
		}
	},
	[104388] = {
		values = {
			enabled = true
		}
	},
	[104389] = {
		values = {
			enabled = true
		}
	},
	[103084] = {
		values = {
			enabled = true
		}
	},
	[104207] = {
		values = {
			enabled = true
		}
	},
	[104210] = {
		values = {
			enabled = true
		}
	},
	[104211] = {
		values = {
			enabled = true
		}
	},
	[104354] = {
		values = {
			enabled = true
		}
	},
	[104355] = {
		values = {
			enabled = true
		}
	},
	[104356] = {
		values = {
			enabled = true
		}
	},
	[104357] = {
		values = {
			enabled = true
		}
	},
	[104358] = {
		values = {
			enabled = true
		}
	},
	[104372] = {
		values = {
			enabled = true
		}
	},
	[104373] = {
		values = {
			enabled = true
		}
	},
	[104374] = {
		values = {
			enabled = true
		}
	},
	[104823] = {
		values = {
			enabled = true
		}
	},
	[104887] = {
		values = {
			enabled = true
		}
	},
	-- disable the enemy_prefered_remove's so that all spawnpoints stay enabled throughout the heist
	[100875] = {
		values = {
			enabled = false
		}
	},
	[102386] = {
		values = {
			enabled = false
		}
	},
	[104361] = {
		values = {
			enabled = false
		}
	},
	[104375] = {
		values = {
			enabled = false
		}
	},
	[102191] = {
		values = {
			enabled = false
		}
	},
	[104390] = {
		values = {
			enabled = false
		}
	},
	[104886] = {
		values = {
			enabled = false
		}
	},
	-- disable endless
	[101967] = {
		values = {
			enabled = false
		}
	},
	[102061] = {
		values = {
			enabled = false
		}
	},
	[104949] = {
		set_ponr_state = true
	},
	[103969] = {
		reinforce = {
			{
				name = "atrium1",
				force = 2,
				position = Vector3(-4000, -2200, 750),
			},
			{
				name = "atrium2",
				force = 2,
				position = Vector3(-2750, -2200, 750),
			},
			{
				name = "atrium3",
				force = 2,
				position = Vector3(-2750, -1000, 750),
			},
			{
				name = "atrium4",
				force = 2,
				position = Vector3(-4000, -1000, 750),
			},
		},
	},
	[101342] = {
		reinforce = {
			{
				name = "vault_entrance",
				force = 3,
				position = Vector3(-3250, -2850, 0),
			},
			{
				name = "atrium_lower1",
				force = 3,
				position = Vector3(-3800, -800, 400),
			},
			{
				name = "atrium_lower2",
				force = 3,
				position = Vector3(-2700, -800, 400),
			},
		},
	},
	-- slow down vault spawnpoints
	[104822] = {
		values = {
			interval = 45
		}
	},
	[104821] = {
		values = {
			interval = 45
		}
	},
	[100723] = {
		values = {
			interval = 45
		}
	},
	[100722] = {
		values = {
			interval = 45
		}
	},
	-- slow down roof spawnpoints
	[104896] = {
		values = {
			interval = 45
		}
	},
	[102778] = {
		values = {
			interval = 45
		}
	},
	[104846] = {
		values = {
			interval = 45
		}
	},
	[104764] = {
		values = {
			interval = 45
		}
	},
	[102772] = {
		values = {
			interval = 45
		}
	},
	[102784] = {
		values = {
			interval = 25 -- intentionally slightly lower delay for the groups that are on the other side of the roof
		}
	},
	[104852] = {
		values = {
			interval = 25
		}
	}
}
