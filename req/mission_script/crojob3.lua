local overkill_and_above = Eclipse.utils.diff_threshold()
local us_soldiers = {
	Idstring("units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2"),
	Idstring("units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2"),
	Idstring("units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2"),
	Idstring("units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3"),
}
local us_soldier_dozer = overkill_and_above and "units/pd2_dlc_army/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"

local missing_taser_access_fix = {
	so_access_filter = { "cop", "swat", "tank", "shield", "taser" },
}
return {
	-- fix one of the ai_hunt SOs not having taser access
	[100675] = missing_taser_access_fix,
	-- replace heavy response near the end with US Soldiers
	-- 1st Van (left one)
	--[100776] = { enemy = us_soldier_dozer },
	[100555] = { enemy = us_soldiers },
	[100017] = { enemy = us_soldiers },
	[100294] = { enemy = us_soldiers },
	[100295] = { enemy = us_soldiers },
	[100296] = { enemy = us_soldiers },
	[100297] = { enemy = us_soldiers },
	[100298] = { enemy = us_soldiers },
	[100548] = { enemy = us_soldiers },
	[100767] = { enemy = us_soldiers },
	[100768] = { enemy = us_soldiers },
	-- 2nd Van (right one)
	--[100777] = { enemy = us_soldier_dozer },,
	[100556] = { enemy = us_soldiers },
	[100549] = { enemy = us_soldiers },
	[100764] = { enemy = us_soldiers },
	[100329] = { enemy = us_soldiers },
	[100330] = { enemy = us_soldiers },
	[100333] = { enemy = us_soldiers },
	[100334] = { enemy = us_soldiers },
	[100339] = { enemy = us_soldiers },
	[100400] = { enemy = us_soldiers },
	[100550] = { enemy = us_soldiers },
	--Far away from vans
	--[101379] = { enemy = us_soldier_dozer },
	[101377] = { enemy = us_soldiers },
	[101375] = { enemy = us_soldiers },
	[101376] = { enemy = us_soldiers },
	[101380] = { enemy = us_soldiers },
	[101381] = { enemy = us_soldiers },
	[101383] = { enemy = us_soldiers },
	[101384] = { enemy = us_soldiers },
	[101385] = { enemy = us_soldiers },
	[101387] = { enemy = us_soldiers },
	[101388] = { enemy = us_soldiers },
	--nearby house
	--[101363] = { enemy = us_soldier_dozer },
	[101360] = { enemy = us_soldiers },
	[101364] = { enemy = us_soldiers },
	[101365] = { enemy = us_soldiers },
	[101361] = { enemy = us_soldiers },
	[101367] = { enemy = us_soldiers },
	[101368] = { enemy = us_soldiers },
	[101369] = { enemy = us_soldiers },
	[101371] = { enemy = us_soldiers },
	[101372] = { enemy = us_soldiers },
	[101373] = { enemy = us_soldiers },
}
