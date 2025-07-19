local preferred = Eclipse.preferred
local roof_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local agile_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local shaft_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_shields_bulldozers,
}
return {
	[100119] = {
		set_ponr_state = true,
	},
	[101483] = {
		values = {
			enabled = false,
		},
	},
	[100472] = { -- Spawned
		values = {
			difficulty = 0.5,
		},
	},
	[101144] = { -- Airlock
		values = {
			difficulty = 0.75,
		},
	},
	[101125] = { -- Escape
		difficulty = 1,
		reinforce = {
			{
				name = "gate",
				force = 3,
				position = Vector3(-11000, -6800, 7000),
			},
			{
				name = "what_a_nice_car",
				force = 3,
				position = Vector3(-11200, 400, 7400),
			},
		},
	},
	--add reinforce
	[100003] = {
		reinforce = {
			{
				name = "entrance1",
				force = 2,
				position = Vector3(725, 150, 0),
			},
		},
	},
	[100004] = {
		reinforce = {
			{
				name = "entrance2",
				force = 2,
				position = Vector3(825, -3400, -300),
			},
		},
	},
	[100005] = {
		reinforce = {
			{
				name = "entrance3",
				force = 2,
				position = Vector3(2780, -4615, 0),
			},
		},
	},
	[100085] = {
		reinforce = {
			{ name = "entrance1" },
		},
	},
	[100086] = {
		reinforce = {
			{ name = "entrance2" },
		},
	},
	[100087] = {
		reinforce = {
			{ name = "entrance3" },
		},
	},
	[101027] = {
		reinforce = {
			{
				name = "demeter",
				force = 2,
				position = Vector3(-12645, -1165, -900),
			},
			{
				name = "hades",
				force = 2,
				position = Vector3(-9235, -490, -900),
			},
			{
				name = "ares",
				force = 2,
				position = Vector3(-8765, -5100, -900),
			},
			{
				name = "chronos",
				force = 2,
				position = Vector3(-11170, -3015, -900),
			},
			{
				name = "zeus",
				force = 2,
				position = Vector3(-7080, -4205, -900),
			},
			{
				name = "poseidon",
				force = 2,
				position = Vector3(-7100, -2950, -900),
			},
		},
	},
	[101434] = {
		reinforce = {
			{ name = "demeter" },
			{ name = "hades" },
			{ name = "ares" },
			{ name = "chronos" },
			{ name = "zeus" },
			{ name = "poseidon" },
		},
	},
	[100437] = roof_spawn,
	[100438] = roof_spawn,
	[100455] = agile_spawn,
	[100454] = agile_spawn,
	[100451] = agile_spawn,
	[100450] = agile_spawn,
	[100519] = agile_spawn,
	[100440] = agile_spawn,
	[101196] = shaft_spawn,
}
