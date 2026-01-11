local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local standard_spawn = {
	values = {
		interval = 20,
	},
}
return {
	-- Increase difficulty when a safe is breached or you fail to open the safe
	[101127] = {
		difficulty_add = 0.2,
	},
	[100244] = {
		difficulty_add = 0.2,
	},
	-- Spawn group intervals
	-- This heist is microscopic, thankfully whoever was setting up these spawns bothered to set them to 15s intervals.
	-- That said, some of them could be slower because they are bit closer to player holdout areas.
	[100651] = standard_spawn,
	[101005] = standard_spawn,
	[101010] = standard_spawn,
	[100211] = standard_spawn,
	[101007] = standard_spawn,
	[101009] = standard_spawn,
}
