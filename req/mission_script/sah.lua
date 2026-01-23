local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local storage_far_spawn = {
	values = {
		interval = 20,
	},
}
local roof_far_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local roof_close_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local storage_close_spawn = {
	values = {
		interval = 40,
	},
}
local storage_window_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 7, 8, 9 },
			{ 34, 35 },
		},
	},
	[100814] = {
		ai_area = {
			{ 33, 51 },
			{ 38, 40 },
		},
	},
	[100817] = {
		ai_area = {
			{ 38, 40 },
			{ 42, 73 },
		},
	},
	[100819] = {
		ai_area = {
			{ 33, 51 },
			{ 42, 73 },
		},
	},
	-- PONR state
	[101175] = disabled,
	[101006] = {
		set_ponr_state = true,
	},
	-- Disable instant difficulty increase
	[100122] = disabled,
	-- Loud, slightly delay police response
	[100109] = {
		values = {
			base_delay = 30
		}
	},
	[100129] = { -- Preferred
		reinforce = { 
			{
				name = "auction_room",
				force = 3,
				position = Vector3(0, 2000, -100)
			},
			{
				name = "outside_left",
				force = 2,
				position = Vector3(-1600, -1375, -50)
			},
			{
				name = "outside_middle",
				force = 3,
				position = Vector3(0, -2500, -50)
			},
			{
				name = "outside_right",
				force = 2,
				position = Vector3(1575, -1350, -50)
			},
		},
		on_executed = {
			{ id = 100127, delay = 0 },
			{ id = 103905, delay = 0 },
			{ id = 103910, delay = 0 },
			{ id = 103912, delay = 0 },
			{ id = 103913, delay = 0 }
		}
	},
	-- Disable area report triggers
	[100140] = disabled,
	[106783] = disabled,
	[103926] = disabled,
	[106784] = disabled,
	-- Spawn group intervals
	[103662] = storage_far_spawn,
	[102667] = roof_far_spawn,
	[103307] = roof_far_spawn,
	[106764] = roof_far_spawn,
	[106767] = roof_far_spawn,
	[106776] = roof_far_spawn,
	[106779] = roof_far_spawn,
	[100133] = roof_close_spawn,
	[100694] = roof_close_spawn,
	[106826] = roof_close_spawn,
	[102303] = storage_close_spawn,
	[104089] = storage_close_spawn,
	[103522] = storage_window_spawn,
}
