local preferred = Eclipse.preferred
local set_diff_groups = Eclipse.utils.set_diff_groups
local filter_easy_above = {
	values = set_diff_groups("easy_above"),
}
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
local standard_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local waterfront_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local rappel_spawn = {
	values = {
		interval = 40,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
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
local scripted_diff_add = {
	amount = 0.25,
	time = { 20, 30 },
	delay = 0,
}

return {
	-- Add new reinforce
	[100109] = { -- police
		reinforce = {
			{
				name = "gate",
				force = 3,
				position = Vector3(2925, -3225, 0),
			},
			{
				name = "warehouse_a",
				force = 3,
				position = Vector3(-325, 2150, 0),
			},
			{
				name = "warehouse_b",
				force = 3,
				position = Vector3(1200, -120, 0),
			},
			{
				name = "warehouse_c",
				force = 3,
				position = Vector3(450, -2750, 0),
			},
		},
	},
	[101369] = { -- input_close_first_gate
		difficulty_addends = {
			scripted_diff_add,
		},
		reinforce = {
			{ name = "gate" },
			{ name = "warehouse_a" },
			{ name = "warehouse_b" },
			{ name = "warehouse_c" },
		},
	},
	[103885] = { -- output_signal_activated
		difficulty_addends = {
			scripted_diff_add,
		},
		reinforce = {
			{
				name = "harbor",
				force = 5,
				position = Vector3(15275, -3225, -300),
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
			{ id = 101280, delay = 30 }, -- roof 1
			{ id = 101279, delay = 30 }, -- roof 2
			{ id = 101272, delay = 30 }, -- roof 3
		},
	},
	-- make sure both harbour office spawns are enabled regardless of difficulty
	[103106] = filter_easy_above,
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
	[100128] = standard_spawn,
	[100130] = standard_spawn,
	[100131] = standard_spawn,
	[100132] = standard_spawn,
	[100133] = standard_spawn,
	[101270] = standard_spawn,
	[100007] = standard_spawn,
	[100019] = standard_spawn,
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
	[101442] = standard_spawn,
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
	[105463] = waterfront_spawn,
	[100693] = rappel_spawn,
	[101265] = rappel_spawn,
	[101266] = rappel_spawn,
	[101963] = rappel_spawn,
	[101967] = rappel_spawn,
	[101969] = rappel_spawn,
	[101971] = rappel_spawn,
	[104809] = rappel_spawn,
	[104812] = rappel_spawn,
	[104814] = rappel_spawn,
	[104816] = rappel_spawn,
}
