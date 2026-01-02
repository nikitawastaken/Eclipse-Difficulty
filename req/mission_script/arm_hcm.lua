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
	[100129] = {
		reinforce = {
			{
				name = "north",
				force = 3,
				position = Vector3(6650, 800, 1000),
			},
			{
				name = "west",
				force = 3,
				position = Vector3(2400, 2400, 1050),
			},
			{
				name = "east",
				force = 3,
				position = Vector3(2400, -500, 1050),
			},
			{
				name = "south",
				force = 3,
				position = Vector3(-2400, 800, 1000),
			},
		},
	},
	-- tweak the amount of required bags
	[103567] = bags_required,
	[103564] = bags_required,
	[103565] = bags_required,
	[103566] = bags_required,
	[103568] = bags_required,
	[103569] = bags_required,
	[103570] = bags_required,
	[103571] = bags_required,
	[103586] = bags_required,
	[100260] = bags_required,
	[100261] = bags_required,
	[100262] = bags_required,
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
	[103624] = dozer_van_chance,
	[103666] = dozer_van_chance,
	[103667] = dozer_van_chance,
	[103691] = dozer_van_chance,
	[103692] = dozer_van_chance,
	[103693] = dozer_van_chance,
	[103694] = dozer_van_chance,
	[103695] = dozer_van_chance,
	[103696] = dozer_van_chance,
	[103697] = dozer_van_chance,
	[103698] = dozer_van_chance,
	[103699] = dozer_van_chance,
	-- GenSec scripted spawns
	-- van bulldozers
	[103750] = gensec_tank,
	[103751] = gensec_tank,
	[103752] = gensec_tank,
	[103753] = gensec_tank,
	[103754] = gensec_tank,
	[103755] = gensec_tank,
	[103756] = gensec_tank,
	[103757] = gensec_tank,
	[103758] = gensec_tank,
	[103759] = gensec_tank,
	[103760] = gensec_tank,
	[103761] = gensec_tank,
	-- Spawn group intervals
	[100128] = standard_spawn,
	[100130] = standard_spawn,
	[100131] = standard_spawn,
	[100132] = standard_spawn,
	[100981] = standard_spawn,
	[101039] = standard_spawn,
	[101156] = standard_spawn,
}
