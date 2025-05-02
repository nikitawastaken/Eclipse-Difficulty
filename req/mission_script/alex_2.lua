local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local cobra_enemy = {
	Idstring("units/payday2/characters/ene_gang_black_1/ene_gang_black_1"),
	Idstring("units/payday2/characters/ene_gang_black_2/ene_gang_black_2"),
	Idstring("units/payday2/characters/ene_gang_black_3/ene_gang_black_3"),
	Idstring("units/payday2/characters/ene_gang_black_4/ene_gang_black_4"),
}
local cobra = { enemy = cobra_enemy }
local agile_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields_bulldozers,
}
return {
	[104480] = agile_spawn,
	[102793] = agile_spawn,
	-- Sniper gangstas
	[101928] = {
		values = {
			amount = 3,
			amount_random = math.max(diff_i - 2, 0),
		},
	},
	-- Random Cobras
	[100109] = cobra,
	[100576] = cobra,
	[100579] = cobra,
	[101093] = cobra,
	[100094] = cobra,
	[104065] = cobra,
	[104222] = cobra,
	[104223] = cobra,
	[104224] = cobra,
	[104227] = cobra,
	[104162] = cobra,
	[104235] = cobra,
	[104250] = cobra,
	[104252] = cobra,
	[104253] = cobra,
	[104251] = cobra,
	[104255] = cobra,
	[104256] = cobra,
	[104257] = cobra,
	[104259] = cobra,
	[104260] = cobra,
	[104261] = cobra,
	[104263] = cobra,
	[104264] = cobra,
	[104265] = cobra,
	[104267] = cobra,
	[104268] = cobra,
	[104269] = cobra,
	[104270] = cobra,
	[104271] = cobra,
	[104272] = cobra,
	[104273] = cobra,
	[104247] = cobra,
	[104275] = cobra,
	[104276] = cobra,
	[104277] = cobra,
	[104279] = cobra,
	[104280] = cobra,
	[104281] = cobra,
	[104282] = cobra,
	[104283] = cobra,
	[104284] = cobra,
	[104285] = cobra,
	[104287] = cobra,
	[104287] = cobra,
	[104289] = cobra,
	[104290] = cobra,
}
