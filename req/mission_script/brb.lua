local preferred = Eclipse.preferred
local mga_thermite_event = {
	post_mga_event = "mga_thermite",
}
local mga_vault_event = {
	post_mga_event = { "mga_vault_a", "mga_vault_b", "mga_vault_c" },
}
local bridge_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local window_spawn = {
	values = {
		interval = 45,
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
			player_mul = { 1.15, 1.15, 1, 1 },
		},
	},
	--[[
	[100145] = { -- Floor blown
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
	--Don't trigger the spawngroup if the tarp has been cut (prevent the cops from spawning early)
	[101288] = {
		values = {
			enabled = false,
		},
	},
	-- Add early reinforce around the bank
	[100001] = {
		reinforce = {
			{
				name = "entrance01",
				force = 2,
				position = Vector3(-375, -1000, 10),
			},
			{
				name = "entrance02",
				force = 2,
				position = Vector3(1325, -2025, 10),
			},
			{
				name = "entrance03",
				force = 2,
				position = Vector3(2850, -2025, 10),
			},
			{
				name = "parking_lot",
				force = 4,
				position = Vector3(-2025, -3225, 0),
			},
			{
				name = "construction",
				force = 4,
				position = Vector3(2775, -3825, 10),
			},
		},
	},
	-- Play megaphone cop voice lines
	[100837] = mga_thermite_event,
	[101114] = mga_vault_event,
	-- Spawn group intervals
	[400020] = cloaker_spawn,
	[400021] = cloaker_spawn,
	[400022] = cloaker_spawn,
	[400023] = cloaker_spawn,
	[400024] = cloaker_spawn,
	[400025] = cloaker_spawn,
	[400026] = cloaker_spawn,
	[100168] = bridge_spawn,
	[100369] = bridge_spawn,
	[100429] = bridge_spawn,
	[100435] = bridge_spawn,
	[100441] = bridge_spawn,
	[100454] = bridge_spawn,
	[100455] = bridge_spawn,
	[100461] = bridge_spawn,
	[100247] = window_spawn,
	[100067] = window_spawn,
	[100068] = window_spawn,
}
