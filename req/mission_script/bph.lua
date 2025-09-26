local preferred = Eclipse.preferred
local standard_spawn = {
	values = {
		interval = 15,
	},
}
local standard_init_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local tower_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields_bulldozers,
}
local flank_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
return {
	-- Allow bot navigation earlier
	[102736] = {
		on_executed = {
			{ id = 103049, delay = 1 },
		},
	},
	[101161] = {
		values = {
			enabled = false,
		},
	},
	[100268] = {
		ponr = {
			length = 300,
			player_mul = { 1.25, 1, 1, 1 },
		},
	},
	-- Spawn group intervals
	[100821] = standard_spawn,
	[100875] = standard_spawn,
	[102431] = standard_spawn,
	[100007] = standard_spawn,
	[100128] = standard_spawn,
	[100130] = standard_spawn,
	[100663] = standard_spawn,
	[100669] = standard_spawn,
	[100675] = standard_spawn,
	[100741] = standard_init_spawn,
	[100131] = standard_init_spawn,
	[101365] = tower_spawn,
	[103529] = tower_spawn,
	[100888] = flank_spawn,
	[100951] = flank_spawn,
	[101420] = flank_spawn,
}
