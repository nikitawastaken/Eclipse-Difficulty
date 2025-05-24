local preferred = Eclipse.preferred

local escape_spawn = {
	values = {
		interval = 15,
	},
}
local window_spawn1 = {
	values = {
		interval = 15,
	},
}
local window_spawn2 = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local roof_spawn1 = {
	values = {
		interval = 30,
	},
	groups = preferred.no_bulldozers,
}
local roof_spawn2 = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}

return {
	-- Combine some navigation areas
	[100303] = {
		ai_area = {
			{ 13, 58, 105 },
			{ 36, 35, 103, 32, 108, 33, 34 },
			{ 49, 170 },
			{ 121, 165 },
			{ 167, 61, 166, 60 },
			{ 62, 169 },
			{ 59, 168 },
			{ 110, 64, 111 },
			{ 63, 162 },
		},
	},
	-- add point of no return and disable endless assault
	[100875] = {
		ponr = {
			length = 240,
			player_mul = { 1.5, 1, 0.85, 0.75 },
		},
	},
	[100877] = {
		values = {
			enabled = false,
		},
	},
	-- Spawn group delays
	-- Quite a few changes to this one. It's a pretty cramped map with verticality at that.
	-- Lower level spawns are faster with more groups, higher level spawns are much slower and have group restrictions.
	-- The ground spawns at the escape have been slowed down to allow for more diverse holdout locations, if you know you know.
	[106717] = escape_spawn,
	[104348] = escape_spawn,
	[101012] = window_spawn1,
	[101315] = window_spawn1,
	[102138] = window_spawn1,
	[104338] = window_spawn1,
	[107262] = window_spawn1,
	[107263] = window_spawn1,
	[100750] = window_spawn2,
	[102664] = window_spawn2,
	[102667] = window_spawn2,
	[102668] = window_spawn2,
	[102139] = roof_spawn1,
	[102140] = roof_spawn1,
	[104336] = roof_spawn1,
	[104337] = roof_spawn1,
	[107260] = roof_spawn1,
	[107261] = roof_spawn1,
	[102151] = roof_spawn2,
	[104347] = roof_spawn2,
}
