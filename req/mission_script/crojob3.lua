local scripted_enemy = Eclipse.scripted_enemy
local overkill_and_above = Eclipse.utils.diff_threshold()
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
--local us_soldier_tank = scripted_enemy.soldier_bulldozer
--[[
local us_soldiers = {
	us_soldier_1,
	us_soldier_1,
	us_soldier_1,
	us_soldier_2,
}
]]
--
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
	[100555] = { enemy = us_soldier_1 },
	[100017] = { enemy = us_soldier_1 },
	[100294] = { enemy = us_soldier_1 },
	[100295] = { enemy = us_soldier_2 },
	[100296] = { enemy = us_soldier_2 },
	[100297] = { enemy = us_soldier_2 },
	[100298] = { enemy = us_soldier_2 },
	[100548] = { enemy = us_soldier_1 },
	[100767] = { enemy = us_soldier_1 },
	[100768] = { enemy = us_soldier_1 },
	-- 2nd Van (right one)
	--[100777] = { enemy = us_soldier_dozer },,
	[100556] = { enemy = us_soldier_1 },
	[100549] = { enemy = us_soldier_1 },
	[100764] = { enemy = us_soldier_1 },
	[100329] = { enemy = us_soldier_2 },
	[100330] = { enemy = us_soldier_2 },
	[100333] = { enemy = us_soldier_2 },
	[100334] = { enemy = us_soldier_2 },
	[100339] = { enemy = us_soldier_1 },
	[100400] = { enemy = us_soldier_1 },
	[100550] = { enemy = us_soldier_1 },
	--Far away from vans
	--[101379] = { enemy = us_soldier_dozer },
	[101377] = { enemy = us_soldier_1 },
	[101375] = { enemy = us_soldier_1 },
	[101376] = { enemy = us_soldier_1 },
	[101380] = { enemy = us_soldier_2 },
	[101381] = { enemy = us_soldier_2 },
	[101383] = { enemy = us_soldier_2 },
	[101384] = { enemy = us_soldier_2 },
	[101385] = { enemy = us_soldier_1 },
	[101387] = { enemy = us_soldier_1 },
	[101388] = { enemy = us_soldier_1 },
	--nearby house
	--[101363] = { enemy = us_soldier_dozer },
	[101360] = { enemy = us_soldier_1 },
	[101364] = { enemy = us_soldier_1 },
	[101365] = { enemy = us_soldier_1 },
	[101361] = { enemy = us_soldier_2 },
	[101367] = { enemy = us_soldier_2 },
	[101368] = { enemy = us_soldier_2 },
	[101369] = { enemy = us_soldier_2 },
	[101371] = { enemy = us_soldier_1 },
	[101372] = { enemy = us_soldier_1 },
	[101373] = { enemy = us_soldier_1 },
}
