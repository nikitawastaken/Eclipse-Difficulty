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
return {
	[103048] = {
		groups = preferred.no_shields_bulldozers,
	},
	-- gangsters
	[100670] = { enemy = bikers },
	[100671] = { enemy = bikers },
	[100672] = { enemy = bikers },
	[100673] = { enemy = bikers },
	[100674] = { enemy = bikers },
	[100675] = { enemy = bikers },
	[100116] = { enemy = bikers },
	[101564] = { enemy = bikers },
	[101571] = { enemy = bikers },
	[101572] = { enemy = bikers },
	[101555] = { enemy = bikers },
	[101556] = { enemy = bikers },
	[101037] = { enemy = bikers },
	[101034] = { enemy = bikers },
	[101222] = { enemy = bikers },
	[101235] = { enemy = bikers },
	[101272] = { enemy = bikers },
	[101274] = { enemy = bikers },
	[101296] = { enemy = bikers },
	[101329] = { enemy = bikers },
	[101355] = { enemy = bikers },
	[101363] = { enemy = bikers },
	[101400] = { enemy = bikers },
	[101310] = { enemy = bikers }, -- camera man
	[101683] = { enemy = bikers },
	[101774] = { enemy = bikers },
	[101866] = { enemy = bikers }, -- camera man
}
