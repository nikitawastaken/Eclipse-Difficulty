local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local disabled = {
	values = {
		enabled = false,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local top_spawn = {
	values = {
		interval = 10,
	},
	groups = preferred.no_cops_agents,
}
local waterfront_lower_spawn = {
	values = {
		interval = 15,
	},
}
local container_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields,
}
local waterfront_upper_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local office_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local warehouse_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local dozer_chance = {
	values = {
		chance = (is_pro_job and 1.33 or 1) * (diff_i - 2) * 15,
	},
}
local boat_timer = {
	values = {
		timer = 90 + (is_pro_job and 60 or 0),
	},
}
return {
	[100109] = {
		reinforce = {
			{
				name = "warehouse_office1",
				force = 3,
				position = Vector3(0, 0, 0),
			},
			{
				name = "warehouse_office2",
				force = 3,
				position = Vector3(-1750, -2250, 0),
			},
			{
				name = "warehouse_office3",
				force = 3,
				position = Vector3(-4500, -3250, 0),
			},
		},
	},
	[101369] = {
		reinforce = {
			{ name = "warehouse_office1" },
			{ name = "warehouse_office2" },
			{ name = "warehouse_office3" },
		},
	},
	[104374] = {
		difficulty = 0.75,
		reinforce = {
			{
				name = "harbor_office1",
				force = 3,
				position = Vector3(8400, -2875, -300),
			},
			{
				name = "harbor_office2",
				force = 3,
				position = Vector3(9725, 1150, -300),
			},
			{
				name = "harbor_office3",
				force = 3,
				position = Vector3(9850, -1300, -300),
			},
		},
	},
	[104384] = {
		reinforce = {
			{ name = "harbor_office1" },
			{ name = "harbor_office2" },
			{ name = "harbor_office3" },
		},
	},
	[101630] = {
		difficulty = 1,
		reinforce = {
			{
				name = "harbor",
				force = 6,
				position = Vector3(15500, -2750, -300),
			},
		},
	},
	--power box SO cooldown (taken from ASS)
	[100549] = {
		on_executed = {
			{ id = 103658, delay = 10, delay_rand = 10 },
		},
	},
	[103827] = {
		on_executed = {
			{ id = 103828, delay = 10, delay_rand = 10 },
		},
	},
	-- boat arrival timer
	[103662] = boat_timer,
	[103257] = disabled,
	-- Disable vanilla assault-based difficulty scaling, replace it with objective-based scaling
	[100124] = disabled,
	[100125] = disabled,
	-- Delay roof rappels at the start
	[101660] = { 
		on_executed = {
			{ id = 101280, delay = 30 }, -- roof 1 
			{ id = 101279, delay = 30 }, -- roof 2
			{ id = 101272, delay = 30 }, -- roof 3
		},
	},
	-- disable the helicopter turret since it does nothing anyway
	[101257] = disabled,
	-- enable unused sniper spawns
	[100376] = enabled,
	[100375] = enabled,
	[100374] = enabled,
	[100372] = enabled,
	-- ambush bulldozers
	[101723] = dozer_chance,
	[101779] = dozer_chance,
	[101780] = dozer_chance,
	[101781] = dozer_chance,
	--spawn point delays
	[100694] = top_spawn,
	[101456] = top_spawn,
	[101458] = top_spawn,
	[105463] = waterfront_lower_spawn,
	[100692] = container_spawn,
	[101264] = container_spawn,
	[101268] = container_spawn,
	[101269] = container_spawn,
	[101270] = container_spawn,
	[101420] = container_spawn,
	[101444] = container_spawn,
	[101265] = office_spawn,
	[101266] = office_spawn,
	[100693] = office_spawn,
	[101969] = office_spawn,
	[101971] = office_spawn,
	[100019] = waterfront_upper_spawn,
	[101442] = waterfront_upper_spawn,
	[104816] = warehouse_spawn,
	[101967] = warehouse_spawn,
	[104814] = warehouse_spawn,
	[101965] = warehouse_spawn,
	[104812] = warehouse_spawn,
	[104809] = warehouse_spawn,
	[101963] = warehouse_spawn,
	[104810] = warehouse_spawn,
}
