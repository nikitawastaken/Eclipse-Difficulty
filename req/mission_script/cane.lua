local preferred = Eclipse.preferred
local biker_enemy = { -- add female bikers to spawn roster
	["units/payday2/characters/ene_biker_1/ene_biker_1"] = 5,
	["units/payday2/characters/ene_biker_2/ene_biker_2"] = 5,
	["units/payday2/characters/ene_biker_3/ene_biker_3"] = 5,
	["units/payday2/characters/ene_biker_4/ene_biker_4"] = 5,
	--["units/pd2_dlc_born/characters/ene_biker_female_1/ene_biker_female_1"] = 2,
	--["units/pd2_dlc_born/characters/ene_biker_female_2/ene_biker_female_2"] = 2,
	--["units/pd2_dlc_born/characters/ene_biker_female_3/ene_biker_female_3"] = 2,
}
local biker = { enemy = biker_enemy }
local front_spawn = {
	values = {
		interval = 10,
	},
}
local back_spawn = {
	values = {
		interval = 15,
	},
}
local front_agile_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local side_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields,
}
local side_agile_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Remove a bunch of spawn groups from preferreds to debloat the map.
	[100812] = { -- front_basic
		values = {
			spawn_groups = { -- Removed group(s): 101114, 100845
				100869,
				100877,
				400006,
				400012,
			},
		},
	},
	[101427] = { -- side_basic
		values = {
			spawn_groups = { -- Removed group(s): 101426
				101419,
				101425,
			},
		},
	},
	[101536] = { -- roof_basics
		values = {
			spawn_groups = { -- Removed group(s): 101523, 101530, 101521
				101512,
				101522,
				101524,
			},
		},
	},
	-- Introduce preferreds gradually
	[100810] = { -- Link
		on_executed = {
			{ id = 101427, remove = true }, -- side basic
		},
	},
	[100811] = { -- Link
		on_executed = {
			{ id = 101536, remove = true }, -- roof basics
		},
	},
	[101043] = { -- 1 waves passed
		on_executed = {
			{ id = 101427, delay = 0, delay_rand = 40 }, -- side basic
		},
	},
	[101152] = { -- 2 waves passed
		on_executed = {
			{ id = 101536, delay = 0, delay_rand = 40 }, -- roof basics
		},
	},
	-- swap out start_assault link with end_assault
	[100581] = {
		on_executed = {
			{ id = 100767, remove = true },
		},
	},
	[100405] = {
		on_executed = {
			{ id = 101155, remove = true },
			{ id = 100767, delay = 0 },
		},
	},
	-- Tweak one of the back spawngroups
	[102374] = {
		values = {
			interval = back_spawn.interval,
			elements = {
				101178,
				101177,
				101175,
				101174,
				101172,
			},
		},
	},
	-- Spawn group intervals
	[400006] = front_spawn,
	[400012] = front_spawn,
	[101240] = back_spawn,
	[101242] = back_spawn,
	[101243] = back_spawn,
	[101245] = back_spawn,
	[100869] = front_agile_spawn,
	[100877] = front_agile_spawn,
	[101419] = side_spawn,
	[101426] = side_spawn,
	[101425] = side_agile_spawn,
	[101512] = roof_spawn,
	[101521] = roof_spawn,
	[101522] = roof_spawn,
	[101523] = roof_spawn,
	[101524] = roof_spawn,
	[101530] = roof_spawn,
	[102651] = roof_spawn,
	[102652] = roof_spawn,
	-- gangsters
	[101547] = biker,
	[101555] = biker,
	[101605] = biker,
	[101609] = biker,
	[102011] = biker,
	[102016] = biker,
	[102028] = biker,
	[102031] = biker,
	[102035] = biker,
	[102527] = biker,
	[102529] = biker,
	[102531] = biker,
	[102535] = biker,
}
