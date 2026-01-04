local preferred = Eclipse.preferred
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local spawn_anim_fix = {
	spawn_action = "e_sp_over_3m",
}
local roof_spawn = {
	values = {
		interval = 20,
	},
}
local dock_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local vent_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
return {
	[100109] = { -- Police
		reinforce = {
			{
				name = "gate01",
				force = 5,
				position = Vector3(2100, 4875, 400),
			},
			{
				name = "gate02",
				force = 5,
				position = Vector3(5325, 1500, 400),
			},
			{
				name = "gate03",
				force = 5,
				position = Vector3(2025, -4500, 400),
			},
			{
				name = "fork",
				force = 5,
				position = Vector3(-1800, -50, 200),
			},
			{
				name = "fork_corner01",
				force = 3,
				position = Vector3(-1440, -3970, 200),
			},
			{
				name = "fork_corner02",
				force = 3,
				position = Vector3(-315, 4935, 400),
			},
		},
	},
	[103874] = { -- arrive 1
		on_executed = {
			{ id = 400005, delay = 0, delay_rand = 5 },
		},
	},
	[103873] = { -- arrive 2
		on_executed = {
			{ id = 400012, delay = 0, delay_rand = 5 },
		},
	},
	[103875] = { -- arrive 3
		on_executed = {
			{ id = 400019, delay = 0, delay_rand = 5 },
		},
	},
	-- fix snipers being able to spawn only once
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	-- fixes some spawn typos
	[100683] = spawn_anim_fix,
	[100684] = spawn_anim_fix,
	[100787] = spawn_anim_fix,
	[100789] = spawn_anim_fix,
	[100790] = spawn_anim_fix,
	[100791] = spawn_anim_fix,
	-- Spawn group intervals
	[400007] = scripted_swat_van_spawn,
	[400014] = scripted_swat_van_spawn,
	[400021] = scripted_swat_van_spawn,
	[100911] = roof_spawn,
	[100019] = roof_spawn,
	[100131] = dock_spawn,
	[100130] = dock_spawn,
	[102397] = dock_spawn,
	[102484] = vent_spawn,
}
