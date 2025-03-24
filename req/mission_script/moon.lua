local preferred = Eclipse.preferred

local entrance_spawn = {
	values = {
		interval = 15,
	},
}
local roof_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}

return {
	-- New reinforce
	[100768] = { 
		reinforce = {
			{
				name = "santa",
				force = 2,
				position = Vector3(-367, -278, -98),
			},
		},
	},
	[100699] = { 
		reinforce = {
			{
				name = "escalator1",
				force = 2,
				position = Vector3(-900, 250, 400),
			},
			{
				name = "escalator2",
				force = 2,
				position = Vector3(250, -900, 400),
			},
		},
	},
	-- Spawn group delays
	-- This heist is quite compact, so having 0s (5s) spawn groups is a bit overkill, especially when you reach the roof, things get pretty messy up there. 
	[100131] = entrance_spawn,
	[100130] = entrance_spawn,
	[100133] = entrance_spawn,
	[100128] = entrance_spawn,
	[101470] = roof_spawn,
	[100007] = roof_spawn,
	[100019] = roof_spawn,
	[100132] = roof_spawn,
}
