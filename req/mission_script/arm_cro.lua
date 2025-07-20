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
		interval = 20,
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
	-- Lower initial diff
	[100122] = {
		values = { 
			difficulty = 0.5, -- diff 65 originally
		},
	},
	-- Vanilla delay is 30s
	[100109] = {
		on_executed = {
			{ id = 100129, delay = 20 },
		},
	},
	-- Delay initial diff
	[100116] = {
		on_executed = {
			{ id = 100122, delay = 45 },
		},
	},
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
	-- Spawn group delays
	[100128] = street_spawn,
	[100130] = street_spawn,
	[100131] = street_spawn,
	[100132] = street_spawn,
	[100133] = street_spawn,
	[101843] = street_spawn,
	[101844] = street_spawn,
	[101845] = street_spawn,
	[101846] = street_spawn,
}
