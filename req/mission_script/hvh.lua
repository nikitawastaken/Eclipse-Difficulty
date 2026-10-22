local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local standard_spawn = {
	values = {
		interval = 15,
	},
}

return {
	-- instantly enter FFO when pressing the button on Pro Jobs
	[100129] = {
		set_ponr_state = true,
	},
	-- Increase difficulty when a safe is breached or you fail to open the safe
	[101127] = {
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	[100244] = {
		on_executed = {
			{ id = 400002, delay = 0 },
		},
	},
	-- Spawn group intervals
	-- This heist is microscopic.
	[100651] = standard_spawn,
	[101005] = standard_spawn,
	[101010] = standard_spawn,
	[100211] = standard_spawn,
	[101007] = standard_spawn,
	[101009] = standard_spawn,
}
