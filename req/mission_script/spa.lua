local preferred = Eclipse.preferred
local escape_spawn = {
	values = {
		interval = 10,
	},
}
local breach_lower_spawn = {
	values = {
		interval = 15,
	},
}
local window_lower_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local breach_upper_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_shields_bulldozers,
}
local window_upper_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local skylight_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local roof_spawn = {
	values = {
		interval = 45,
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
	[107262] = breach_lower_spawn,
	[107263] = breach_lower_spawn,
	[101012] = window_lower_spawn,
	[102138] = window_lower_spawn,
	[104338] = window_lower_spawn,
	[104472] = window_lower_spawn,
	[102667] = breach_upper_spawn,
	[102668] = breach_upper_spawn,
	[100750] = window_upper_spawn,
	[102664] = window_upper_spawn,
	[102139] = skylight_spawn,
	[102140] = skylight_spawn,
	[104336] = skylight_spawn,
	[104337] = skylight_spawn,
	[107260] = skylight_spawn,
	[107261] = skylight_spawn,
	[102151] = roof_spawn,
	[104347] = roof_spawn,
}
