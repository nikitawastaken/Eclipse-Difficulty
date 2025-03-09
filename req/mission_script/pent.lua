local preferred = Eclipse.preferred
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local roof_spawn1 = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local ramp_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_bulldozers,
}
local garage_spawn1 = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local pent_balcony_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields,
}
local garage_spawn2 = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local roof_spawn2 = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents_shields,
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local lobby_balcony_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local vent_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[101607] = {
		ponr = {
			length = 180,
			player_mul = { 1.33, 1.15, 1, 0.85 },
		},
	},
	--Fixed snipers being able to spawn only once
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	[100372] = sniper_trigger_times,
	[103595] = {
		reinforce = {
			{
				name = "main_room",
				force = 3,
				position = Vector3(300, -1600, 12100),
			},
		},
	},
	[103831] = {
		reinforce = {
			{ name = "main_room" },
			{
				name = "helipad",
				force = 3,
				position = Vector3(1600, -1600, 13100),
			},
		},
	},
	-- spawn point delays
	[102112] = ramp_spawn,
	[102115] = roof_spawn1,
	[102159] = roof_spawn1,
	[101629] = roof_spawn2,
	[101630] = roof_spawn2,
	[102724] = roof_spawn2,
	[103027] = garage_spawn1,
	[103355] = garage_spawn2,
	[102137] = pent_balcony_spawn,
	[102138] = pent_balcony_spawn,
	[102113] = pent_balcony_spawn,
	[102114] = pent_balcony_spawn,
	[100131] = window_spawn,
	[100694] = window_spawn,
	[100133] = window_spawn,
	[103357] = lobby_balcony_spawn,
	[103381] = lobby_balcony_spawn,
	[100007] = vent_spawn,
}
