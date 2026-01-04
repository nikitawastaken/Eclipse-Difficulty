local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local diff_i_no_easy = Eclipse.utils.difficulty_index_no_easy()
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
local upper_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local waterfront_spawn = {
	values = {
		interval = 20,
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
		chance = (diff_i_no_easy * 15) * (is_pro_job and 1.33 or 1),
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
				name = "warehouse_office01",
				force = 3,
				position = Vector3(0, 0, 0),
			},
			{
				name = "warehouse_office02",
				force = 3,
				position = Vector3(-1750, -2250, 0),
			},
			{
				name = "warehouse_office03",
				force = 3,
				position = Vector3(-4500, -3250, 0),
			},
		},
	},
	[101369] = {
		reinforce = {
			{ name = "warehouse_office01" },
			{ name = "warehouse_office02" },
			{ name = "warehouse_office03" },
		},
	},
	[104374] = {
		reinforce = {
			{
				name = "harbor_office01",
				force = 3,
				position = Vector3(8400, -2875, -300),
			},
			{
				name = "harbor_office02",
				force = 3,
				position = Vector3(9725, 1150, -300),
			},
			{
				name = "harbor_office03",
				force = 3,
				position = Vector3(9850, -1300, -300),
			},
		},
	},
	[104384] = {
		reinforce = {
			{ name = "harbor_office01" },
			{ name = "harbor_office02" },
			{ name = "harbor_office03" },
		},
	},
	[101630] = {
		reinforce = {
			{
				name = "harbor",
				force = 5,
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
	-- Delay roof rappels at the start
	[101660] = {
		on_executed = {
			{ id = 101280, delay = 20, delay_rand = 20 }, -- roof 1
			{ id = 101279, delay = 20, delay_rand = 20 }, -- roof 2
			{ id = 101272, delay = 20, delay_rand = 20 }, -- roof 3
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
	--Spawn group intervals
	[100692] = upper_spawn,
	[100694] = upper_spawn,
	[101264] = upper_spawn,
	[101268] = upper_spawn,
	[101269] = upper_spawn,
	[101270] = upper_spawn,
	[101420] = upper_spawn,
	[101444] = upper_spawn,
	[101456] = upper_spawn,
	[101458] = upper_spawn,
	[101265] = office_spawn,
	[101266] = office_spawn,
	[100693] = office_spawn,
	[101969] = office_spawn,
	[101971] = office_spawn,
	[105463] = waterfront_spawn,
	[100019] = waterfront_spawn,
	[101442] = waterfront_spawn,
	[104816] = warehouse_spawn,
	[101967] = warehouse_spawn,
	[104814] = warehouse_spawn,
	[101965] = warehouse_spawn,
	[104812] = warehouse_spawn,
	[104809] = warehouse_spawn,
	[101963] = warehouse_spawn,
	[104810] = warehouse_spawn,
}
