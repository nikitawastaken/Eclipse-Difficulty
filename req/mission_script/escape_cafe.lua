local preferred = Eclipse.preferred
local reinforcement_spawn = {
	values = {
		interval = 5,
	},
}
local roof_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
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
