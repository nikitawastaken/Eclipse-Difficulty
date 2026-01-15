local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local lower_spawn = {
	values = {
		interval = 15,
	},
}
local escape_spawn = {
	values = {
		interval = 20,
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
		interval = 25,
	},
}
local flank_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
return {
	-- Combine some navigation areas
	[133029] = {
		ai_area = {
			{ 6, 7, 9, 10, 111, 113 },
			{ 27, 28 },
			{ 29, 57 },
			{ 44, 54, 56 },
			{ 45, 46 },
			{ 114, 115 },
		},
	},
	-- Add new reinforce
	[100304] = { -- objective 1 completed
		reinforce = {
			{
				name = "entrance",
				force = 3,
				position = Vector3(-1400, 2700, 0),
			},
			{
				name = "hub",
				force = 3,
				position = Vector3(-150, -1225, 0),
			},
		},
	},
	[100286] = {
		reinforce = {
			{ name = "entrance" },
			{ name = "hub" },
			{
				name = "helipad",
				force = 3,
				position = Vector3(-1200, 5375, 105),
			},
			{
				name = "hub_escape",
				force = 3,
				position = Vector3(25, -350, 0),
			},
		},
		-- add point of no return
		ponr = {
			length = 300,
			player_mul = { 1.6, 1.2, 1, 0.8 },
		},
	},
	[109005] = { -- open door biolab
		reinforce = {
			{
				name = "bio",
				force = 2,
				position = Vector3(-1400, -500, 0),
			},
		},
	},
	[100278] = { -- open door wepaons lab
		reinforce = {
			{
				name = "weapons",
				force = 2,
				position = Vector3(-2150, -2175, 0),
			},
		},
	},
	[108982] = { -- open door archaelogical area
		reinforce = {
			{
				name = "archaelogy",
				force = 2,
				position = Vector3(2225, -2200, 0),
			},
		},
	},
	[108533] = { -- open door computer lab
		reinforce = {
			{
				name = "computer",
				force = 2,
				position = Vector3(1425, -375, 0),
			},
		},
	},
	-- Disable a bunch of cheaty preferreds
	[100919] = disabled, -- weapon preferreds 6
	[101320] = disabled, -- biolab preferreds 6
	[101334] = disabled, -- books preferreds 4
	-- Spawn group intervals
	[102439] = lower_spawn,
	[108291] = escape_spawn,
	[108292] = escape_spawn,
	[107909] = garage_door_spawn,
	[108287] = garage_door_spawn,
	[100128] = upper_spawn,
	[100130] = upper_spawn,
	[100131] = upper_spawn,
	[100132] = upper_spawn,
	[100133] = upper_spawn,
	[100941] = upper_spawn,
	[107911] = upper_spawn,
	[101451] = upper_spawn,
	[102407] = upper_spawn,
	[104794] = upper_spawn,
	[107908] = upper_spawn,
	[107913] = upper_spawn,
	[107975] = upper_spawn,
	[107977] = upper_spawn,
	[107979] = upper_spawn,
	[107980] = upper_spawn,
	[107981] = upper_spawn,
	[107983] = upper_spawn,
	[108290] = upper_spawn,
	[108289] = flank_spawn, -- garage door spawn (escape)
	[101074] = flank_spawn,
	[101350] = flank_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
	[100852] = cloaker_spawn,
	[100856] = cloaker_spawn,
	[100860] = cloaker_spawn,
	[100864] = cloaker_spawn,
	[100868] = cloaker_spawn,
	[100873] = cloaker_spawn,
}
