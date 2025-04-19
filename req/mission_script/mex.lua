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
local wall_spawn = {
	values = {
		interval = 10,
	},
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 120,
	},
}
return {
	-- gangsters
	[100670] = biker,
	[100671] = biker,
	[100672] = biker,
	[100673] = biker,
	[100674] = biker,
	[100675] = biker,
	[100116] = biker,
	[101564] = biker,
	[101571] = biker,
	[101572] = biker,
	[101555] = biker,
	[101556] = biker,
	[101037] = biker,
	[101034] = biker,
	[101222] = biker,
	[101235] = biker,
	[101272] = biker,
	[101274] = biker,
	[101296] = biker,
	[101329] = biker,
	[101355] = biker,
	[101363] = biker,
	[101400] = biker,
	[101310] = biker, -- camera man
	[101683] = biker,
	[101774] = biker,
	[101866] = biker, -- camera man
	-- Spawn group delays
	[100128] = wall_spawn, -- American side
	[100131] = wall_spawn,
	[100132] = wall_spawn,
	[100694] = wall_spawn, -- Mexican side
	[102227] = wall_spawn,
	[102228] = wall_spawn,
	[102254] = wall_spawn,
	[102255] = wall_spawn,
	[102423] = wall_spawn,
	[102424] = wall_spawn,
	[102442] = wall_spawn,
	[103235] = window_spawn,
	[103048] = window_spawn,
	[103067] = window_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
	[100852] = cloaker_spawn,
	[100856] = cloaker_spawn,
	[100860] = cloaker_spawn,
	[100864] = cloaker_spawn,
	[100868] = cloaker_spawn,
	[100873] = cloaker_spawn,
	[102553] = cloaker_spawn,
	[102554] = cloaker_spawn,
	[102555] = cloaker_spawn,
	[102556] = cloaker_spawn,
	[102557] = cloaker_spawn,
	[102558] = cloaker_spawn,
	[102559] = cloaker_spawn,
	[102560] = cloaker_spawn,
}
