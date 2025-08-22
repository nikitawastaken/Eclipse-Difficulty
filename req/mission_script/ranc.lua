local preferred = Eclipse.preferred
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local spawn_anim_fix = {
	spawn_action = "e_sp_over_3m",
}
local fence_spawn = {
	values = {
		interval = 15,
	},
}
local dock_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local vent_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[100022] = { -- alarm
		reinforce = {
			{
				name = "gate1",
				force = 5,
				position = Vector3(2100, 4875, 400),
			},
			{
				name = "gate2",
				force = 5,
				position = Vector3(5325, 1500, 400),
			},
			{
				name = "gate3",
				force = 5,
				position = Vector3(2025, -4500, 400),
			},
			{
				name = "fork",
				force = 5,
				position = Vector3(-1800, -50, 200),
			},
			{
				name = "fork_corner1",
				force = 3,
				position = Vector3(-1440, -3970, 200),
			},
			{
				name = "fork_corner2",
				force = 3,
				position = Vector3(-315, 4935, 400),
			},
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
	[100789] = spawn_anim_fix,
	[100790] = spawn_anim_fix,
	[100791] = spawn_anim_fix,
	-- Spawn group delays
	[100128] = fence_spawn,
	[100692] = fence_spawn,
	[100693] = fence_spawn,
	[100908] = fence_spawn,
	[100912] = fence_spawn,
	[100913] = fence_spawn,
	[102443] = fence_spawn,
	[100909] = fence_spawn,
	[100916] = fence_spawn,
	[100007] = fence_spawn,
	[100694] = fence_spawn,
	[100133] = fence_spawn,
	[100132] = fence_spawn,
	[100779] = fence_spawn,
	[100131] = dock_spawn,
	[100130] = dock_spawn,
	[102397] = dock_spawn,
	[100911] = roof_spawn,
	[100019] = roof_spawn,
	[102484] = vent_spawn,
}
