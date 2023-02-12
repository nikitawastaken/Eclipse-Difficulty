return {
	-- Disable instant difficulty increase
	[100122] = {
		values = {
			enabled = false
		}
	},
	-- Loud, set difficulty and slightly delay police response
	[100109] = {
		difficulty = 0.5,
		values = {
			base_delay = 30
		}
	},
	[100129] = {
		reinforce = {
			{
				name = "auction_room",
				force = 3,
				position = Vector3(0, 2000, -100)
			},
			{
				name = "outside",
				force = 3,
				position = Vector3(0, -3300, -50)
			}
		}
	},
	-- Slow down roof spawns
	[102667] = {
		values = {
			interval = 20
		}
	},
	[106776] = {
		values = {
			interval = 20
		}
	},
	[106767] = {
		values = {
			interval = 20
		}
	},
	[106764] = {
		values = {
			interval = 20
		}
	},
	[100694] = {
		values = {
			interval = 30
		}
	},
	[100154] = {
		values = {
			interval = 30
		}
	}
}