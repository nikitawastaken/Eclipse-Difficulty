local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local army_guard = scripted_enemy.soldier_1
local security_army = {
	enemy = army_guard,
}
local fence_spawn = {
	values = {
		interval = 15,
	},
}
local upper_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local window_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[104838] = {
		ponr = {
			length = 240,
			player_mul = { 1.25, 1.25, 1, 1 },
		},
	},
	[106867] = {
		values = {
			enabled = false,
		},
	},
	[101882] = { -- add reinforce (loads)
		reinforce = {
			{
				name = "crane1",
				force = 2,
				position = Vector3(-4500, 600, 125),
			},
			{
				name = "crane2",
				force = 2,
				position = Vector3(2100, 550, 125),
			},
			{
				name = "wagon1",
				force = 2,
				position = Vector3(-2900, 2900, 500),
			},
			{
				name = "wagon2",
				force = 2,
				position = Vector3(-3700, 0, 500),
			},
		},
	},
	--National Guard instead of regular security
	[101764] = security_army,
	[101317] = security_army,
	[101318] = security_army,
	[101765] = security_army,
	[101939] = security_army,
	[101940] = security_army,
	[101941] = security_army,
	[101942] = security_army,
	[101943] = security_army,
	[101944] = security_army,
	[102917] = security_army,
	[103678] = security_army,
	[103679] = security_army,
	[103680] = security_army,
	[103681] = security_army,
	[103682] = security_army,
	[103691] = security_army,
	[100051] = security_army,
	[100171] = security_army,
	[101113] = security_army,
	[101238] = security_army,
	[102495] = security_army,
	[102751] = security_army,
	[103303] = security_army,
	[106011] = security_army,
	[106015] = security_army,
	[106019] = security_army,
	[106020] = security_army,
	[106138] = security_army,
	[106141] = security_army,
	-- Spawn group delays
	[100869] = fence_spawn,
	[101574] = fence_spawn,
	[101630] = upper_spawn,
	[101770] = upper_spawn,
	[101771] = upper_spawn,
	[101772] = upper_spawn,
	[102887] = upper_spawn,
	[108179] = upper_spawn,
	[104040] = window_spawn,
}
