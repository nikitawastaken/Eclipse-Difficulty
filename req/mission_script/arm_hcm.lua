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
		interval = 10,
	},
}
local elevator_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields,
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
	-- Lower initial diff
	[100122] = {
		values = {
			difficulty = 0.5, -- diff 65 originally
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
	[100132] = street_spawn,
	[100981] = elevator_spawn,
	[101039] = elevator_spawn,
	[101156] = elevator_spawn,
}
