local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local front_spawn = {
	values = {
		interval = 10,
	},
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
return {
	--Add new reinforce
	[100109] = {
		reinforce = { -- Police arrived
			{
				name = "patio",
				force = 3,
				position = Vector3(0, 4750, 100),
			},
			{
				name = "stairs",
				force = 3,
				position = Vector3(25, 600, 0),
			},
		},
	},
	--Delay sanctum preferreds
	[103217] = {
		on_executed = {
			{ id = 103216, delay = 30, delay_rand = 10 },
			{ id = 103493, delay = 30, delay_rand = 10 },
		},
		reinforce = { -- Enable reinforce
			{
				name = "sanctum_left",
				force = 2,
				position = Vector3(-1700, 5000, -275),
			},
			{
				name = "sanctum_right",
				force = 2,
				position = Vector3(2000, 4400, 0),
			},
		},
	},
	[100955] = {
		reinforce = {
			{ name = "sanctum_left" },
			{ name = "sanctum_right" },
		},
	},
	-- Don't kill off enemies in courtyard/patio
	[102903] = disabled,
	[102904] = disabled,
	-- Disable preferred remove elements responsible for removing spawn groups in front of the mansion#
	[100244] = disabled,
	[102899] = disabled,
	[103218] = disabled,
	-- Spawn group delays
	-- This heist has notoriously annoying spawns all over the place.
	[100128] = front_spawn,
	[100130] = front_spawn,
	[100131] = window_spawn,
	[100132] = window_spawn,
	[100133] = window_spawn,
	[103491] = window_spawn,
	[100007] = roof_spawn,
	[103098] = roof_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
	[100852] = cloaker_spawn,
	[100856] = cloaker_spawn,
	[100860] = cloaker_spawn,
	[100864] = cloaker_spawn,
	[100868] = cloaker_spawn,
	[100873] = cloaker_spawn,
}
