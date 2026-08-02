local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local ambush_taser = {
	enemy = scripted_enemy.taser_1,
}
local random_dozers = {
	scripted_enemy.bulldozer_1,
	scripted_enemy.bulldozer_2,
}
local random_elite_dozers = {
	scripted_enemy.elite_bulldozer_1,
	scripted_enemy.elite_bulldozer_2,
}
local bulldozer_spawn = {
	enemy = is_eclipse_pro and random_elite_dozers or random_dozers,
}
local shield_spawn = {
	enemy = is_eclipse_pro and scripted_enemy.elite_shield or scripted_enemy.shield,
}
local disabled = {
	values = {
		enabled = false,
	},
}
local exclude_shields_dozers = {
	so_access_filter = so_access.no_heavyweight,
}
local rappel_far_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
	groups = preferred.no_cops_agents,
}
local rappel_close_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}

return {
	-- Instantly enter full force onslaught upon securing all bags
	[100884] = {
		set_ponr_state = true,
	},
	-- New reinforce spots
	[100109] = { -- Police
		reinforce = {
			{
				name = "street01",
				force = 2,
				position = Vector3(1200, 900, 0),
			},
			{
				name = "street02",
				force = 2,
				position = Vector3(825, 3225, 0),
			},
			{
				name = "street03",
				force = 2,
				position = Vector3(2925, 250, 0),
			},
		},
	},
	[100969] = { -- Interacted with zipline 1
		reinforce = {
			{
				name = "zipline",
				force = 2,
				position = Vector3(6550, 5875, 0),
			},
		},
	},
	[100912] = { -- Interacted with zipline 2
		reinforce = {
			{
				name = "zipline",
				force = 2,
				position = Vector3(3550, 4085, 0),
			},
		},
	},
	[100953] = {
		reinforce = {
			{ name = "zipline" },
		},
	},
	-- tweak swat vans
	-- Disable the turret
	[101147] = disabled,
	-- always let 2 swat vans drive in regardless of difficulty
	[101236] = filter_easy_above,
	[101235] = filter_disable,
	-- tweak vault ambush Death Wish filter
	[101393] = {
		on_executed = {
			{ id = 101421, remove = true }, -- remove the 2nd bulldozer spawn
		},
	},
	[101398] = bulldozer_spawn,
	[101418] = shield_spawn,
	[101419] = shield_spawn,
	-- Disable hunt
	[102176] = disabled,
	-- e_nl_over_1_15m
	[101064] = exclude_shields_dozers,
	[101063] = exclude_shields_dozers,
	[101062] = exclude_shields_dozers,
	[101061] = exclude_shields_dozers,
	[101060] = exclude_shields_dozers,
	[101059] = exclude_shields_dozers,
	[101058] = exclude_shields_dozers,
	[101057] = exclude_shields_dozers,
	[101056] = exclude_shields_dozers,
	[101055] = exclude_shields_dozers,
	[101054] = exclude_shields_dozers,
	[101031] = exclude_shields_dozers,
	-- e_nl_over_and_fwd_1m_var2
	[100271] = exclude_shields_dozers,
	[100275] = exclude_shields_dozers,
	[100276] = exclude_shields_dozers,
	[101889] = exclude_shields_dozers,
	-- e_nl_over_and_fwd_1m
	[100272] = exclude_shields_dozers,
	[100273] = exclude_shields_dozers,
	[100274] = exclude_shields_dozers,
	[101031] = exclude_shields_dozers,
	[101054] = exclude_shields_dozers,
	[101055] = exclude_shields_dozers,
	[101887] = exclude_shields_dozers,
	-- Ambush tweaks
	-- Replace dozer spam with less stupid enemies
	[101557] = disabled,
	[100567] = disabled,
	[101575] = disabled,
	[101565] = ambush_taser,
	[101176] = ambush_taser,
	[101207] = ambush_taser,
	-- add the evil ambush group for DWPJ
	[100213] = {
		on_executed = {
			{ id = 400010, delay = 0 },
		},
	},
	-- disable the regular DW filter on DWPJ
	[100222] = is_eclipse_pro and disabled or nil,
	-- Spawn group intervals
	[100019] = rappel_far_spawn,
	[100128] = rappel_far_spawn,
	[100131] = rappel_far_spawn,
	[100132] = rappel_close_spawn,
	[100133] = rappel_close_spawn,
	[101598] = rappel_close_spawn,
	[101604] = rappel_close_spawn,
}
