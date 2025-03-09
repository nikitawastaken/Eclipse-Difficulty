local preferred = Eclipse.preferred
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local helipad_spawn = {
	values = {
		interval = 15,
	},
}
local fueling_area_spawn1 = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local fueling_area_spawn2 = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents,
}
local bridge_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local lab_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local closet_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local drill_room_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[102610] = {
		reinforce = {
			{
				name = "helipad",
				force = 5,
				position = Vector3(4400, 150, 4500),
			},
			{
				name = "well_room",
				force = 3,
				position = Vector3(1250, 50, 4000),
			},
		},
	},
	[101773] = {
		reinforce = {
			{
				name = "fueling_area1",
				force = 2,
				position = Vector3(-3725, -1500, 5300),
			},
			{
				name = "fueling_area2",
				force = 2,
				position = Vector3(-1750, -2450, 5300),
			},
			{
				name = "fueling_area3",
				force = 2,
				position = Vector3(240, -1500, 5300),
			},
		},
	},
	[101830] = {
		reinforce = {
			{ name = "fueling_area1" },
			{ name = "fueling_area2" },
			{ name = "fueling_area3" },
		},
	},
	-- fix snipers being able to spawn only once
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
	[100133] = helipad_spawn,
	[102086] = fueling_area_spawn1,
	[103986] = fueling_area_spawn1,
	[105278] = fueling_area_spawn1,
	[101777] = fueling_area_spawn2,
	[101778] = fueling_area_spawn2,
	[101769] = bridge_spawn,
	[104573] = lab_spawn,
	[100694] = closet_spawn,
	[101779] = drill_room_spawn,
}
