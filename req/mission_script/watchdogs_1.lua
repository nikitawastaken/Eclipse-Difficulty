local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()

local bulldozer = scripted_enemy.bulldozer_1
local elite_bulldozer = scripted_enemy.elite_bulldozer_1
local shield = scripted_enemy.shield
local elite_shield = scripted_enemy.elite_shield

local van_enemy1 = {
	values = {
		enemy = is_eclipse and elite_bulldozer or bulldozer,
	},
}
local van_enemy2 = {
	values = {
		enemy = is_eclipse and elite_shield or shield,
	},
}

local flank_spawn = {
	values = {
		interval = 10,
	},
}
return {
	-- delay police response
	[100327] = {
		on_executed = {
			{ id = 100768, delay = 30 },
		},
	},
	[101291] = van_enemy1,
	[101298] = van_enemy1,
	[101292] = van_enemy2,
	[101299] = van_enemy2,
	-- spawnpoint delays
	[100767] = flank_spawn,
	[100760] = flank_spawn,
	[102827] = {
		values = {
			interval = 30,
		},
		groups = preferred.no_bulldozers,
	},
	[101687] = {
		values = {
			interval = 40,
		},
		groups = preferred.no_cops_agents_shields_bulldozers,
	},
}
