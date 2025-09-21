local preferred = Eclipse.preferred
local is_pro_job = Eclipse.utils.is_pro_job()
local van_arrive_timer = 65 + (is_pro_job and 30 or 0)
local van_arrive_time = 60 + (is_pro_job and 30 or 0)
local skylight_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_cops_agents,
}
local window_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 30,
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
	-- tweak van arrival timer
	--[[
	[101543] = {
		values = {
			time = van_arrive_time,
		},
	},
	[101312] = {
		values = {
			timer = van_arrive_timer,
		},
	},
	[101631] = {
		values = {
			time = van_arrive_time,
		},
	},
	[101201] = {
		values = {
			timer = van_arrive_timer,
		},
	},
	]]
	--
	-- Spawn group intervals
	-- Quite a few changes to this one. It's a pretty cramped map with verticality at that.
	[100750] = window_spawn,
	[101012] = window_spawn,
	[102138] = window_spawn,
	[102664] = window_spawn,
	[104338] = window_spawn,
	[104472] = window_spawn,
	[102139] = skylight_spawn,
	[102140] = skylight_spawn,
	[104336] = skylight_spawn,
	[104337] = skylight_spawn,
	[107260] = skylight_spawn,
	[107261] = skylight_spawn,
	[102151] = roof_spawn,
	[104347] = roof_spawn,
}
