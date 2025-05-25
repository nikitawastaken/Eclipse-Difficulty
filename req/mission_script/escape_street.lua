local preferred = Eclipse.preferred
local initial_diff = {
	values = {
		difficulty = 0.5,
	},
}
local reinforcement_spawn = {
	values = {
		interval = 10,
	},
}
return {
	[101831] = initial_diff,
	[102461] = initial_diff,
	[101968] = { -- waiting done
		difficulty = 0.75,
	},
	[101976] = { -- escape link
		difficulty = 1,
	},
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
	-- Spawn group delays
	[101630] = reinforcement_spawn,
	[101726] = reinforcement_spawn,
	[102467] = reinforcement_spawn,
	[102475] = reinforcement_spawn,
	[102500] = reinforcement_spawn,
}
