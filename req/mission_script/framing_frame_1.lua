local preferred = Eclipse.preferred
local participate = {
	values = {
		participate_to_group_ai = true,
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local rear_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_bulldozers,
}
local breach_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 120,
	},
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_cloakers_snipers,
}
return {
	-- Set difficulty
	[100648] = {
		difficulty = 0.5,
	},
	[101961] = {
		values = {
			difficulty = 0.5,
		},
	},
	[100812] = {
		values = {
			difficulty = 0.5,
		},
		on_executed = {
			{ id = 101495, delay = 0 },
		},
	},
	-- replace the turret with a spawngroup
	[100790] = {
		on_executed = {
			{ id = 104266, remove = true },
			{ id = 400007, delay = 0 },
		},
	},
	-- edit SWAT heli dropoff
	-- make 2 SWAT dummies participate to group ai
	[101949] = participate,
	[101950] = participate,
	[103787] = disabled,
	-- replace mission scripts with a actual spawngroup
	[101953] = {
		on_executed = {
			{ id = 101956, remove = true },
			{ id = 101957, remove = true },
			{ id = 400012, delay = 5 },
			{ id = 101958, delay = 10 }, -- make the chopper fly out much faster
		},
	},
	-- close the heli doors once it begins to fly out
	[101958] = {
		on_executed = {
			{ id = 400016, delay = 0 },
		},
	},
	-- loop the chopper after it goes hidden
	[101959] = {
		on_executed = {
			{ id = 101951, delay = 120, delay_rand = 60 },
		},
	},
	[103041] = {
		values = {
			trigger_times = 0,
		},
	},
	-- restore unused civilian event
	[100735] = {
		on_executed = {
			{ id = 400014, delay = 0 },
		},
	},
	-- Spawn Group delays
	[400009] = scripted_swat_van_spawn,
	[400013] = scripted_swat_van_spawn,
	[102061] = rear_spawn,
	[102065] = rear_spawn,
	[101043] = rear_spawn,
	[101685] = breach_spawn,
	[101694] = breach_spawn,
	[102439] = breach_spawn,
	[104060] = cloaker_spawn,
	[104058] = cloaker_spawn,
	[104059] = cloaker_spawn,
	[104061] = cloaker_spawn,
}
