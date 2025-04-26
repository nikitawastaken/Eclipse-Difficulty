local gensec_operators = {
	Idstring("units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1"),
	Idstring("units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2")
}
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
local gensec_dozer = is_eclipse_pro and random_elite_dozers or diff_i > 3 and random_dozers or green_bulldozer
		
local gensec = {
       enemy = overkill_and_above and gensec_operators
}
local gensec_tank = {
       enemy = gensec_dozer
}	

return {
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
	[101768] = gensec_tank
}