local preferred = Eclipse.preferred
-- add female bikers to spawn roster
local bikers = {
	Idstring("units/payday2/characters/ene_biker_1/ene_biker_1"),
	Idstring("units/payday2/characters/ene_biker_2/ene_biker_2"),
	Idstring("units/payday2/characters/ene_biker_3/ene_biker_3"),
	Idstring("units/payday2/characters/ene_biker_4/ene_biker_4"),
	Idstring("units/pd2_dlc_born/characters/ene_biker_female_1/ene_biker_female_1"),
	Idstring("units/pd2_dlc_born/characters/ene_biker_female_2/ene_biker_female_2"),
	Idstring("units/pd2_dlc_born/characters/ene_biker_female_3/ene_biker_female_3"),
}
local biker = { enemy = bikers }
local standard_spawn = {
	values = {
		interval = 15,
	},
}
local garage_door_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields,
}
local train_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields,
}
local building_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local window_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local catwalk_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 75,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
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
	-- Add custom preferreds
	[100812] = { -- front preferreds
		on_executed = {
			{ id = 4000037, delay = 0 },
		},
	},
	[101536] = { -- roof preferreds
		on_executed = {
			{ id = 4000038, delay = 0 },
		},
	},
	-- Spawn group delays
	[400006] = standard_spawn,
	[400018] = standard_spawn,
	[400024] = standard_spawn,
	[400036] = standard_spawn,
	[101242] = train_spawn,
	[101240] = train_spawn,
	[101243] = train_spawn,
	[101419] = garage_door_spawn,
	[101426] = garage_door_spawn,	
	[100869] = building_spawn,
	[100877] = building_spawn,
	[400012] = building_spawn,
	[400030] = building_spawn,
	[101114] = window_spawn,
	[101425] = window_spawn,	
	[101512] = catwalk_spawn,
	[101521] = catwalk_spawn,
	[101522] = catwalk_spawn,
	[101523] = catwalk_spawn,
	[101524] = catwalk_spawn,
	[101530] = catwalk_spawn,
	[102651] = roof_spawn,
	[102652] = roof_spawn,	
}
