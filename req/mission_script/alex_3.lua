local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local mendoza = {
	enemy = {
		Idstring("units/payday2/characters/ene_gang_mexican_1/ene_gang_mexican_1"),
		Idstring("units/payday2/characters/ene_gang_mexican_2/ene_gang_mexican_2"),
		Idstring("units/payday2/characters/ene_gang_mexican_3/ene_gang_mexican_3"),
		Idstring("units/payday2/characters/ene_gang_mexican_4/ene_gang_mexican_4"),
	},
}
local fbi_light = {
	enemy = {
		[scripted_enemy.fbi_2] = 2,
		[scripted_enemy.fbi_1] = 1,
	},
}
local fbi_medium = {
	enemy = {
		[scripted_enemy.ready_team_1] = 2,
		[scripted_enemy.fbi_3] = 1,
	},
}
local fbi_heavy = { enemy = scripted_enemy.ready_team_1 }
local gangster_team = {
	values = {
		team = "law1",
	},
}
local bridge_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local cloaker_spawn = {
	values = {
		interval = 30,
	},
}
return {
	[101284] = { -- activateEscape
		ponr = {
			length = 210,
			length_balance_mul = { 1.5, 1.25, 1.125, 1 },
		},
	},
	-- Infinite assault trigger
	[101122] = { -- 75 (difficulty element)
		hunt = true,
	},
	-- Set gangsters to law team (they are not supposed to shoot the cops)
	[100506] = gangster_team,
	[100507] = gangster_team,
	[100788] = gangster_team,
	[100789] = gangster_team,
	[100790] = gangster_team,
	[100791] = gangster_team,
	[100793] = gangster_team,
	[100794] = gangster_team,
	[100796] = gangster_team,
	[100797] = gangster_team,
	[101124] = gangster_team,
	[101130] = gangster_team,
	[101132] = gangster_team,
	[101138] = gangster_team,
	[101140] = gangster_team,
	[101178] = gangster_team,
	[101179] = gangster_team,
	[101180] = gangster_team,
	[101181] = gangster_team,
	[101182] = gangster_team,
	[101183] = gangster_team,
	[101184] = gangster_team,
	-- Spawn Group delays
	[101145] = bridge_spawn,
	[101156] = bridge_spawn,
	[101162] = bridge_spawn,
	[101173] = bridge_spawn,
	[100973] = cloaker_spawn,
	[100976] = cloaker_spawn,
	[100977] = cloaker_spawn,
	[100978] = cloaker_spawn,
	-- Scripted Mendozas
	-- Rats (day 3)
	[100506] = mendoza,
	[100507] = mendoza,
	[100508] = mendoza,
	[100509] = mendoza,
	[100510] = mendoza,
	[100511] = mendoza,
	-- Car 'Dozas
	[101124] = mendoza,
	[101130] = mendoza,
	[101132] = mendoza,
	[101138] = mendoza,
	[101140] = mendoza,
	[100511] = mendoza,
	-- Scripted FBI guys
	-- "Light" FBI (ene_fbi_3 in vanilla)
	[101111] = fbi_light,
	[101113] = fbi_light,
	[101115] = fbi_light,
	[101117] = fbi_light,
	[101119] = fbi_light,
	[101123] = fbi_light,
	[101125] = fbi_light,
	[101127] = fbi_light,
	[101131] = fbi_light,
	[101133] = fbi_light,
	[101135] = fbi_light,
	[101139] = fbi_light,
	-- "Medium" FBI (ene_fbi_swat_1 in vanilla)
	[101109] = fbi_medium,
	[101121] = fbi_medium,
	[101129] = fbi_medium,
	[101137] = fbi_medium,
	-- "Heavy" FBI (ene_fbi_heavy_1 in vanilla)
	[101110] = fbi_heavy,
	[101120] = fbi_heavy,
	[101128] = fbi_heavy,
	[101136] = fbi_heavy,
}
