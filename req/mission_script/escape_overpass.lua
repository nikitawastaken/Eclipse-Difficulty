local preferred = Eclipse.preferred
local reinforcement_spawn = {
	values = {
		interval = 5,
	},
}
return {
	[101598] = { -- loot link
		difficulty = 1,
	},
	-- Spawn group delays
	[102193] = reinforcement_spawn,
	[102204] = reinforcement_spawn,
	[102213] = reinforcement_spawn,
}
