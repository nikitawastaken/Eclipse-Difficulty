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
local upper_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- New reinforce
	[100129] = {
		reinforce = {
			{
				name = "containers",
				force = 3,
				position = Vector3(3100, -2400, 500),
			},
			{
				name = "flank_right",
				force = 2,
				position = Vector3(4700, -2600, 400),
			},
			{
				name = "flank_left",
				force = 2,
				position = Vector3(2800, 1000, 0),
			},
			{
				name = "reachstacker1",
				force = 3,
				position = Vector3(-1700, -2300, 200),
			},
			{
				name = "reachstacker2",
				force = 3,
				position = Vector3(3350, -5200, 200),
			},
		},
	},
	-- Disable vanilla reinforce on the trucks
	[100084] = disabled,
	[100086] = disabled,
	[100087] = disabled,
	[100088] = disabled,
	[100089] = disabled,
	[100090] = disabled,
	[100091] = disabled,
	[100092] = disabled,
	[100093] = disabled,
	[100094] = disabled,
	[100095] = disabled,
	[100096] = disabled,
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
	-- Spawn group delays
	[100132] = street_spawn,
	[100133] = street_spawn,
	[100154] = street_spawn,
	[101205] = street_spawn,
	[104938] = street_spawn,
	[100128] = upper_spawn,
	[100131] = upper_spawn,
	[103176] = upper_spawn,
}
