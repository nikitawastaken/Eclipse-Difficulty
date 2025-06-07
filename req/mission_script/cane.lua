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
		interval = 20,
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
		interval = 25,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 45,
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
	-- Disable wave-based scaling
	[100079] = { -- Initial diff
		values = {
			difficulty = 0.25,
		},
	},
	[100080] = disabled,
	[100084] = disabled,
	[101139] = { -- Present finished
		difficulty_add = 0.05,
	},
	-- Introduce preferreds gradually
	[100812] = { -- front basic
		on_executed = {
			{ id = 400037, delay = 0 }, -- eclipse front entrance
		},
	},
	[100806] = { -- Link
		on_executed = {
			{ id = 101367, remove = true }, -- back basic
		},
	},
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
	[101043] = { -- 1 wave passed
		on_executed = {
			{ id = 101367, delay = 10, delay_rand = 20 }, -- back basic
		},
	},
	[101152] = { -- 2 waves passed
		on_executed = {
			{ id = 101427, delay = 10, delay_rand = 20 }, -- side basic
			{ id = 400038, delay = 10, delay_rand = 20 }, -- eclipse front buildings
		},
	},
	[101153] = { -- 3 waves passed
		on_executed = {
			{ id = 101536, delay = 10, delay_rand = 20 }, -- roof basics
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
	[101512] = roof_spawn,
	[101521] = roof_spawn,
	[101522] = roof_spawn,
	[101523] = roof_spawn,
	[101524] = roof_spawn,
	[101530] = roof_spawn,
	[102651] = roof_spawn,
	[102652] = roof_spawn,
}
