local calc_team_ai_wgt = Eclipse.utils.calculate_team_ai_weight
local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local disabled = {
	values = {
		enabled = false,
	},
}
local us_soldiers = { [scripted_enemy.soldier_2] = 4, [scripted_enemy.soldier_2] = 2, [scripted_enemy.soldier_3] = 1 }
local specials_list_eclipse =
	{ [scripted_enemy.taser_1] = 2, [scripted_enemy.cloaker] = 2, [scripted_enemy.cloaker] = 2, [scripted_enemy.elite_bulldozer_1] = 1, [scripted_enemy.elite_bulldozer_2] = 1 }
local specials_list_hard_ovk = { [scripted_enemy.taser_1] = 4, [scripted_enemy.cloaker] = 3, [scripted_enemy.cloaker] = 2, [scripted_enemy.bulldozer_1] = 1, [scripted_enemy.bulldozer_2] = 1 }
local specials_list_easy_normal = { [scripted_enemy.taser_1] = 3, [scripted_enemy.cloaker] = 1 }
local specials = {
	enemy = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse,
}
local us_soldier = {
	enemy = us_soldiers,
}
local us_soldier_dozer = {
	enemy = is_eclipse and scripted_enemy.elite_bulldozer_1 or scripted_enemy.bulldozer_1,
}
local missing_taser_access_fix = {
	so_access_filter = so_access.no_spooc,
}
local filter_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}
local chopper_amount = (is_eclipse and 2 or 1) + (is_pro_job and 1 or 0)
local timbermill_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
}
local hillside_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[103031] = {
		ponr = {
			length = 300,
			length_balance_mul = { 1.5, 1.4, 1, 1 },
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
	-- Don't disable the choppers when you pick up the bomb part
	[104312] = {
		on_executed = {
			{ id = 100374, remove = true },
		},
	},
	-- More choppers on Death Wish and pro jobs
	[101172] = {
		values = {
			amount = chopper_amount,
		},
	},
	-- Increase drama when Snipers spawn
	[100513] = { -- spawn_snipers
		add_drama = {
			amount = 0.2,
			balance_mul = { 1.25, 1, 0.75, 0.5 },
			team_ai_balance_mul_weight = calc_team_ai_wgt(2),
		},
	},
	-- Disable boat escape reinforce
	[100836] = disabled,
	[104120] = disabled,
	-- Restore the woods group
	[101194] = { -- activate_timber_mill_group
		values = {
			spawn_groups = { 100434, 100231 },
		},
	},
	[100372] = { -- heli_enemies
		values = {
			spawn_groups = { 100436, 100434, 100305, 100231 },
		},
	},
	-- Spawn group intervals
	[100231] = { -- unused woods group
		values = {
			enabled = true,
			interval = timbermill_spawn.values.interval,
			interval_balance_mul = timbermill_spawn.values.interval_balance_mul,
		},
	},
	[100434] = timbermill_spawn,
	[100435] = hillside_spawn,
	[100437] = hillside_spawn,
	[100230] = hillside_spawn,
	-- Replace heavy response near the end with US Soldiers
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
	-- Far away from vans
	[101379] = us_soldier_dozer,
	[101380] = us_soldier,
	[101381] = us_soldier,
	[101383] = us_soldier,
	[101384] = us_soldier,
	[101385] = us_soldier,
	[101387] = us_soldier,
	[101388] = us_soldier,
	-- nearby house
	[101363] = us_soldier_dozer,
	[101361] = us_soldier,
	[101367] = us_soldier,
	[101368] = us_soldier,
	[101369] = us_soldier,
	[101371] = us_soldier,
	[101372] = us_soldier,
	[101373] = us_soldier,
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
	-- 4th chopper
	[101163] = us_soldier,
	[101161] = specials,
	[101164] = us_soldier,
	[101162] = specials,
}
