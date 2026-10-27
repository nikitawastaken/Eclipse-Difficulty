local preferred = Eclipse.preferred
local set_diff_groups = Eclipse.utils.set_diff_groups
local diff_i = Eclipse.utils.difficulty_index()
local is_pro_job = Eclipse.utils.is_pro_job()
local filter_easy_above = {
	values = set_diff_groups("easy_above"),
}
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
local standard_spawn = {
	values = {
		interval = 15,
	},
}
local close_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_bulldozers,
}
local rappel_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 90,
	},
}
local dozer_chance = {
	values = {
		chance = (diff_i * 10) * (is_pro_job and 1.5 or 1),
	},
}
local boat_timer = {
	values = {
		timer = 90 + (is_pro_job and 60 or 0),
	},
}

return {
	-- Add new reinforce
	[100109] = { -- police
		reinforce = {
			{
				name = "gate",
				force = 4,
				position = Vector3(-2925, -3225, 0),
			},
			{
				name = "warehouse_a",
				force = 3,
				position = Vector3(-300, 2100, 0),
			},
			{
				name = "warehouse_b",
				force = 3,
				position = Vector3(1000, -150, 0),
			},
			{
				name = "warehouse_c",
				force = 3,
				position = Vector3(450, -2600, 0),
			},
		},
	},
	[101369] = { -- input_close_first_gate
		ponr = {
			length = 1200,
			length_balance_mul = { 1.375, 1.125, 1, 0.875 },
		},
		reinforce = {
			{ name = "gate" },
			{ name = "warehouse_a" },
			{ name = "warehouse_b" },
			{ name = "warehouse_c" },
		},
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	--Power box SO cooldown (taken from ASS)
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
	-- Boat arrival timer
	[103662] = boat_timer,
	[103257] = disabled,
	-- Delay roof rappels at the start
	[101660] = {
		on_executed = {
			{ id = 101280, delay = 15, delay_rand = 30 }, -- roof 1
			{ id = 101279, delay = 15, delay_rand = 30 }, -- roof 2
			{ id = 101272, delay = 15, delay_rand = 30 }, -- roof 3
		},
	},
	-- Make sure both harbour office spawns are enabled regardless of difficulty
	[103106] = filter_easy_above,
	-- Disable the helicopter turret since it does nothing anyway
	[101257] = disabled,
	-- Enable unused sniper spawns
	[100376] = enabled,
	[100375] = enabled,
	[100374] = enabled,
	[100372] = enabled,
	-- Ambush bulldozers
	[101723] = dozer_chance,
	[101779] = dozer_chance,
	[101780] = dozer_chance,
	[101781] = dozer_chance,
	-- Scripted difficulty scaling
	[101630] = { -- add_water_front_spawns (Finale)
		on_executed = {
			{ id = 400002, delay = 0 },
			{ id = 101443, delay = 0 }, -- add another preferred to waterfront spawns
			{ id = 100021, delay = 30, delay_rand = 30 }, -- delay the remaining watefront spawns to make it easier to advance
			{ id = 101441, delay = 30, delay_rand = 30 },
		},
	},
	-- Spawn group intervals (so fucking many)
	[100128] = standard_spawn,
	[100130] = standard_spawn,
	[100131] = standard_spawn,
	[100132] = standard_spawn,
	[100133] = standard_spawn,
	[100007] = standard_spawn,
	[100030] = standard_spawn,
	[100692] = standard_spawn,
	[101263] = standard_spawn,
	[101264] = standard_spawn,
	[101267] = standard_spawn,
	[101268] = standard_spawn,
	[101269] = standard_spawn,
	[101270] = standard_spawn,
	[101271] = standard_spawn,
	[101420] = standard_spawn,
	[101444] = standard_spawn,
	[101446] = standard_spawn,
	[101448] = standard_spawn,
	[101450] = standard_spawn,
	[101452] = standard_spawn,
	[101454] = standard_spawn,
	[101456] = standard_spawn,
	[101458] = standard_spawn,
	[101363] = standard_spawn,
	[101954] = standard_spawn,
	[101957] = standard_spawn,
	[101959] = standard_spawn,
	[101961] = standard_spawn,
	[101965] = standard_spawn,
	[104810] = standard_spawn,
	[105463] = standard_spawn,
	[105463] = standard_spawn,
	[101266] = standard_spawn,
	[100019] = close_spawn,
	[101442] = close_spawn,
	[100693] = rappel_spawn,
	[101265] = rappel_spawn,
	[101963] = rappel_spawn,
	[101967] = rappel_spawn,
	[101969] = rappel_spawn,
	[101971] = rappel_spawn,
	[104809] = rappel_spawn,
	[104812] = rappel_spawn,
	[104814] = rappel_spawn,
	[104816] = rappel_spawn,
	[100844] = cloaker_spawn,
	[100848] = cloaker_spawn,
	[100852] = cloaker_spawn,
	[100856] = cloaker_spawn,
	[100860] = cloaker_spawn,
	[100864] = cloaker_spawn,
	[100868] = cloaker_spawn,
	[100873] = cloaker_spawn,
	[100847] = cloaker_spawn,
	[100867] = cloaker_spawn,
	[106311] = cloaker_spawn,
	[106318] = cloaker_spawn,
	[106319] = cloaker_spawn,
	[106320] = cloaker_spawn,
	[106327] = cloaker_spawn,
	[106328] = cloaker_spawn,
	[106329] = cloaker_spawn,
	[106336] = cloaker_spawn,
	[106337] = cloaker_spawn,
	[106338] = cloaker_spawn,
	[106814] = cloaker_spawn,
	[106815] = cloaker_spawn,
	[106816] = cloaker_spawn,
	[106817] = cloaker_spawn,
}
