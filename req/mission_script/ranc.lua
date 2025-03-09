local preferred = Eclipse.preferred
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local spawn_anim_fix = {
	values = {
		spawn_action = "e_sp_over_3m",
	},
}
local fence_spawn1 = {
	values = {
		interval = 10,
	},
}
local fence_spawn2 = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields,
}
local haybale_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local shaft_spawn = {
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
return {
	-- tweak difficulty scaling
	[100122] = {
		values = {
			difficulty = 0.5,
		},
	},
	[100124] = {
		values = {
			difficulty = 0.75,
		},
	},
	[101582] = {
		values = {
			difficulty = 1,
		},
	},
	[100022] = { -- alarm
		on_executed = { -- delay the initial assault (you are in the middle of nowhere)
			{ id = 100109, delay = 40 },
		},
		reinforce = { -- add all at once so they get populated quickly
			{
				name = "fork",
				force = 4, -- fuck huge navseg
				position = Vector3(-2015, -145, 200),
			},
			{
				name = "main_gate1",
				force = 4, -- fuck huge navseg
				position = Vector3(5670, 1125, 400),
			},
			{
				name = "main_gate2",
				force = 4,
				position = Vector3(5310, -1090, 400),
			},
			{
				name = "outside_garage",
				force = 2,
				position = Vector3(7875, -9315, 400),
			},
			{
				name = "such_a_nice_car",
				force = 2,
				position = Vector3(2985, -7040, 400), -- go bank car near some un-enterable sheds
			},
			{
				name = "barn1",
				force = 2,
				position = Vector3(6755, 5320, 400), -- exit by shooting range
			},
			{
				name = "barn2",
				force = 2,
				position = Vector3(4285, 5215, 400), -- exit by stealth secure point
			},
			{
				name = "workshop_a", -- labelled in editor
				force = 3,
				position = Vector3(3070, 2890, 400),
			},
			{
				name = "workshop_c", -- labelled in editor
				force = 3,
				position = Vector3(9215, 1625, 450),
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
	-- spawn point delays
	[100128] = fence_spawn1,
	[100692] = fence_spawn1,
	[100693] = fence_spawn1,
	[100908] = fence_spawn1,
	[100912] = fence_spawn1,
	[100913] = fence_spawn1,
	[102443] = fence_spawn1,
	[100909] = fence_spawn1,
	[100916] = fence_spawn1,
	[100007] = fence_spawn1,
	[100694] = fence_spawn1,
	[100133] = fence_spawn1,
	[100132] = fence_spawn1,
	[100779] = fence_spawn2,
	[100131] = haybale_spawn,
	[100911] = roof_spawn,
	[100019] = shaft_spawn,
	[102484] = vent_spawn,
}
