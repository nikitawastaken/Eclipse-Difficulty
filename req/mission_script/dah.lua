return {
	[101967] = {
		values = {
			enabled = false
		}
	},
	[100614] = {
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
