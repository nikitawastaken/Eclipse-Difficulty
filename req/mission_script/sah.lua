local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local flank_spawn = {
	values = {
		interval = 15,
	},
}
local balcony_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_bulldozers,
}
local roof_spawn1 = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents,
}
local roof_spawn2 = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local storage_spawn1 = {
	values = {
		interval = 40,
	},
	groups = preferred.no_shields_bulldozers,
}
local window_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local storage_spawn2 = {
	values = {
		interval = 60,
	},
	groups = preferred.no_shields_bulldozers,
}
return {
	-- PONR state
	[101175] = disabled,
	[101177] = {
		set_ponr_state = true,
	},
	-- Disable instant difficulty increase
	[100122] = disabled,
	-- Loud, slightly delay police response
	[100109] = {
		values = {
			base_delay = 40,
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
	-- Diff increased, enable additional reinforce
	[100124] = {
		reinforce = {
			{
				name = "upper1",
				force = 2,
				position = Vector3(800, 2000, 500),
			},
			{
				name = "upper2",
				force = 2,
				position = Vector3(-800, 2000, 500),
			},
		},
	},
	-- Disable area report triggers
	[100140] = disabled,
	[106783] = disabled,
	[103926] = disabled,
	[106784] = disabled,
	-- Remove some sketchy hackbox preferreds
	[106852] = { -- Hackbox 1
		on_executed = {
			{ id = 103906, remove = true },
		},
	},
	[106853] = { -- Hackbox 2
		on_executed = {
			{ id = 103907, remove = true },
		},
	},
	[106854] = { -- Hackbox 3
		on_executed = {
			{ id = 103911, remove = true },
		},
	},
	-- Spawn point delays
	[100128] = flank_spawn,
	[100130] = flank_spawn,
	[103662] = flank_spawn,
	[106779] = balcony_spawn,
	[102667] = roof_spawn1,
	[103307] = roof_spawn1,
	[106776] = roof_spawn1,
	[106764] = roof_spawn1,
	[106767] = roof_spawn1,
	[100133] = roof_spawn2,
	[100694] = roof_spawn2,
	[102303] = storage_spawn1,
	[104089] = storage_spawn1,
	[106826] = window_spawn,
	[103522] = storage_spawn2,
}
