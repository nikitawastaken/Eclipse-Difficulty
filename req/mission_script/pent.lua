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
local ramp_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_bulldozers,
}
local garage_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local pent_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_lower_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local garage_window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local roof_upper_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields,
}
local lobby_balcony_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local vent_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 120,
	},
}
return {
	[101607] = { -- Yufu is dead
		ponr = {
			length = 180,
			player_mul = { 1.33, 1.15, 1, 0.85 },
		},
	},
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
	--Fixed snipers being able to spawn only once
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	[100372] = sniper_trigger_times,
	-- Do not disable certain preferreds when players are on the roof
	[102132] = {
		on_executed = {
			{ id = 102497, remove = true }, -- spawns outside pent
		},
	},
	-- Disable a bunch diff scaling elements
	[102486] = { -- players upstairs, decrease diff temporarily
		values = {
			difficulty = 0.35,
		},
	},
	[102490] = { -- Yufu defeated, max diff
		values = {
			difficulty = 1,
		},
	},
	-- Spawn group delays
	[102112] = ramp_spawn,
	[102115] = roof_lower_spawn,
	[102159] = roof_lower_spawn,
	[101629] = roof_upper_spawn,
	[101630] = roof_upper_spawn,
	[102724] = roof_upper_spawn,
	[103027] = garage_spawn1,
	[103355] = garage_window_spawn,
	[102137] = pent_spawn,
	[102138] = pent_spawn,
	[102113] = pent_spawn,
	[102114] = pent_spawn,
	[100131] = pent_spawn,
	[100694] = pent_spawn,
	[100133] = pent_spawn,
	[103357] = lobby_balcony_spawn,
	[103381] = lobby_balcony_spawn,
	[100007] = vent_spawn,
	[100848] = cloaker_spawn,
	[100852] = cloaker_spawn,
	[100856] = cloaker_spawn,
	[100860] = cloaker_spawn,
	[100864] = cloaker_spawn,
	[100868] = cloaker_spawn,
	[100873] = cloaker_spawn,
	[101869] = cloaker_spawn,
	[104393] = cloaker_spawn,
}
