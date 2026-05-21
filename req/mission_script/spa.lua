local preferred = Eclipse.preferred
local is_pro_job = Eclipse.utils.is_pro_job()
local van_arrive_timer = 60 + (is_pro_job and 60 or 0)
local van_arrive_timer_random = 30 + (is_pro_job and 30 or 0)
local building_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_cops_agents,
}
local building_init_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_cops_agents,
}
local agile_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_cops_agents,
}
local agile_final_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local difficulty_add_25 = {
	difficulty_add = 0.25,
}
return {
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
	-- add scripted diff increases
	--	[102255] = difficulty_add_25, -- obj_complete_004
	--	[102137] = difficulty_add_25, -- swap_spawns_to_the_ground
	-- tweak van arrival timer
	[100483] = {
		on_executed = {
			{ id = 100549, delay = van_arrive_timer, delay_rand = van_arrive_timer_random },
		},
	},
	-- Spawn group intervals
	-- Quite a few changes to this one. It's a pretty cramped map with verticality at that.
	[102667] = building_init_spawn,
	[102668] = building_init_spawn,
	[107262] = building_init_spawn,
	[107263] = building_init_spawn,
	[102664] = building_init_spawn,
	[104472] = building_init_spawn,
	[107260] = building_init_spawn,
	[107261] = building_init_spawn,
	[102139] = building_spawn,
	[102140] = building_spawn,
	[104336] = building_spawn,
	[104337] = building_spawn,
	[100750] = agile_spawn,
	[101012] = agile_spawn,
	[102138] = agile_spawn,
	[104338] = agile_spawn,
	[102151] = agile_final_spawn,
	[104347] = agile_final_spawn,
}
