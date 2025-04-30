local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local headless_dozer_black = scripted_enemy.headless_bulldozer_1
local headless_dozer_white = scripted_enemy.headless_bulldozer_2
local headless_tanks = is_eclipse and { [headless_dozer_black] = 3, [headless_dozer_white] = 1 } or headless_dozer_black
local headless_tank = {
	enemy = headless_tanks,
	values = {
		participate_to_group_ai = true,
	},
}
local ledge_spawn = {
	values = {
		interval = 20,
	},
	
}
return {
	[100342] = headless_tank,
	[100343] = headless_tank,
	[100344] = headless_tank,
	[100345] = headless_tank,
	[100346] = headless_tank,
	[100347] = headless_tank,
	[100348] = headless_tank,
	[100349] = headless_tank,
	[100350] = headless_tank,
	-- Spawn group delays
	[101601] = ledge_spawn,	
	[101603] = ledge_spawn,	
	[101604] = ledge_spawn,	
	[101605] = ledge_spawn,	
	[101607] = ledge_spawn,	
	[101501] = ledge_spawn,	
	[101799] = ledge_spawn,	
	[101800] = ledge_spawn,	
	[101801] = ledge_spawn,	
}
