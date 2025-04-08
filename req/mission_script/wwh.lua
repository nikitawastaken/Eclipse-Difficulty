local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local unused_sniper_trigger_times = {
	values = {
		trigger_times = 0,
		enabled = true,
	},
}
local flank_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local window_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local boat_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[100945] = {
		ponr = {
			length = 900,
			player_mul = { 2, 1.25, 1, 0.8 },
		},
	},
	[100810] = { -- Gradually increase difficulty
		values = {
			difficulty = 0.25
		},
		reinforce = { -- Add some reinforce to make up for the slower spawn groups and lower diff
			{
				name = "roof1",
				force = 2,
				position = Vector3(6675, 2850, 1675),
			},
			{
				name = "roof2",
				force = 2,
				position = Vector3(6700, 600, 1650),
			},
			{
				name = "gate",
				force = 3,
				position = Vector3(1600, 3750, 950),
			},
		},
	},
	[101313] = {
		difficulty = 1
	},
	-- make Snipers respawn and re-enable unused ones
	[100520] = unused_sniper_trigger_times,
	[100525] = sniper_trigger_times,
	[100529] = sniper_trigger_times,
	[100534] = sniper_trigger_times,
	[100540] = unused_sniper_trigger_times,
	[100545] = unused_sniper_trigger_times,
	[100549] = unused_sniper_trigger_times,
	[100553] = sniper_trigger_times,
	[100557] = unused_sniper_trigger_times,
	-- disable the cancer ambush enemy spam that doesn't even work properly
	[100361] = {
		values = {
			enabled = false,
		},
	},
	-- slow down a few spawnpoints
	[100817] = flank_spawn,
	[101024] = flank_spawn,
	[101029] = flank_spawn,
	[100605] = window_spawn,
	[100177] = boat_spawn,
	[100737] = boat_spawn,
}
