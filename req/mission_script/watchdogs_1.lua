local scripted_enemy = Eclipse.scripted_enemy
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
			{ id = 100768, delay = 30 }
		}
	},
	[101291] = van_enemy_01,
	[101298] = van_enemy_01,
	[101292] = van_enemy_02,
	[101299] = van_enemy_02,
	-- spawnpoint delays
	[100767] = flank_spawn,
	[100760] = flank_spawn,
	[102827] = {
		values = {
			interval = 30,
		},
		groups = {
			tac_bull_rush = false,
		},
	},
	[101687] = {
		values = {
			interval = 40,
		},
		groups = {
			tac_shield_wall = false,
			tac_shield_wall_ranged = false,
			tac_shield_wall_charge = false,
			tac_bull_rush = false,
		},
	},
}