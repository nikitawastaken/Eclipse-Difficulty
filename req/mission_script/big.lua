local elevator_spawn = {
	values = {
		interval = 20
	}
}
return {
	[100809] = {
		ponr = {
			length = 180,
			player_mul = { 2, 1.25, 1., 1 }
		}
	},
	[105844] = {
		reinforce = {
			{
				name = "meetingroom",
				force = 2,
				position = Vector3(-3400, 1000, -600)
			},
			{
				name = "outside_vault",
				force = 2,
				position = Vector3(-3000, 500, -1000)
			}
		}
	},
	-- enable roof spawngroups
	[100006] = {
		values = {
			spawn_groups = { 100019, 100007, 100692 }
		}
	},
	-- slow down elevator spawn points
	[105550] = elevator_spawn,
	[105434] = elevator_spawn,
	[105450] = elevator_spawn,
}
