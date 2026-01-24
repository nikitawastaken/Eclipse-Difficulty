local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local diff_i = Eclipse.utils.difficulty_index()
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local greendozer_only = {
	green_bulldozer,
}
local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local gensec_dozer = is_eclipse_pro and random_elite_dozers or random_dozers

local gensec_tank = {
	enemy = gensec_dozer,
}
local dozer_chance = (eclipse and 25 or hard and 15 or 0) + (is_pro_job and 20 or 0)
local dozer_van_chance = {
	chance = dozer_chance,
}
local standard_spawn = {
	values = {
		interval = 15,
	},
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
local bags_required = {
	values = {
		amount = normal and 3 or hard and 5 or 7,
	},
}
return {
	-- New reinforce
	[100109] = {
		reinforce = {
			{
				name = "containers",
				force = 2,
				position = Vector3(3100, -2400, 475),
			},
			{
				name = "flank01",
				force = 2,
				position = Vector3(4700, -2550, 400),
			},
			{
				name = "flank02",
				force = 2,
				position = Vector3(2800, 1000, 5),
			},
			{
				name = "reachstacker",
				force = 2,
				position = Vector3(-1700, -2300, 200),
			},
		},
	},
	-- tweak the amount of required bags
	[102745] = bags_required,
	[102746] = bags_required,
	[103351] = bags_required,
	[103362] = bags_required,
	[100260] = bags_required,
	[100261] = bags_required,
	[100262] = bags_required,
	[100315] = bags_required,
	[100322] = bags_required,
	[100323] = bags_required,
	[100512] = bags_required,
	[102738] = bags_required,
	-- Disable vanilla reinforce on the trucks
	[100267] = disabled,
	[100268] = disabled,
	[100269] = disabled,
	[100270] = disabled,
	[100271] = disabled,
	[100272] = disabled,
	[100273] = disabled,
	[100274] = disabled,
	[100275] = disabled,
	[100276] = disabled,
	[100277] = disabled,
	[100278] = disabled,
	-- add more chance for dozers coming out the gensec van
	[104544] = dozer_van_chance,
	[104545] = dozer_van_chance,
	[104546] = dozer_van_chance,
	[104547] = dozer_van_chance,
	[104548] = dozer_van_chance,
	[104549] = dozer_van_chance,
	[104550] = dozer_van_chance,
	[104551] = dozer_van_chance,
	[104552] = dozer_van_chance,
	[104553] = dozer_van_chance,
	[104554] = dozer_van_chance,
	[104555] = dozer_van_chance,
	-- GenSec scripted spawns
	-- van bulldozers
	[100014] = gensec_tank,
	[100162] = gensec_tank,
	[100165] = gensec_tank,
	[100167] = gensec_tank,
	[100168] = gensec_tank,
	[100225] = gensec_tank,
	[100232] = gensec_tank,
	[100235] = gensec_tank,
	[100237] = gensec_tank,
	[100255] = gensec_tank,
	[100325] = gensec_tank,
	[100452] = gensec_tank,
	-- Spawn group intervals
	[100132] = standard_spawn,
	[100133] = standard_spawn,
	[100154] = standard_spawn,
	[101205] = standard_spawn,
	[104938] = standard_spawn,
	[100128] = standard_spawn,
	[100131] = standard_spawn,
	[103176] = standard_spawn,
	[104964] = cloaker_spawn,
	[104965] = cloaker_spawn,
}
