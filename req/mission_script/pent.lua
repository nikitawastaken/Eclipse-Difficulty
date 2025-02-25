local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
return {
	[101607] = {
		ponr = {
			length = 180,
			player_mul = { 1.33, 1.15, 1, 0.85 },
		},
	},
	--Fixed snipers being able to spawn only once
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	[100372] = sniper_trigger_times,
	[103595] = {
		reinforce = {
			{
				name = "main_room",
				force = 3,
				position = Vector3(300, -1600, 12100),
			},
		},
	},
	[103831] = {
		reinforce = {
			{
				name = "main_room",
			},
			{
				name = "helipad",
				force = 3,
				position = Vector3(1600, -1600, 13100),
			},
		},
	},
}
