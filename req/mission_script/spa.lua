local preferred = Eclipse.preferred
local is_pro_job = Eclipse.utils.is_pro_job()
local van_arrive_timer = 65 + (is_pro_job and 30 or 0)
local van_arrive_time = 60 + (is_pro_job and 30 or 0)
local rappel_far_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_cops_agents,
}
local rappel_close_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
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
		ponr = { -- Set hunt, waiting for escape
			length = 200,
			player_mul = { 1.25, 1, 0.875, 0.75 },
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
	[102139] = rappel_far_spawn,
	[102140] = rappel_far_spawn,
	[102667] = rappel_far_spawn,
	[102668] = rappel_far_spawn,
	[104336] = rappel_far_spawn,
	[104337] = rappel_far_spawn,
	[107260] = rappel_far_spawn,
	[107261] = rappel_far_spawn,
	[107262] = rappel_far_spawn,
	[107263] = rappel_far_spawn,
	[100750] = rappel_close_spawn,
	[101012] = rappel_close_spawn,
	[102664] = rappel_close_spawn,
	[102138] = rappel_close_spawn,
	[104338] = rappel_close_spawn,
	[104472] = rappel_close_spawn,
	[102151] = roof_spawn,
	[104347] = roof_spawn,
}
