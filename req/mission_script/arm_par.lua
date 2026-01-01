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
				name = "north",
				force = 3,
				position = Vector3(0, -3000, -200),
			},
			{
				name = "south",
				force = 3,
				position = Vector3(1250, 2500, -200),
			},
			{
				name = "west",
				force = 3,
				position = Vector3(2750, -150, -200),
			},
			{
				name = "east",
				force = 3,
				position = Vector3(4500, -150, -150),
			},
		},
	},
	-- tweak the amount of required bags
	[100315] = bags_required,
	[100260] = bags_required,
	[100261] = bags_required,
	[100262] = bags_required,
	[105259] = bags_required,
	[100322] = bags_required,
	[100323] = bags_required,
	[105258] = bags_required,
	[105260] = bags_required,
	[105261] = bags_required,
	[105262] = bags_required,
	[105263] = bags_required,
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
	[101994] = dozer_van_chance,
	[101995] = dozer_van_chance,
	[101996] = dozer_van_chance,
	[101997] = dozer_van_chance,
	[101998] = dozer_van_chance,
	[101999] = dozer_van_chance,
	[102000] = dozer_van_chance,
	[102001] = dozer_van_chance,
	[102002] = dozer_van_chance,
	[102003] = dozer_van_chance,
	[102004] = dozer_van_chance,
	[102005] = dozer_van_chance,
	-- GenSec scripted spawns
	-- van bulldozers
	[102058] = gensec_tank,
	[102068] = gensec_tank,
	[102057] = gensec_tank,
	-- Spawn group intervals
	[100128] = standard_spawn,
	[100132] = standard_spawn,
	[100133] = standard_spawn,
	[100781] = standard_spawn,
	[100794] = standard_spawn,
	[101046] = standard_spawn,
	[101048] = standard_spawn,
	[101202] = standard_spawn,
	[101159] = standard_spawn,
}
