local preferred = Eclipse.preferred

local alley_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local roof_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local mortuary_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}

return {
	[100115] = {
		ponr = {
			length = 900,
			player_mul = { 2, 1.25, 1, 1 },
		},
	},
	-- Add new reinforce
	[100109] = {
		reinforce = {
			{
				name = "street",
				force = 3,
				position = Vector3(-3150, -500, 0),
			},
			{
				name = "parking_lot",
				force = 3,
				position = Vector3(200, -1150, 0),
			},
		},
	},
	-- Place the reinforce point near the car crash site
	[101096] = {
		reinforce = {
			{
				name = "pink_car1",
				force = 2,
				position = Vector3(-3100, 1400, 0),
			},
		},
	},
	[101130] = {
		reinforce = {
			{ name = "pink_car1" },
		},
	},
	[101095] = {
		reinforce = {
			{
				name = "pink_car2",
				force = 2,
				position = Vector3(-2100, -1200, 0),
			},
		},
	},
	[101200] = {
		reinforce = {
			{ name = "pink_car2" },
		},
	},
	[101101] = {
		reinforce = {
			{
				name = "pink_car3",
				force = 2,
				position = Vector3(-400, 0, 0),
			},
		},
	},
	[101195] = {
		reinforce = {
			{ name = "pink_car3" },
		},
	},
	[100545] = {
		reinforce = {
			{
				name = "pink_car4",
				force = 2,
				position = Vector3(-4700, -2000, 0),
			},
		},
	},
	[101543] = {
		reinforce = {
			{ name = "pink_car4" },
		},
	},
	-- Spawn point delays
	[100131] = alley_spawn,
	[100007] = roof_spawn,
	[100130] = roof_spawn,
	[101683] = roof_spawn,
	[101820] = roof_spawn,
	[100019] = mortuary_spawn,
}
