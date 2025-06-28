local preferred = Eclipse.preferred
local staircase_spawn = {
	values = {
		interval = 10,
	},
}
local upper_spawn = {
	values = {
		interval = 15,
	},
}
local upper_init_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local tower_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers,
}
local flank_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
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
	-- Spawn group delays
	[100821] = staircase_spawn,
	[100875] = staircase_spawn,
	[102431] = staircase_spawn,
	[100007] = upper_spawn,
	[100128] = upper_spawn,
	[100130] = upper_spawn,
	[100663] = upper_spawn,
	[100669] = upper_spawn,
	[100675] = upper_spawn,
	[100741] = upper_init_spawn,
	[100131] = upper_init_spawn,
	[101365] = tower_spawn,
	[103529] = tower_spawn,
	[100951] = flank_spawn,
	[101420] = flank_spawn,
	[100888] = window_spawn,
}
