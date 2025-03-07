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
	on_executed = {
		{ id = 103457, delay = 0 },
	},
}
local heli_enemy2 = {
	values = {
		enemy = shield,
	},
	on_executed = {
		{ id = 103456, delay = 0 },
	},
}
local heli_enemy3 = {
	values = {
		enemy = bulldozer,
	},
	on_executed = {
		{ id = 103455, delay = 0 },
	},
}
local heli_enemy4 = {
	values = {
		participate_to_group_ai = false,
	},
}

local pro_chance_mul = is_pro_job and 1.5 or 1
local swat_shield_dozer_filter = {
	so_access_filter = { "swat", "shield", "tank" },
}

return {
	-- adjust FBI chopper ambush
	[103432] = {
		on_executed = {
			{ id = 103437, remove = true },
		},
	},
	[103433] = {
		on_executed = {
			{ id = 103437, remove = true },
		},
	},
	[103434] = {
		on_executed = {
			{ id = 103437, remove = true },
		},
	},
	[103435] = {
		on_executed = {
			{ id = 103437, remove = true },
		},
	},
	[103136] = {
		on_executed = {
			{ id = 103437, delay = 0 },
		},
	},
	[103422] = heli_enemy1,
	[103422] = heli_enemy4,
	[103424] = heli_enemy2,
	[103425] = heli_enemy3,
	[103455] = swat_shield_dozer_filter,
	[103456] = swat_shield_dozer_filter,
	[103457] = swat_shield_dozer_filter,
	-- restore unused snipers
	[102569] = {
		on_executed = {
			{ id = 101907, delay = 120 },
		},
	},
	-- fix tower sniper not using SOs
	[101905] = {
		on_executed = {
			{ id = 101906, delay = 0 },
			{ id = 101908, delay = 0 },
		},
	},
	-- tweak gangsters amount
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
	-- group tweaks
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
