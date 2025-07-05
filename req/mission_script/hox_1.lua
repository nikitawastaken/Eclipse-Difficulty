local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local cop_1 = scripted_enemy.cop_1
local cop_2 = scripted_enemy.cop_2
local cop_3 = scripted_enemy.cop_3
local swat_1 = diff_i < 5 and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = diff_i < 5 and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local sniper = scripted_enemy.sniper
local cops = {
	[cop_1] = 4,
	[cop_3] = 2,
	[cop_2] = 1,
}
local swats = {
	[swat_1] = 3,
	[swat_2] = 3,
	[sniper] = 2,
}
local swat_harasser = {
     enemy = diff_i < 5 and swats or cops
}
local van_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_cops_agents,
}
local street_spawn = {
	values = {
		interval = 10,
	},
}
local avalon_spawn = {
	values = {
		interval = 15,
	},
}
local upper_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- add point of no return
	[100580] = {
		ponr = {
			length = 600,
			player_mul = { 1.8, 1.5, 1.3, 1.2 },
		},
	},
	-- Add new reinforce
	[102850] = { -- in garage
		reinforce = {
			{
				name = "car",
				force = 3,
				position = Vector3(10600, 5500, -2400),
			},
		},
	},
	[102128] = {
		difficulty_add = 0.05,
	},
	-- tweak harassers
	[102029] = swat_harasser,
    [102031] = swat_harasser,
    [102033] = swat_harasser,
    [102035] = swat_harasser,
    [102037] = swat_harasser,
    [102039] = swat_harasser,
    [102041] = swat_harasser,
    [102043] = swat_harasser,
	-- Spawn group delays
	[101719] = street_spawn,
	[101728] = street_spawn,
	[101731] = street_spawn,
	[100128] = van_spawn,
	[100130] = van_spawn,
	[100131] = van_spawn,
	[100132] = van_spawn,
	[101791] = avalon_spawn,
	[101722] = upper_spawn,
	[101725] = upper_spawn,
	[101737] = upper_spawn,
	[101789] = upper_spawn,
	[101734] = upper_spawn,
}
