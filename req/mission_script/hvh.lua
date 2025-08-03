local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local upper_spawn = {
	values = {
		interval = 15,
	},
}
local close_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
return {
	-- Increase difficulty when a safe is breached
	[101127] = { 
		difficulty_add = 0.15,
	},
	-- Spawn group delays
	-- This heist is microscopic, thankfully whoever was setting up these spawns bothered to set them to 15s intervals.
	-- That said, some of them could be slower because they are bit closer to player holdout areas.
	[100651] = upper_spawn,
	[101005] = upper_spawn,
	[101010] = upper_spawn,
	[100211] = close_spawn,
	[101007] = close_spawn,
	[101009] = close_spawn,
}
