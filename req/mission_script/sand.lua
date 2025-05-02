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
		interval = 15,
	},
	groups = preferred.no_cops_agents,
}
local container_spawn = {
	values = {
		interval = 25,
	},
	groups = preferred.no_cops_agents_shields,
}
local office_spawn = {
	values = {
		interval = 40,
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
return {
	[100109] = {
		reinforce = {
			{
				name = "office_warehouse1",
				force = 3,
				position = Vector3(-4500, -3400, 0),
			},
			{
				name = "office_warehouse2",
				force = 3,
				position = Vector3(250, -100, 0),
			},
			{
				name = "office_warehouse3",
				force = 3,
				position = Vector3(-500, -2000, 0),
			},
		},
	},
	[101108] = {
		reinforce = {
			{ name = "office_warehouse1" },
			{ name = "office_warehouse2" },
			{ name = "office_warehouse3" },
		},
	},
	[101441] = {
		reinforce = {
			{
				name = "waterfront",
				force = 4,
				position = Vector3(15500, -2650, -300),
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
	[103662] = {
		values = {
			timer = is_eclipse and 120 or 60,
		},
	},
	[103257] = disabled,
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
	[100019] = container_spawn,
	[100692] = container_spawn,
	[101264] = container_spawn,
	[101268] = container_spawn,
	[101269] = container_spawn,
	[101270] = container_spawn,
	[101420] = container_spawn,
	[101442] = container_spawn,
	[101444] = container_spawn,
	[101265] = office_spawn,
	[101266] = office_spawn,
	[100693] = office_spawn,
	[101969] = office_spawn,
	[101971] = office_spawn,
	[104816] = warehouse_spawn,
	[101967] = warehouse_spawn,
	[104814] = warehouse_spawn,
	[101965] = warehouse_spawn,
	[104812] = warehouse_spawn,
	[104809] = warehouse_spawn,
	[101963] = warehouse_spawn,
	[104810] = warehouse_spawn,
}
