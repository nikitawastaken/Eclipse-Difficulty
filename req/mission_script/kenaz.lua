local preferred = Eclipse.preferred
local skylight_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[100379] = {
		reinforce = {
			{
				name = "security",
				force = 3,
				position = Vector3(125, 1575, 100),
			},
		},
	},
	-- Spawn group delays
	[103218] = skylight_spawn,
}
