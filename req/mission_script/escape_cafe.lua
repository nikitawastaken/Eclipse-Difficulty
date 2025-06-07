local preferred = Eclipse.preferred
local initial_diff = {
	values = {
		difficulty = 0.33,
	},
}
local reinforcement_spawn = {
	values = {
		interval = 10,
	},
}
local roof_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[100251] = initial_diff,
	[101378] = initial_diff,
	[101181] = { -- enable roof preferreds and Snipers
		difficulty = 0.66,
	},
	-- Loot secure difficulty spike
	[100993] = {
		values = {
			difficulty = 1,
		},
	},
	[101377] = { -- enable main preferreds
		reinforce = {
			{
				name = "blockade1",
				force = 2,
				position = Vector3(-550, -5675, 550),
			},
			{
				name = "blockade2",
				force = 2,
				position = Vector3(-5800, -150, 550),
			},
			{
				name = "blockade3",
				force = 2,
				position = Vector3(800, 5250, 550),
			},
		},
	},
	-- Spawn group delays
	[101348] = reinforcement_spawn,
	[101359] = reinforcement_spawn,
	[102060] = reinforcement_spawn,
	[101200] = roof_spawn,
}
