local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local taser = scripted_enemy.taser_1
local ambush_taser = {
	enemy = taser,
}
local exclude_shields = {
	so_access_filter = { "cop", "fbi", "swat", "taser", "spooc", "tank" },
}
local exclude_shields_dozers = {
	so_access_filter = { "cop", "fbi", "swat", "taser", "spooc" },
}
local building_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local escape_spawn = {
	values = {
		interval = 45,
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
	-- Disable the turret
	[101147] = disabled,
	-- New reinforce spots
	[100109] = { -- Police
		reinforce = {
			{
				name = "store1",
				force = 3,
				position = Vector3(1200, 900, 0),
			},
			{
				name = "store2",
				force = 3,
				position = Vector3(1250, 3250, 0),
			},
			{
				name = "street3",
				force = 3,
				position = Vector3(3000, 1050, 0),
			},
		},
	},
	[100123] = { -- End assault
		reinforce = {
			{
				name = "boutique1",
				force = 2,
				position = Vector3(2600, 3400, 0),
			},
			{
				name = "boutique2",
				force = 2,
				position = Vector3(2900, 2325, 0),
			},
		},
	},
	[100969] = { -- Interacted with zipline 1
		reinforce = {
			{
				name = "zipline1",
				force = 2,
				position = Vector3(6550, 5875, 0),
			},
		},
	},
	[100912] = { -- Interacted with zipline 2
		reinforce = {
			{
				name = "zipline2",
				force = 2,
				position = Vector3(3550, 4085, 0),
			},
		},
	},
	[100953] = {
		reinforce = {
			{ name = "zipline1" },
			{ name = "zipline2" },
		},
	},
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
	[100019] = building_spawn,
	[100128] = building_spawn,
	[100131] = building_spawn,
	[100132] = window_spawn,
	[100133] = window_spawn,
	[101598] = escape_spawn,
	[101604] = escape_spawn,
}
