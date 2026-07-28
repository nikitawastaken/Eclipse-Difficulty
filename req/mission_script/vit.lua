local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local scripted_enemy = Eclipse.scripted_enemy
local is_pro_job = Eclipse.utils.is_pro_job()
local disabled = {
	values = {
		enabled = false,
	},
}
local humvee_crash_event_chance = {
	values = {
		enabled = (normal and 0.2 or hard and 0.4 or 0.6) + (is_pro_job and 0.2 or 0),
	},
}
local main_window_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local oval_window_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local peoc_side_door_spawn = {
	values = {
		interval = 30,
	},
}
local escape_rappel_spawn = {
	values = {
		interval = 30,
	},
}
local peoc_upper_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_shields_bulldozers,
}

local us_soldiers = { [scripted_enemy.soldier_2] = 4, [scripted_enemy.soldier_3] = 2, [scripted_enemy.soldier_4] = 1 }
local us_soldier = {
	enemy = us_soldiers,
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
		ponr = { -- Alarm
			length = 2100,
			length_balance_mul = { 1.75, 1.375, 1.125, 1 },
		},
		values = {
			callback = function() -- Somebody call the National Guard!
				managers.groupai:state():enable_timed_spawngroup("us_scripted_group1")
			end,
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
	-- disable gas in the PEOC
	[102079] = {
		on_executed = {
			{ id = 102023, remove = true },
		},
	},
	-- make humvee event be chance based
	[101606] = humvee_crash_event_chance,
	[103360] = disabled,
	[101416] = disabled,
	-- replace all murkywater security with US Soldiers
	[101170] = us_soldier,
	[101171] = us_soldier,
	[101172] = us_soldier,
	[101174] = us_soldier,
	[101175] = us_soldier,
	[101176] = us_soldier,
	[101177] = us_soldier,
	[101178] = us_soldier,
	[101179] = us_soldier,
	[101180] = us_soldier,
	[101181] = us_soldier,
	[101198] = us_soldier,
	[101200] = us_soldier,
	[101202] = us_soldier,
	[102549] = us_soldier,
	[102550] = us_soldier,
	[102551] = us_soldier,
	[102552] = us_soldier,
	[102553] = us_soldier,
	[101594] = us_soldier,
	[101595] = us_soldier,
	[102534] = us_soldier,
	[102537] = us_soldier,
	[102600] = us_soldier,
	[102601] = us_soldier,
	[102602] = us_soldier,
	[102612] = us_soldier,
	[102613] = us_soldier,
	[102165] = us_soldier,
	[102166] = us_soldier,
	[102167] = us_soldier,
	[102168] = us_soldier,
	[102169] = us_soldier,
	[102170] = us_soldier,
	[102171] = us_soldier,
	[102172] = us_soldier,
	[102173] = us_soldier,
	[102174] = us_soldier,
	-- Spawn group intervals
	[100128] = main_window_spawn,
	[100006] = oval_window_spawn,
	[100133] = oval_window_spawn,
	[103347] = peoc_side_door_spawn,
	[103348] = peoc_side_door_spawn,
	[100694] = peoc_upper_spawn,
	[102557] = peoc_upper_spawn,
	[103452] = escape_rappel_spawn,
}
