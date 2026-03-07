local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local scripted_enemy = Eclipse.scripted_enemy
local taser = scripted_enemy.taser_1
local ambush_taser = {
	enemy = taser,
}
local disabled = {
	values = {
		enabled = false,
	},
}
local exclude_shields_dozers = {
	so_access_filter = so_access.no_heavyweight,
}
local rappel_spawn_far = {
	values = {
		interval = 10,
	},
	groups = preferred.no_cops_agents,
}
local rappel_spawn_close = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.75, 1.5, 1.25, 1 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local filter_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
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
	-- change the vault ambush
	[101382] = filter_easy_above,
	[101388] = filter_disable,
	[101393] = filter_disable,
	[101399] = filter_disable,
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
	-- Replace dozer spam with less stupid enemies
	[101557] = disabled,
	[100567] = disabled,
	[101575] = disabled,
	[101565] = ambush_taser,
	[101176] = ambush_taser,
	[101207] = ambush_taser,
	-- Spawn group intervals
	[100019] = rappel_spawn_far,
	[100128] = rappel_spawn_far,
	[100131] = rappel_spawn_far,
	[100132] = rappel_spawn_close,
	[100133] = rappel_spawn_close,
	[101598] = rappel_spawn_close,
	[101604] = rappel_spawn_close,
}
