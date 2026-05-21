local preferred = Eclipse.preferred
local standard_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local bridge_far_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents,
}
local bridge_close_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local window_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.5, 1.3, 1.1, 0.9 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
	groups = preferred.only_cloakers_single,
}
return {
	[101115] = {
		ponr = {
			length = 180,
			length_balance_mul = { 1.15, 1.15, 1, 1 },
		},
	},
	--[[	[100145] = { -- Floor blown
		values = {
			callback = function()
				managers.groupai:state():enable_timed_spawngroup("murky_scripted_group1")
			end,
		},
	},
]]
	-- Combine some navigation areas
	[100287] = {
		ai_area = {
			{ 10, 11, 12, 15 },
			{ 13, 17, 27 },
			{ 5, 6, 7, 59, 8, 9, 18 },
			{ 36, 37 },
		},
	},
	-- Add early reinforce around the bank
	[100001] = {
		reinforce = {
			{
				name = "entrance01",
				force = 2,
				position = Vector3(-800, -1000, 10),
			},
			{
				name = "entrance02",
				force = 2,
				position = Vector3(1325, -3000, 10),
			},
			{
				name = "entrance03",
				force = 2,
				position = Vector3(2850, -3000, 10),
			},
			{
				name = "parking_lot",
				force = 4,
				position = Vector3(-2500, -2750, 0),
			},
			{
				name = "construction",
				force = 4,
				position = Vector3(3000, -4500, 10),
			},
		},
	},
	[100400] = { -- pre_vault_area
		reinforce = {
			{
				name = "interior01",
				force = 2,
				position = Vector3(1175, -650, 350),
			},
			{
				name = "interior02",
				force = 2,
				position = Vector3(825, -1400, 350),
			},
		},
	},
	--Don't trigger the spawngroup if the tarp has been cut (prevent the cops from spawning early)
	[101288] = {
		values = {
			enabled = false,
		},
	},
	-- Spawn group intervals
	[100007] = standard_spawn,
	[100286] = standard_spawn,
	[100332] = standard_spawn,
	[100965] = standard_spawn,
	[100435] = bridge_far_spawn,
	[100454] = bridge_far_spawn,
	[100455] = bridge_far_spawn,
	[100461] = bridge_far_spawn,
	[100168] = bridge_close_spawn,
	[100369] = bridge_close_spawn,
	[100429] = bridge_close_spawn,
	[100441] = bridge_close_spawn,
	[100247] = window_spawn,
	[100067] = window_spawn,
	[100068] = window_spawn,
	[400020] = cloaker_spawn,
	[400021] = cloaker_spawn,
	[400022] = cloaker_spawn,
	[400023] = cloaker_spawn,
	[400024] = cloaker_spawn,
	[400025] = cloaker_spawn,
	[400026] = cloaker_spawn,
}
