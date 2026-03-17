local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local standard_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 2, 1.666, 1.333, 1 }, -- 666 :dwpj:
	},
}
return {
	-- instantly enter FFO when pressing the button on Pro Jobs
	[100129] = {
		set_ponr_state = true,
	},
	-- Increase difficulty when a safe is breached or you fail to open the safe
	[101127] = {
		difficulty_add = 0.2,
	},
	[100244] = {
		difficulty_add = 0.2,
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
