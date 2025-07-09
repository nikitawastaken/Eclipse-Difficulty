local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local escape_spawn = {
	values = {
		interval = 15,
	},
}
local garage_door_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local upper_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local flank_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_shields_bulldozers,
}
local catwalk_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[100286] = {
		reinforce = {
			{ name = "main_hall" },
		},
		-- add point of no return
		ponr = {
			length = 300,
			player_mul = { 1.6, 1.2, 1, 0.8 },
		},
	},
	[100304] = {
		reinforce = {
			{
				name = "main_hall",
				force = 5,
				position = Vector3(-120, -2400, 100),
			},
		},
	},
	-- Disable a bunch of cheaty preferreds
	[100919] = disabled, -- weapon preferreds 6
	[101320] = disabled, -- biolab preferreds 6
	[101334] = disabled, -- books preferreds 4
	[101334] = disabled, -- books preferreds 4
	[108442] = disabled, -- entrance preferreds 3
	-- Spawn group delays
	[108291] = escape_spawn,
	[108292] = escape_spawn,
	[107909] = garage_door_spawn,
	[108287] = garage_door_spawn,
	[108289] = garage_door_spawn,
	[100128] = upper_spawn,
	[100130] = upper_spawn,
	[100131] = upper_spawn,
	[100132] = upper_spawn,
	[100133] = upper_spawn,
	[100941] = upper_spawn,
	[107911] = upper_spawn,
	[101451] = upper_spawn,
	[102407] = upper_spawn,
	[107908] = upper_spawn,
	[107913] = upper_spawn,
	[107975] = upper_spawn,
	[107977] = upper_spawn,
	[107979] = upper_spawn,
	[107980] = upper_spawn,
	[107981] = upper_spawn,
	[107983] = upper_spawn,
	[108290] = upper_spawn,
	[104794] = flank_spawn,
	[101074] = catwalk_spawn,
	[101350] = catwalk_spawn,
}
