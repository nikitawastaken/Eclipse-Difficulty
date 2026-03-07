local preferred = Eclipse.preferred
local is_pro_job = Eclipse.utils.is_pro_job()
local van_arrive_timer = 60 + (is_pro_job and 60 or 0)
local van_arrive_timer_random = 30 + (is_pro_job and 30 or 0)
local rappel_init_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_cops_agents,
}
local roof_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.75, 1.5, 1.25, 1 },
	},
	groups = preferred.no_cops_agents,
}
local rappel_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.5, 1.25, 1, 1 },
	},
	groups = preferred.no_cops_agents,
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
			length = 300,
			length_balance_mul = { 1.25, 1, 0.875, 0.75 },
		},
	},
	[100877] = {
		values = {
			enabled = false,
		},
	},
	-- tweak van arrival timer
	[100483] = {
		on_executed = {
			{ id = 100549, delay = van_arrive_timer, delay_rand = van_arrive_timer_random },
		},
	},
	-- Spawn group intervals
	-- Quite a few changes to this one. It's a pretty cramped map with verticality at that.
	[102667] = rappel_init_spawn, 
	[102668] = rappel_init_spawn, 
	[107262] = rappel_init_spawn, 
	[107263] = rappel_init_spawn, 
	[102664] = rappel_init_spawn, 
	[104472] = rappel_init_spawn, 
	[102139] = roof_spawn,
	[102140] = roof_spawn,
	[102151] = roof_spawn,
	[104336] = roof_spawn,
	[104337] = roof_spawn,
	[104347] = roof_spawn,
	[107260] = roof_spawn,
	[107261] = roof_spawn,
	[100750] = rappel_spawn,
	[101012] = rappel_spawn,	
	[102138] = rappel_spawn,
	[104338] = rappel_spawn,
}
