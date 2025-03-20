local scripted_enemy = Eclipse.scripted_enemy
local overkill_and_above = Eclipse.utils.diff_threshold()
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
--local us_soldier_tank = scripted_enemy.soldier_bulldozer

local us_soldiers = {
	Idstring(us_soldier_1),
	Idstring(us_soldier_1),
	Idstring(us_soldier_1),
	Idstring(us_soldier_2),
}
local us_soldier = {
	enemy = us_soldiers,
}

--local us_soldier_dozer = overkill_and_above and us_soldier_tank

local missing_taser_access_fix = {
	so_access_filter = { "cop", "swat", "tank", "shield", "taser" },
}
return {
	-- fix one of the ai_hunt SOs not having taser access
	[100675] = missing_taser_access_fix,
	-- replace heavy response near the end with US Soldiers
	-- 1st Van (left one)
	--[100776] = { enemy = us_soldier_dozer },
	[100555] = us_soldier,
	[100017] = us_soldier,
	[100294] = us_soldier,
	[100295] = us_soldier,
	[100296] = us_soldier,
	[100297] = us_soldier,
	[100298] = us_soldier,
	[100548] = us_soldier,
	[100767] = us_soldier,
	[100768] = us_soldier,
	-- 2nd Van (right one)
	--[100777] = { enemy = us_soldier_dozer },,
	[100556] = us_soldier,
	[100549] = us_soldier,
	[100764] = us_soldier,
	[100329] = us_soldier,
	[100330] = us_soldier,
	[100333] = us_soldier,
	[100334] = us_soldier,
	[100400] = us_soldier,
	[100550] = us_soldier,
	--Far away from vans
	--[101379] = { enemy = us_soldier_dozer },
	[101377] = us_soldier,
	[101375] = us_soldier,
	[101376] = us_soldier,
	[101380] = us_soldier,
	[101381] = us_soldier,
	[101383] = us_soldier,
	[101384] = us_soldier,
	[101385] = us_soldier,
	[101387] = us_soldier,
	[101388] = us_soldier,
	--nearby house
	--[101363] = { enemy = us_soldier_dozer },
	[101360] = us_soldier,
	[101364] = us_soldier,
	[101365] = us_soldier,
	[101361] = us_soldier,
	[101367] = us_soldier,
	[101368] = us_soldier,
	[101369] = us_soldier,
	[101371] = us_soldier,
	[101372] = us_soldier,
	[101373] = us_soldier,
}
