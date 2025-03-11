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
	-- gangsters
	[101547] = { enemy = bikers },
	[101555] = { enemy = bikers },
	[101605] = { enemy = bikers },
	[101609] = { enemy = bikers },
	[102011] = { enemy = bikers },
	[102016] = { enemy = bikers },
	[102028] = { enemy = bikers },
	[102031] = { enemy = bikers },
	[102035] = { enemy = bikers },
	[102527] = { enemy = bikers },
	[102529] = { enemy = bikers },
	[102531] = { enemy = bikers },
	[102535] = { enemy = bikers },
}
