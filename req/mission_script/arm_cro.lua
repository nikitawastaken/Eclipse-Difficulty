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
		interval = 20,
	},
}
local bags_required = {
	values = {
		amount = normal and 3 or hard and 5 or 7,
	},
}
return {
	-- New reinforce
	[100129] = {
		reinforce = {
			{
				name = "north",
				force = 3,
				position = Vector3(0, -3200, 0),
			},
			{
				name = "west",
				force = 3,
				position = Vector3(3200, 0, 0),
			},
			{
				name = "east",
				force = 3,
				position = Vector3(-3200, 0, 0),
			},
			{
				name = "south",
				force = 3,
				position = Vector3(0, 3200, 0),
			},
		},
	},
	-- Vanilla delay is 30s
	[100109] = {
		on_executed = {
			{ id = 100129, delay = 45 },
		},
	},
	-- tweak the amount of required bags
	[100316] = bags_required,
	[100322] = bags_required,
	[100323] = bags_required,
	[101171] = bags_required,
	[101159] = bags_required,
	[101160] = bags_required,
	[101161] = bags_required,
	[101162] = bags_required,
	[100315] = bags_required,
	[101168] = bags_required,
	[101169] = bags_required,
	[101170] = bags_required,
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
	[101700] = dozer_van_chance,
	[101701] = dozer_van_chance,
	[101702] = dozer_van_chance,
	[101703] = dozer_van_chance,
	[101704] = dozer_van_chance,
	[101705] = dozer_van_chance,
	[101706] = dozer_van_chance,
	[101707] = dozer_van_chance,
	[101708] = dozer_van_chance,
	[101709] = dozer_van_chance,
	[101710] = dozer_van_chance,
	-- GenSec scripted spawns
	-- van bulldozers
	[101747] = gensec_tank,
	[101748] = gensec_tank,
	[101759] = gensec_tank,
	[101760] = gensec_tank,
	[101761] = gensec_tank,
	[101762] = gensec_tank,
	[101763] = gensec_tank,
	[101764] = gensec_tank,
	[101765] = gensec_tank,
	[101766] = gensec_tank,
	[101767] = gensec_tank,
	[101768] = gensec_tank,
	-- Spawn group intervals
	[100128] = standard_spawn,
	[100130] = standard_spawn,
	[100131] = standard_spawn,
	[100132] = standard_spawn,
	[100133] = standard_spawn,
	[101843] = standard_spawn,
	[101844] = standard_spawn,
	[101845] = standard_spawn,
	[101846] = standard_spawn,
}
