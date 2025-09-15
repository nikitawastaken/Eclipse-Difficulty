local preferred = Eclipse.preferred
local no_participate = {
	values = {
		participate_to_group_ai = false,
	},
}
local roof_spawn = {
	values = {
		interval = 20,
	},
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
	[101125] = { -- Escape
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
				force = 3,
				position = Vector3(725, 150, 0),
			},
		},
	},
	[100004] = {
		reinforce = {
			{
				name = "entrance2",
				force = 3,
				position = Vector3(825, -3400, -300),
			},
		},
	},
	[100005] = {
		reinforce = {
			{
				name = "entrance3",
				force = 3,
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
	-- make snipers not participate to group ai
	[100602] = no_participate,
	[100603] = no_participate,
	[100604] = no_participate,
	[100605] = no_participate,
	[100606] = no_participate,
	[100369] = no_participate,
	[101627] = no_participate,
	[101628] = no_participate,
	[101236] = no_participate,
	[101237] = no_participate,
	[101238] = no_participate,
	[101239] = no_participate,
	-- Spawn group intervals
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
