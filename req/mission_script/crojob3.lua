local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local bulldozer_1 = scripted_enemy.bulldozer_1
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
local us_soldier_3 = scripted_enemy.soldier_4
local us_soldier_tank = scripted_enemy.elite_bulldozer_1
local us_soldiers = { [us_soldier_1] = 4, [us_soldier_2] = 2, [us_soldier_3] = 1 }
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
local specials_list_eclipse = { [taser] = 2, [medic] = 2, [cloaker] = 2, [elite_ben_bulldozer] = 1, [elite_skull_bulldozer] = 1 }
local specials_list_hard_ovk = { [taser] = 4, [medic] = 3, [cloaker] = 2, [green_bulldozer] = 1, [black_bulldozer] = 1 }
local specials_list_easy_normal = { [taser] = 3, [cloaker] = 1 }
local specials = {
	enemy = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse,
}
local us_soldier = {
	enemy = us_soldiers,
}
local us_soldier_dozer = {
	enemy = is_eclipse and us_soldier_tank or bulldozer_1,
}
local disabled = {
	values = {
		enabled = false,
	},
}
local missing_taser_access_fix = {
	so_access_filter = { "cop", "swat", "tank", "shield", "taser" },
}
local filter_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}
local chopper_amount = (is_eclipse and 2 or 1) + (is_pro_job and 1 or 0)
local forest_reinforce_amount = {
	values = {
		amount = 3,
	},
}
local timbermill_spawn = {
	values = {
		interval = 15,
	},
}
local hillside_spawn = {
	values = {
		interval = 45,
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
	-- fix one of the ai_hunt SOs not having taser access
	[100675] = missing_taser_access_fix,
	-- replace scripted spawns that drop from choppa with US Soldiers and specials
	-- filters (to keep it clean)
	[104152] = filter_easy_above,
	[104153] = filter_easy_above,
	[104156] = filter_easy_above,
	[104147] = filter_disable,
	[104148] = filter_disable,
	[104154] = filter_disable,
	[104155] = filter_disable,
	[104157] = filter_disable,
	[104158] = filter_disable,
	-- 1 and 3 dummies are soldiers, the rest are specials (similiar to Train Heist)
	-- 1st chopper
	[101177] = us_soldier,
	[101174] = specials,
	[101176] = us_soldier,
	[101175] = specials,
	-- 2nd chopper
	[104176] = us_soldier,
	[104177] = specials,
	[104174] = us_soldier,
	[104175] = specials,
	-- 3rd chopper
	[100484] = us_soldier,
	[100485] = specials,
	[100482] = us_soldier,
	[100479] = specials,
	-- don't disable the choppers when you pick up the bomb part
	[104312] = {
		on_executed = {
			{ id = 100374, remove = true },
		},
	},
	-- more choppers on eclipse and pro jobs
	[101172] = {
		values = {
			amount = chopper_amount,
		},
	},
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
	-- Increase reinforce force
	[104319] = forest_reinforce_amount,
	[104318] = forest_reinforce_amount,
	-- Disable boat escape reinforce
	[100836] = disabled,
	[104120] = disabled,
	-- Restore the woods group
	[101194] = { -- activate timber mill
		values = {
			spawn_groups = { 100231, 100434 },
		},
	},
	-- Spawn group delays
	[100231] = timbermill_spawn,
	[100434] = timbermill_spawn,
	[100435] = hillside_spawn,
	[100437] = hillside_spawn,
	[100230] = hillside_spawn,
}
