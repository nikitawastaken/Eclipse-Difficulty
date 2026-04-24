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
local pent_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_lower_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local roof_upper_spawn = {
	values = {
		interval = 25,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents_shields,
}
local garage_window_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_shields_bulldozers,
}
local lobby_balcony_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local vent_spawn = {
	values = {
		interval = 60,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
return {
	[100109] = { -- police
		reinforce = {
			{
				name = "lobby",
				force = 3,
				position = Vector3(200, 4200, -75),
			},
			{
				name = "garage",
				force = 3,
				position = Vector3(-600, -1400, -425),
			},
		},
		paused_difficulty_addends = { -- disable addends
			on_entered_regroup = 2,
		},
	},
	[101790] = { -- outside_penthouse
		reinforce = {
			{ name = "lobby" },
			{ name = "garage" },
		},
		paused_difficulty_addends = { -- enable addends
			on_entered_regroup = false,
		},
		on_executed = { -- delay the double door spawn
			{ id = 102109, delay = 30 },
		},
	},
	-- Yufu spawned
	[100765] = {
		forced_difficulty = {
			amount = 0.1,
			time = { 15, 30 },
			delay = 0,
		},
	},
	[101607] = { -- Yufu is dead
		forced_difficulty = false,
		ponr = {
			length = 210,
			length_balance_mul = { 1.25, 1.125, 1, 0.875 },
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
	[100503] = {
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
	-- Spawn group intervals
	[102137] = pent_spawn,
	[102138] = pent_spawn,
	[102113] = pent_spawn,
	[102114] = pent_spawn,
	[100131] = pent_spawn,
	[100694] = pent_spawn,
	[100133] = pent_spawn,
	[102115] = roof_lower_spawn,
	[102159] = roof_lower_spawn,
	[103355] = garage_window_spawn,
	[101629] = roof_upper_spawn,
	[101630] = roof_upper_spawn,
	[102724] = roof_upper_spawn,
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
