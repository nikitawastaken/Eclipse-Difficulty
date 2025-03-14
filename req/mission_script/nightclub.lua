local preferred = Eclipse.preferred
local flank_spawn = {
	values = {
		interval = 15,
	},
}
local window_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local law_team = {
	values = {
		team = "law1",
	},
}
return {
	-- Combine some navigation areas
	[100087] = {
		ai_area = {
			{ 6, 7 },
			{ 8, 10 },
			{ 15, 16 },
			{ 17, 18 },
			{ 19, 20 },
			{ 21, 22 },
			{ 23, 24 },
			{ 38, 39 },
			{ 54, 59 },
			{ 69, 70 },
			{ 13, 68 },
			{ 36, 95 },
			{ 91, 92 },
			{ 32, 33, 34 },
			{ 83, 85, 90 },
		},
	},
	[101169] = {
		reinforce = {
			{
				name = "dance_floor",
				force = 2,
				position = Vector3(2400, -5600, -50),
			},
			{
				name = "street",
				force = 3,
				position = Vector3(1400, -2900, 25),
			},
		},
	},
	-- spawn point delays
	[101046] = flank_spawn,
	[101345] = flank_spawn,
	[100806] = flank_spawn,
	[103174] = window_spawn,
	[104731] = window_spawn,
	-- Dimitri's men are friendly to cops
	[101858] = law_team,
	[101865] = law_team,
	[101927] = law_team,
	[101934] = law_team,
	[102193] = law_team,
	[102200] = law_team,
	[102202] = law_team,
	[102206] = law_team,
	[102617] = law_team,
	[102619] = law_team,
	[100513] = law_team,
	[100517] = law_team,
	[100518] = law_team,
	[100520] = law_team,
	[100522] = law_team,
	[100522] = law_team,
	[100523] = law_team,
	[100528] = law_team,
	[100530] = law_team,
	[100532] = law_team,
	[100534] = law_team,
	[101252] = law_team,
	[102708] = law_team,
	[102709] = law_team,
	[103450] = law_team,
	[103451] = law_team,
	[103452] = law_team,
	[103637] = law_team,
	[103638] = law_team,
	[103639] = law_team,
	[100991] = law_team,
	[100994] = law_team,
	[101100] = law_team,
	[101231] = law_team,
	[101232] = law_team,
	[101233] = law_team,
	[102088] = law_team,
	[102099] = law_team,
}
