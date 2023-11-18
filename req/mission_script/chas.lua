return {
	[101190] = {
		reinforce = {
			{
				name = "store_front1",
				force = 3,
				position = Vector3(-2000, 300, -10)
			},
			{
				name = "store_front2",
				force = 3,
				position = Vector3(-1000, 300, -10)
			}
		}
	},
	[101647] = {
		reinforce = {
			{
				name = "store_front2"
			},
			{
				name = "back_alley",
				force = 3,
				position = Vector3(-1400, 4900, 540)
			}
		}
	},
	-- slow down a few spawn points in the back alleyway
	[100132] = {
		values = {
			interval = 20
		}
	},
	[100133] = {
		values = {
			interval = 20
		}
	},
	[100692] = {
		values = {
			interval = 20
		}
	},
}