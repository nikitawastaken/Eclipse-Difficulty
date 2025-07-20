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
local dozer_chance = (normal and 10 or hard and 15 or 20) + (is_pro_job and 10 or 0)
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
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields,
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
	-- Disable vanilla reinforce on the trucks
	[100084] = disable,
	[100086] = disable,
	[100087] = disable,
	[100088] = disable,
	[100089] = disable,
	[100090] = disable,
	[100091] = disable,
	[100092] = disable,
	[100093] = disable,
	[100094] = disable,
	[100095] = disable,
	[100096] = disable,
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
	-- protection teams (seems to be unused???? Still, it's better to replace it)
	[100522] = gensec,
	[100523] = gensec,
	[100526] = gensec,
	[100527] = gensec,
	[100530] = gensec,
	[100531] = gensec,
	[100532] = gensec,
	[100534] = gensec,
	[100535] = gensec,
	[100536] = gensec,
	[100538] = gensec,
	[100539] = gensec,
	[100540] = gensec,
	[100542] = gensec,
	[100543] = gensec,
	[100544] = gensec,
	[100524] = gensec,
	[100525] = gensec,
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
