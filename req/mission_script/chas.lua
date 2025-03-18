local preferred = Eclipse.preferred
local enabled = {
	values = {
		enabled = true,
	},
}
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local front_spawn = {
	values = {
		interval = 10,
	},
}
local alleyway_spawn = {
	values = {
		interval = 15,
	},
}
local building_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local teashop_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local warehouse_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local scaffolding_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[101190] = {
		reinforce = {
			{
				name = "store_front1",
				force = 3,
				position = Vector3(-2000, 300, -10),
			},
			{
				name = "store_front2",
				force = 3,
				position = Vector3(-1000, 300, -10),
			},
		},
	},
	[101647] = {
		reinforce = {
			{ name = "store_front1" },
			{ name = "store_front2" },
			{
				name = "back_alley",
				force = 3,
				position = Vector3(-1400, 4900, 540),
			},
			{
				name = "tram_street",
				force = 3,
				position = Vector3(2650, 4300, 575),
			},
		},
	},
	--Should fix enemies getting stuck in that certain spawn point
	--Yes, this shit was never fixed since the release of this heist lmao
	[101088] = enabled,
	[101238] = enabled,
	[100999] = enabled,
	[101265] = enabled,
	[101262] = enabled,
	[101264] = enabled,
	--fixed snipers being able to spawn only once
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	[100372] = sniper_trigger_times,
	[100373] = sniper_trigger_times,
	[100374] = sniper_trigger_times,
	[100375] = sniper_trigger_times,
	[100376] = sniper_trigger_times,
	[100377] = sniper_trigger_times,
	-- spawn point delays
	[102713] = front_spawn,
	[100132] = alleyway_spawn,
	[100692] = teashop_spawn,
	[100694] = teashop_spawn,
	[100033] = building_spawn,
	[100693] = building_spawn,
	[101047] = building_spawn,
	[101053] = building_spawn,
	[100019] = warehouse_spawn,
	[101133] = warehouse_spawn,
	[100007] = warehouse_spawn,
	[101201] = warehouse_spawn,
	[100133] = scaffolding_spawn,
	[101006] = scaffolding_spawn,
}
