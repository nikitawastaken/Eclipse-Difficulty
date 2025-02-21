local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local roof_spawn_1 = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local roof_spawn_2 = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local storage_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_shields_bulldozers,
}
return {
	-- Disable instant difficulty increase
	[100122] = disabled,
	-- Loud, slightly delay police response
	[100109] = {
		values = {
			base_delay = 30,
		},
	},
	[100129] = {
		difficulty = 0.4,
		reinforce = {
			{
				name = "auction_room",
				force = 2,
				position = Vector3(0, 2000, -100),
			},
			{
				name = "outside",
				force = 2,
				position = Vector3(0, -3300, -50),
			},
		},
		on_executed = {
			{ id = 100127, delay = 0 },
			{ id = 103905, delay = 0 },
			{ id = 103910, delay = 0 },
			{ id = 103912, delay = 0 },
			{ id = 103913, delay = 0 },
		},
	},
	-- Disable area report triggers
	[100140] = disabled,
	[106783] = disabled,
	[103926] = disabled,
	[106784] = disabled,
	-- Slow down roof spawns
	[102667] = roof_spawn_1,
	[106776] = roof_spawn_1,
	[106767] = roof_spawn_1,
	[106764] = roof_spawn_1,
	[100694] = roof_spawn_2,
	[100154] = roof_spawn_2,
	-- Slow down storage spawns
	[102303] = storage_spawn,
	[104089] = storage_spawn,
	[103662] = {
		values = {
			interval = 20,
		},
	},
	-- Slow down and adjust storage window spawns
	[103522] = {
		values = {
			interval = 60,
		},
		groups = preferred.no_shields_bulldozers,
	},
	[101175] = disabled,
	[101177] = {
		set_ponr_state = true,
	},
}
