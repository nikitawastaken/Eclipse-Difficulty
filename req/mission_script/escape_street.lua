local preferred = Eclipse.preferred
local standard_spawn = {
	values = {
		interval = 10,
	},
}
return {
	[102508] = { -- activte all preferreds
		reinforce = {
			{
				name = "blockade1",
				force = 2,
				position = Vector3(2850, 3200, 0),
			},
			{
				name = "blockade2",
				force = 2,
				position = Vector3(4500, 1500, 0),
			},
			{
				name = "blockade3",
				force = 2,
				position = Vector3(2800, -4500, 0),
			},
		},
	},
	-- Spawn group intervals
	[101630] = standard_spawn,
	[101726] = standard_spawn,
	[102467] = standard_spawn,
	[102475] = standard_spawn,
	[102500] = standard_spawn,
}
