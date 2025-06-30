local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local taser = scripted_enemy.taser_1
local taser_sg = scripted_enemy.taser_2
local tasers = {
	taser,
	taser_sg,
}
local ambush_taser = {
	enemy = tasers,
}
local exclude_shields = {
	so_access_filter = { "cop", "fbi", "swat", "taser", "spooc", "tank" },
}
local exclude_shields_dozers = {
	so_access_filter = { "cop", "fbi", "swat", "taser", "spooc" },
}
local building_spawn = {
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

return {
	-- Instantly enter full force onslaught upon securing all bags
	[100884] = {
		set_ponr_state = true,
	},
	-- Disable the turret
	[101147] = disabled,
	-- New reinforce spots
	[100109] = {
		reinforce = {
			{
				name = "street1",
				force = 3,
				position = Vector3(0, 3600, 0),
			},
			{
				name = "street2",
				force = 3,
				position = Vector3(3000, -900, 0),
			},
		},
	},
	[100990] = {
		reinforce = {
			{
				name = "blonde_car1",
				force = 2,
				position = Vector3(-250, 5150, 0),
			},
		},
	},
	[100991] = {
		reinforce = {
			{
				name = "blonde_car2",
				force = 2,
				position = Vector3(3950, -800, 0),
			},
		},
	},
	[100953] = {
		reinforce = {
			{ name = "blonde_car1" },
			{ name = "blonde_car2" },
		},
	},
	-- Disable hunt
	[102176] = disabled,
	-- e_nl_up_0_75m_dwn_0_25m
	[100073] = exclude_shields,
	[100072] = exclude_shields,
	[100071] = exclude_shields,
	[100068] = exclude_shields,
	[100065] = exclude_shields,
	[100063] = exclude_shields,
	[100062] = exclude_shields,
	[100059] = exclude_shields,
	[100057] = exclude_shields,
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
	-- Spawn point delays
	[100019] = building_spawn,
	[100128] = building_spawn,
	[100131] = building_spawn,
	[100132] = window_spawn,
	[100133] = window_spawn,
	[101598] = escape_spawn,
	[101604] = escape_spawn,
}
