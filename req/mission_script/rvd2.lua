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
