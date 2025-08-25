local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local disabled = {
	values = {
		enabled = false,
	},
}
local humvee_crash_event_chance = {
	values = {
		enabled = (normal and 0.1 or hard and 0.3 or 0.5) + ((is_pro_job and normal) and 0.1 or is_pro_job and 0.3 or 0),
	},
}
local main_window_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local oval_window_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local peoc_side_door_spawn = {
	values = {
		interval = 30,
	},
}
local peoc_upper_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_shields_bulldozers,
}
local escape_rappel_spawn = {
	values = {
		interval = 30,
	},
}
return {
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 44, 84, 85 },
			{ 103, 104, 105, 106 },
			{ 97, 99 },
			{ 52, 86 },
		},
	},
	[100022] = {
		ponr = {
			length = 3000,
			player_mul = { 1.75, 1.25, 1.125, 1 },
		},
	},
	-- Add reinforce at the escape
	[103458] = { -- escape preferreds 3
		reinforce = {
			{
				name = "escape_left",
				force = 3,
				position = Vector3(-1425, 350, 25),
			},
			{
				name = "escape_right",
				force = 3,
				position = Vector3(1425, 450, 25),
			},
		},
	},
	-- make humvee event be chance based
	[101606] = humvee_crash_event_chance,
	[103360] = disabled,
	[101416] = disabled,
	-- spawn point delays
	[100128] = main_window_spawn,
	[100006] = oval_window_spawn,
	[100133] = oval_window_spawn,
	[103347] = peoc_side_door_spawn,
	[103348] = peoc_side_door_spawn,
	[100694] = peoc_upper_spawn,
	[102557] = peoc_upper_spawn,
	[103452] = escape_rappel_spawn,
}
