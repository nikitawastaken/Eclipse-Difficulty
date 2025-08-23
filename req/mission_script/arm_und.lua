local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local gensec_operators = {
	Idstring("units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1"),
	Idstring("units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2"),
}
local scripted_enemy = Eclipse.scripted_enemy
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job
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

local gensec = {
	enemy = overkill_and_above and gensec_operators,
}
local gensec_tank = {
	enemy = gensec_dozer,
}
local dozer_chance = (eclipse and 25 or hard and 15 or 0) + (is_pro_job and 20 or 0)
local dozer_van_chance = {
	chance = dozer_chance,
}
local street_spawn = {
	values = {
		interval = 15,
	},
}
local overpass_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
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
				position = Vector3(-5000, 550, 300),
			},
			{
				name = "west",
				force = 2,
				position = Vector3(1100, 2100, 300),
			},
			{
				name = "east",
				force = 2,
				position = Vector3(-800, -1300, 300),
			},
			{
				name = "south",
				force = 3,
				position = Vector3(6000, 550, 300),
			},
		},
	},
	-- tweak the amount of required bags
	[101705] = bags_required,
	[101707] = bags_required,
	[101724] = bags_required,
	[101736] = bags_required,
	[100831] = bags_required,
	[101066] = bags_required,
	[101552] = bags_required,
	[100822] = bags_required,
	[100315] = bags_required,
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
	[101117] = dozer_van_chance,
	[101118] = dozer_van_chance,
	[101119] = dozer_van_chance,
	[101120] = dozer_van_chance,
	[101121] = dozer_van_chance,
	[101122] = dozer_van_chance,
	[101123] = dozer_van_chance,
	[101124] = dozer_van_chance,
	[101125] = dozer_van_chance,
	[101126] = dozer_van_chance,
	[101127] = dozer_van_chance,
	[101128] = dozer_van_chance,
	-- GenSec scripted spawns
	-- drivers
	[100279] = gensec,
	[100281] = gensec,
	[100280] = gensec,
	[100282] = gensec,
	[100283] = gensec,
	[100284] = gensec,
	[100285] = gensec,
	[100286] = gensec,
	[100287] = gensec,
	[100288] = gensec,
	[100289] = gensec,
	[100290] = gensec,
	[100291] = gensec,
	[100292] = gensec,
	[100293] = gensec,
	[100294] = gensec,
	[100295] = gensec,
	[100296] = gensec,
	[100297] = gensec,
	[100298] = gensec,
	[100299] = gensec,
	[100300] = gensec,
	[100301] = gensec,
	[100302] = gensec,
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
	-- Spawn group delays
	[100128] = street_spawn,
	[100130] = street_spawn,
	[100131] = street_spawn,
	[100132] = overpass_spawn,
	[100133] = overpass_spawn,
}
