local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local standard_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.2, 1.1, 1, 0.9 },
	},
}
local scripted_diff_add = {
	difficulty_addends = {
		{
			amount = 0.25,
			time = { 30, 45 },
			delay = 0,
		},
	},
}

return {
	-- instantly enter FFO when pressing the button on Pro Jobs
	[100129] = {
		set_ponr_state = true,
	},
	-- Increase difficulty when a safe is breached or you fail to open the safe
	[101127] = scripted_diff_add,
	[100244] = scripted_diff_add,
	-- Spawn group intervals
	-- This heist is microscopic.
	[100651] = standard_spawn,
	[101005] = standard_spawn,
	[101010] = standard_spawn,
	[100211] = standard_spawn,
	[101007] = standard_spawn,
	[101009] = standard_spawn,
}
