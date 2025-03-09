local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local window_spawn1 = {
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local window_spawn2 = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- prevent cops from spawning too soon
	[100022] = {
		on_executed = {
			{ id = 100109, delay = 30 },
		},
	},
	-- remove sketchy cheat spawns
	[102317] = disabled,
	[101258] = disabled,
	[102225] = disabled,
	[102224] = disabled,
	[102226] = disabled,
	-- spawn group delays
	[100007] = window_spawn1,
	[102148] = window_spawn1,
	[102399] = window_spawn1,
	[102400] = window_spawn1,
	[101959] = window_spawn2,
	[101946] = window_spawn2,
}
