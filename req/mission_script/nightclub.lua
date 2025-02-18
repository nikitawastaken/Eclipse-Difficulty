local preferred = Eclipse.preferred
local flank_spawn = {
	values = {
		interval = 15
	}
}
local window_spawn = {
	values = {
		interval = 45
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[101169] = {
		reinforce = {
			{
				name = "dance_floor",
				force = 2,
				position = Vector3(2400, -5600, -50)
			},
			{
				name = "street",
				force = 3,
				position = Vector3(1400, -2900, 25)
			},
		}
	},
	-- spawn point delays
	[101046] = flank_spawn,
	[101345] = flank_spawn,
	[100806] = flank_spawn,
	[103174] = window_spawn,
	[104731] = window_spawn,
}