local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local overkill_and_above = Eclipse.utils.diff_threshold()
local bulldozer_1 = scripted_enemy.bulldozer_1
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
local us_soldier_3 = scripted_enemy.soldier_4
local us_soldier_tank = scripted_enemy.elite_bulldozer_1
local us_soldiers = { [us_soldier_1] = 4, [us_soldier_2] = 2, [us_soldier_3] = 1 }
local us_soldier = {
	enemy = us_soldiers,
}
local us_soldier_dozer = {
	enemy = is_eclipse and us_soldier_tank or bulldozer_1,
}
local missing_taser_access_fix = {
	so_access_filter = { "cop", "swat", "tank", "shield", "taser" },
}
local flank_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local timbermill_spawn = {
	values = {
		interval = 30,
	},
}
local woods_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local hillside_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[103031] = {
		ponr = {
			length = 300,
			player_mul = { 1.6, 1.4, 1, 1 },
		},
	},
	-- Delay police response
	[100571] = {
		on_executed = {
			{ id = 100572, delay = 40 },
		},
	},
	-- Slow down difficulty progression
	[100557] = {
		values = {
			difficulty = 0.35,
		},
	},
	[101220] = {
		values = {
			difficulty = 0.65,
		},
	},
	-- fix one of the ai_hunt SOs not having taser access
	[100675] = missing_taser_access_fix,
	-- replace heavy response near the end with US Soldiers
	-- 1st Van (left one)
	[100776] = us_soldier_dozer,
	[100017] = us_soldier,
	[100294] = us_soldier,
	[100295] = us_soldier,
	[100296] = us_soldier,
	[100297] = us_soldier,
	[100298] = us_soldier,
	[100548] = us_soldier,
	[100550] = us_soldier,
	-- 2nd Van (right one)
	[100777] = us_soldier_dozer,
	[100329] = us_soldier,
	[100330] = us_soldier,
	[100333] = us_soldier,
	[100334] = us_soldier,
	[100400] = us_soldier,
	[100550] = us_soldier,
	--Far away from vans
	[101379] = us_soldier_dozer,
	[101380] = us_soldier,
	[101381] = us_soldier,
	[101383] = us_soldier,
	[101384] = us_soldier,
	[101385] = us_soldier,
	[101387] = us_soldier,
	[101388] = us_soldier,
	--nearby house
	[101363] = us_soldier_dozer,
	[101361] = us_soldier,
	[101367] = us_soldier,
	[101368] = us_soldier,
	[101369] = us_soldier,
	[101371] = us_soldier,
	[101372] = us_soldier,
	[101373] = us_soldier,
	-- Spawn group delays
	[100859] = flank_spawn,
	[100889] = flank_spawn,
	[100231] = woods_spawn,
	[100434] = timbermill_spawn,
	[100437] = hillside_spawn,
	[100230] = hillside_spawn,
	[100230] = hillside_spawn,
}
