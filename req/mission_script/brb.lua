local preferred = Eclipse.preferred
local mga_thermite_event = {
	post_mga_event = "mga_thermite",
}
local mga_vault_event = {
	post_mga_event = { "mga_vault_a", "mga_vault_b", "mga_vault_c" },
}
local bridge_far_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local bridge_close_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local window_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[100145] = { -- Floor blown
		values = {
			callback = function()
				managers.groupai:state():enable_timed_spawngroup("murky_scripted_group1")
			end,
		},
	},
	-- Combine some navigation areas
	[100287] = {
		ai_area = {
			{ 10, 11, 12, 15 },
			{ 13, 17, 27 },
			{ 5, 6, 7, 59, 8, 9, 18 },
			{ 36, 37 },
		},
	},
	--Don't trigger the spawngroup if the tarp has been cut (should prevent cops from spawning early)
	--Yes, this makes the cops spawn early
	[101288] = {
		values = {
			enabled = false,
		},
	},
	-- Add early reinforce around the bank
	[100001] = {
		reinforce = {
			{
				name = "entrance1",
				force = 3,
				position = Vector3(-400, -900, 10),
			},
			{
				name = "entrance2",
				force = 3,
				position = Vector3(1350, -2200, 10),
			},
			{
				name = "entrance3",
				force = 3,
				position = Vector3(2850, -2200, 10),
			},
			{
				name = "parking_lot",
				force = 3,
				position = Vector3(-2000, -2750, 10),
			},
			{
				name = "construction",
				force = 3,
				position = Vector3(3000, -3750, 10),
			},
		},
	},
	-- Play megaphone cop voice lines
	[100837] = mga_thermite_event,
	[101114] = mga_vault_event,
	-- Spawn group intervals
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
}
