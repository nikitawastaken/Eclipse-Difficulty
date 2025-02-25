local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_pro_job = Eclipse.utils.is_pro_job()

local heavy = scripted_enemy.heavy_swat_2
local bulldozer = scripted_enemy.bulldozer_1
local shield = scripted_enemy.shield

local gangster_outside_amount = {
	values = {
		amount = 3,
		amount_random = 3,
	},
}
local gangster_inside_amount = {
	values = {
		amount = 2,
		amount_random = 2,
	},
}
local gangster_stationary_amount = {
	values = {
		amount = 3,
		amount_random = 0,
	},
}

local heli_enemy1 = {
	values = {
		enemy = heavy,
	},
}
local heli_enemy2 = {
	values = {
		enemy = shield,
	},
}
local heli_enemy3 = {
	values = {
		enemy = bulldozer,
	},
}

local pro_chance_mul = is_pro_job and 1.5 or 1

return {
	-- adjust heli ambush conditions
	[103422] = {
		values = {
			counter_target = 1,
		},
	},
	[103423] = {
		values = {
			counter_target = 2,
		},
	},
	[103424] = {
		values = {
			counter_target = 3,
		},
	},
	[103425] = {
		values = {
			counter_target = 4,
		},
	},
	[103432] = {
		values = {
			chance = 15 * pro_chance_mul,
		},
	},
	[103433] = {
		values = {
			chance = 30 * pro_chance_mul,
		},
	},
	[103434] = {
		values = {
			chance = 45 * pro_chance_mul,
		},
	},
	[103435] = {
		values = {
			chance = 60 * pro_chance_mul,
		},
	},
	[103422] = heli_enemy1,
	[103424] = heli_enemy2,
	[103425] = heli_enemy3,
	[101298] = gangster_outside_amount,
	[101040] = gangster_outside_amount,
	[100918] = gangster_outside_amount,
	[100910] = gangster_outside_amount,
	[100642] = gangster_outside_amount,
	[103254] = gangster_inside_amount,
	[102342] = gangster_inside_amount,
	[103168] = gangster_inside_amount,
	[101306] = gangster_stationary_amount,
	[101046] = gangster_stationary_amount,
	[103553] = {
		values = {
			interval = 10,
		},
		groups = preferred.no_cops_agents_shields,
	},
	[101374] = {
		values = {
			interval = 15,
		},
		groups = preferred.no_cops_agents_shields_bulldozers,
	},
}
