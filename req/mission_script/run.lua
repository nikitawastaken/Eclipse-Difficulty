local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local heli_chance = is_eclipse_pro and 100 or is_eclipse and 85 or 12.5 * diff_i
local dozer_spawn_chance = is_eclipse and 50 or 25
local heli_spawn1 = {
	enemy = is_eclipse_pro and scripted_enemy.elite_bulldozer_1 or scripted_enemy.bulldozer_1,
}
local heli_spawn2 = {
	enemy = is_eclipse_pro and scripted_enemy.elite_bulldozer_2 or scripted_enemy.taser_1,
}
local garage_swat_spawn_1 = {
	enemy = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1,
	values = {
		enabled = true,
		participate_to_group_ai = false,
	},
	on_executed = {
		{ delay = 2, id = 410002 },
	},
}
local garage_swat_spawn_2 = {
	enemy = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2,
	values = {
		enabled = true,
		participate_to_group_ai = false,
	},
	on_executed = {
		{ delay = 2, id = 410002 },
	},
}
local garage_shield_spawn = {
	enemy = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield,
	values = {
		enabled = true,
		participate_to_group_ai = false,
	},
	on_executed = {
		{ delay = 2, id = 410002 },
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local helicopter_guaranteed_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
local van_guaranteed_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
local van_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents,
}
local overpass_spawn = {
	values = {
		interval = 10,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local inkwell_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_shields_bulldozers,
}
local inkwell_agile_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local armitage_spawn = {
	values = {
		interval = 40,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local overpass_agile_spawn = {
	values = {
		interval = 40,
		interval_balance_mul = { 1.3, 1.1, 0.9, 0.7 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local armitage_far_spawn = {
	values = {
		interval = 60,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local swat_heli_incoming = {
	values = {
		comment = "p41",
	},
}
local garage_event_triggered = {
	values = {
		comment = "v18",
	},
}
local spawn_anim_fix = {
	spawn_action = "e_sp_down_16m_right",
}
local objective_diff_add = {
	difficulty_addends = {
		{
			amount = 0.1875,
			time = 30,
			delay = 0,
		},
	},
}
local assault_end_diff_add = {
	difficulty_addends = {
		{
			amount = 0.125,
			time = 30,
			delay = 0,
		},
	},
}

return {
	[101356] = {
		ponr = {
			length = 480,
			length_balance_mul = { 2.5, 2, 1.5, 1 },
		},
	},
	-- restore events from PDTH
	-- inkwell industrial
	-- replace PDTH SWAT leftovers
	[102911] = garage_swat_spawn_1,
	[103022] = garage_swat_spawn_1,
	[103023] = garage_swat_spawn_2,
	[102907] = garage_shield_spawn,
	-- add custom unit sequence for opening the gate
	[102376] = {
		on_executed = {
			{ remove = true, id = 102906 },
			{ delay = 1, id = 400098 },
		},
	},
	-- armitage ave.
	-- replace PDTH SWAT leftovers
	[102630] = garage_swat_spawn_2,
	[102509] = garage_swat_spawn_2,
	[100432] = garage_shield_spawn,
	[100364] = garage_shield_spawn,
	-- add custom unit sequence for opening the gate
	[100612] = {
		on_executed = {
			{ remove = true, id = 100665 },
			{ delay = 1, id = 400099 },
		},
	},
	-- parking lot
	-- replace PDTH SWAT leftovers
	[102801] = garage_swat_spawn_1,
	[102800] = garage_swat_spawn_1,
	[101640] = garage_shield_spawn,
	[101756] = garage_shield_spawn,
	-- add custom unit sequence for opening the gate
	[102802] = {
		on_executed = {
			{ remove = true, id = 102797 },
			{ remove = true, id = 102413 },
			{ delay = 0.5, id = 410001 },
			{ delay = 1, id = 410000 },
		},
	},
	-- restore dozer kicking door event from PDTH
	[103517] = {
		on_executed = {
			{ remove = true, id = 103516 },
			{ delay = 0, id = 410003 },
		},
	},
	[103515] = {
		chance = dozer_spawn_chance,
	},
	-- restore first swat blockade on ovk above
	[102682] = {
		on_executed = {
			{ delay = 0, id = 410068 },
		},
	},
	-- restore cop cars having lights on
	[101037] = {
		on_executed = {
			{ delay = 0, id = 410069 },
		},
	},
	-- add commments on incoming helis or garage events
	[102109] = swat_heli_incoming,
	[102130] = swat_heli_incoming,
	[101950] = swat_heli_incoming,
	[102163] = swat_heli_incoming,
	[102166] = swat_heli_incoming,
	[102175] = swat_heli_incoming,
	[102186] = swat_heli_incoming,
	[101733] = garage_event_triggered,
	[102303] = garage_event_triggered,
	[102304] = garage_event_triggered,
	-- don't remove civs or enemies for no reason
	[101207] = disabled,
	[102047] = disabled,
	[103245] = disabled,
	-- ovk145-alike dozer spawn on armitage ave.
	[103592] = {
		values = {
			enabled = true,
		},
		chance = heli_chance,
	},
	[103591] = {
		values = {
			difficulty_overkill_145 = true, -- add ovk to low diff filter
			difficulty_normal = false, -- let's not do easy though
		},
	},
	[103590] = {
		values = {
			difficulty_overkill_145 = false, -- exclude ovk from eclipse only filter
		},
	},
	[103593] = {
		chance = heli_chance,
	},
	[103586] = heli_spawn1,
	[100232] = heli_spawn1,
	[100341] = heli_spawn2,
	[100351] = heli_spawn2,
	[101202] = {
		on_executed = {
			{ delay = 5, id = 100232 },
			{ delay = 5, id = 100341 },
			{ delay = 5, id = 100351 },
			{ delay = 5, id = 103586 },
			{ delay = 0, id = 101669 },
			{ delay = 15, id = 101648 },
		},
	},
	[103578] = {
		chance = 12.5 * diff_i, -- roof snipers ovk/eclipse chance
	},
	[103579] = {
		chance = 12.5 * diff_i, -- roof snipers normal/hard chance
	},
	[101412] = {
		chance = 10 * diff_i, -- alleyway sniper chance
	},
	[101010] = {
		values = {
			enabled = false, -- disable far armitage sniper trigger in the first sequence of the heist
		},
	},
	[101262] = {
		on_executed = {
			{ id = 100567, delay = 0 }, -- far armitage sniper
		},
	},
	[100567] = {
		values = {
			on_executed = {
				{ id = 103563, delay = 0 }, -- new SO for far armitage sniper
			},
		},
	},
	[103447] = {
		values = {
			enabled = true, -- reenable balcony parking lot sniper
			participate_to_group_ai = false,
			trigger_times = 1,
		},
	},
	[100959] = {
		on_executed = { -- roof snipers when you make a left turn to easy street
			{ id = 103581, delay = 0 }, -- ovk/eclipse filter
			{ id = 103582, delay = 0 }, -- normal/hard filter
		},
	},
	[103575] = {
		values = {
			amount = 3, -- reduce total amount of snipers per trigger
		},
	},
	-- make some snipers trigger only once
	[103538] = {
		values = {
			trigger_times = 1,
		},
	},
	[103537] = {
		values = {
			trigger_times = 1,
		},
	},
	[102866] = disabled,
	[102880] = disabled, -- disabled vanilla ponr
	-- delay the beginning of besiege
	--[[	
	[100631] = { -- area_player_spawn
		on_executed = {
			{ id = 400089, delay = 0 },
		},
	},
]]
	[100641] = {
		on_executed = {
			{ id = 101329, remove = true },
		},
	},
	[102435] = disabled,
	[100298] = disabled,
	-- add a missing cop to start beat cop sequence var1
	[101062] = {
		on_executed = {
			{ id = 400022, delay = 5 },
		},
	},
	-- custom scripted spawns
	[101240] = {
		on_executed = {
			{ id = 410070, delay = 0 },
		},
	},
	[103729] = {
		on_executed = {
			{ id = 410071, delay = 0 },
			{ id = 400087, delay = 0 },
			{ id = 400091, delay = 0 },
		},
	},
	[102087] = {
		on_executed = {
			{ id = 400012, delay = 0 },
		},
	},
	[100353] = {
		on_executed = {
			{ id = 410072, delay = 0 },
			{ id = 400085, delay = 0 },
		},
	},
	-- nuke the hunt_so loop, it isn't needed and it bugs out all of the lengthy spawn animations (heli spawns in this case)
	[100036] = disabled,
	-- fix inkwell industrial helicopter deploying smoke but not spawning any enemies
	[102212] = {
		values = {
			elements = {
				102232,
				102261,
				102273,
				102279,
			},
		},
	},
	-- fix inkwell heli enemies having pdth spawn anim leftovers
	[102232] = spawn_anim_fix,
	[102261] = spawn_anim_fix,
	[102273] = spawn_anim_fix,
	[102279] = spawn_anim_fix,
	[101173] = { -- change up the timers on this heli slightly so that it doesn't fly away too early
		on_executed = {
			{ id = 100476, delay = 1 },
			{ id = 100937, delay = 20 },
		},
	},
	-- Disable vanilla preferreds at the very start
	[100613] = disabled, -- 1st preferred add
	[103355] = disabled, -- 2nd preferred add
	[102106] = disabled, -- 3rd preferred add
	-- Add new spawngroups to existing preferreds
	[101239] = { -- ai_enemy_prefered_add_009 (Inkwell)
		values = {
			spawn_groups = {
				103703,
				103785,
				100441,
				103333,
				400073,
				400078,
			},
		},
	},
	[101441] = { -- ai_enemy_prefered_add_016 (Finale)
		values = {
			spawn_groups = {
				103740,
				101420,
				100029,
				410048,
				410053,
			},
		},
	},
	-- Scripted SWAT van spawns
	[100430] = { -- reached_first_crashsite_trigger
		on_executed = {
			{ id = 410005, delay = 0 }, -- Major Ave. SWAT vans 1
		},
	},
	[101434] = { -- before_crane_trigger
		on_executed = {
			{ id = 410007, delay = 0 }, -- Major Ave. SWAT vans 2
		},
	},
	[100636] = { -- corner_trigger_area
		on_executed = {
			{ id = 410009, delay = 0 }, -- East St. SWAT vans
		},
	},
	[100271] = { -- trigger_area_011
		on_executed = {
			{ id = 410042, delay = 0 }, -- Overpass SWAT vans 2
		},
	},
	-- note: second preferred add is executed on player_spawned
	[102426] = { -- player_spawned
		on_executed = {
			{ id = 100742, remove = true }, -- startup music
		},
	},
	[100830] = { -- trigger area Bruce
		on_executed = {
			--		{ id = 101757, delay = 0 }, -- fake assault end
			{ id = 101329, delay = 1 }, -- besiege start
		},
	},
	[100430] = { -- reached Eddie crash site
		reinforce = { -- add crane "blockade" reinforce
			{
				name = "major_ave01",
				force = 3,
				position = Vector3(-6075, -2125, 75),
			},
			{
				name = "major_ave02",
				force = 3,
				position = Vector3(-6075, -425, 75),
			},
		},
	},
	[102786] = { -- trigger area 53 (next to before crane #1 trigger)
		on_executed = {
			{ id = 400096, delay = 0 }, -- Major Ave. sniper
		},
	},
	[100101] = { -- remove enemies trigger (reached the construction crane)
		reinforce = { -- remove crane "blockade" reinforce
			{ name = "major_ave01" },
			{ name = "major_ave02" },
		},
	},
	[103726] = { -- remove_enemy_spawns trigger
		on_executed = {
			{ id = 400093, delay = 0 }, -- dozer ambush
			{ id = 400094, delay = 0 },
		},
	},
	[101339] = { -- trigger_area_009 (reached construction site)
		reinforce = { -- add Inkwell reinforce
			{
				name = "inkwell",
				force = 4,
				position = Vector3(-9250, -12775, 75),
			},
		},
		on_executed = { -- enable end_assault global event trigger
			{ id = 410074, delay = 0 },
		},
	},
	[103883] = { -- Matt is out, go to parking
		reinforce = { -- remove Inkwell reinforce
			{ name = "inkwell" },
		},
	},
	[103885] = { -- reached gate
		reinforce = { -- add alley "blockade" reinforce
			{
				name = "armitage_ave01",
				force = 3,
				position = Vector3(-17300, -9500, 1050),
			},
			{
				name = "armitage_ave02",
				force = 3,
				position = Vector3(-15500, -9500, 1050),
			},
		},
		on_executed = {
			{ id = 410023, delay = 0 },
		},
	},
	[102486] = { -- trigger area 7
		reinforce = { -- remove Armitage Ave. "blockade" reinforce
			{ name = "armitage_ave01" },
			{ name = "armitage_ave02" },
		},
	},
	[103492] = { -- remove spawns trigger
		on_executed = {
			{ id = 410035, delay = 0 }, -- Overpass SWAT vans 1
		},
		reinforce = { -- add overpass "blockade" reinforce
			{
				name = "overpass01",
				force = 3,
				position = Vector3(-8400, -9500, 1580),
			},
			{
				name = "overpass02",
				force = 3,
				position = Vector3(-8400, -10250, 1580),
			},
		},
	},
	[100271] = { -- trigger area 11
		reinforce = { -- remove overpass "blockade" reinforce
			{ name = "overpass01" },
			{ name = "overpass02" },
		},
	},
	-- Disable one of the Inkwell van spawngroups (Eclipse has its own)
	[103704] = disabled,
	-- Difficulty scaling
	[103750] = objective_diff_add, -- diff_0_75
	[103751] = objective_diff_add, -- diff_1
	[410073] = assault_end_diff_add, -- end_assault
	-- Spawn group intervals
	[100071] = helicopter_guaranteed_spawn,
	[100476] = helicopter_guaranteed_spawn,
	[102354] = helicopter_guaranteed_spawn,
	[400027] = van_guaranteed_spawn,
	[400032] = van_guaranteed_spawn,
	[400037] = van_guaranteed_spawn,
	[400042] = van_guaranteed_spawn,
	[400048] = van_guaranteed_spawn,
	[400053] = van_guaranteed_spawn,
	[400058] = van_guaranteed_spawn,
	[400063] = van_guaranteed_spawn,
	[400068] = van_guaranteed_spawn,
	[410017] = van_guaranteed_spawn,
	[410022] = van_guaranteed_spawn,
	[410029] = van_guaranteed_spawn,
	[410034] = van_guaranteed_spawn,
	[410052] = van_guaranteed_spawn,
	[100249] = overpass_spawn,
	[101527] = overpass_spawn,
	[103998] = overpass_spawn,
	[100310] = van_spawn,
	[103701] = van_spawn,
	[103734] = van_spawn,
	[400073] = van_spawn,
	[400078] = van_spawn,
	[410041] = van_spawn,
	[410048] = van_spawn,
	[103703] = inkwell_spawn,
	[100910] = armitage_spawn,
	[102475] = armitage_spawn,
	[103553] = armitage_spawn,
	[100441] = inkwell_agile_spawn,
	[103333] = inkwell_agile_spawn,
	[103785] = inkwell_agile_spawn,
	[100029] = overpass_agile_spawn,
	[101420] = overpass_agile_spawn,
}
