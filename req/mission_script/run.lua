local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job

local heli_chance = is_eclipse_pro and 100 or is_eclipse and 85 or 12.5 * diff_i

local heli_enemy1 = is_eclipse_pro and scripted_enemy.elite_bulldozer_1 or scripted_enemy.bulldozer_1
local heli_enemy2 = is_eclipse_pro and scripted_enemy.elite_bulldozer_2 or scripted_enemy.taser_1

local heli_spawn1 = {
	enemy = heli_enemy1,
}

local heli_spawn2 = {
	enemy = heli_enemy2,
}

local disabled = {
	values = {
		enabled = false,
	},
}
local major_ave_spawn_1 = {
	values = {
		interval = 10,
	},
}
local major_ave_spawn_2 = {
	values = {
		interval = 10,
	},
}

return {
	[101356] = {
		ponr = {
			length = 480,
			player_mul = { 2.5, 2, 1.5, 1 },
		},
	},
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
		values = {
			on_executed = {
				{ delay = 5, id = 100232 },
				{ delay = 5, id = 100341 },
				{ delay = 5, id = 100351 },
				{ delay = 5, id = 103586 },
				{ delay = 0, id = 101669 },
				{ delay = 15, id = 101648 },
			},
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
	[100029] = {
		values = {
			interval = 20,
		},
	},
	-- slow down inkwell industrial spawnpoints
	[100441] = {
		values = {
			interval = 60,
		},
	},
	[103333] = {
		values = {
			interval = 40,
		},
	},
	[103719] = {
		values = {
			interval = 30,
		},
	},
	-- slow down major ave. spawnpoints
	[100265] = major_ave_spawn_1,
	[103961] = major_ave_spawn_1,
	[100597] = major_ave_spawn_1,
	[103702] = major_ave_spawn_2,
	[103701] = major_ave_spawn_2,
	-- delay the beginning of besiege
	[100631] = {
		on_executed = {
			{ id = 400089, delay = 0 },
		},
	},
	[100641] = {
		on_executed = {
			{ id = 101329, remove = true },
		},
	},
	[101049] = {
		on_executed = {
			{ id = 101757, remove = true },
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
			{ id = 400000, delay = 0 },
			{ id = 400001, delay = 0 },
			{ id = 400002, delay = 0 },
			{ id = 400003, delay = 0 },
			{ id = 101476, delay = 0 }, -- tenth preferred add (have to put it here but whatever)
		},
	},
	[103729] = {
		on_executed = {
			{ id = 400008, delay = 0 },
			{ id = 400009, delay = 0 },
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
			{ id = 400018, delay = 0 },
			{ id = 400020, delay = 0 },
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
	[101173] = { -- change up the timers on this heli slightly so that it doesn't fly away too early
		on_executed = {
			{ id = 100476, delay = 1 },
			{ id = 100937, delay = 20 },
		},
	},

	-- rework spawngroups for the entire chase section cause they're absolutely dogshit in vanilla
	-- lots of comments here so that i don't lose track of anything

	-- first disable all of the trash vanilla spawngroups
	[101431] = disabled,
	[102316] = disabled,
	[103957] = disabled,
	[103946] = disabled,
	[103940] = disabled,
	-- reuse the closest major ave. spawngroups + new swat van spawn (2nd preferred)
	[103355] = {
		values = {
			spawn_groups = { 100265, 103961, 400042 },
		},
	},
	-- main major ave. spawngroups with enemies properly coming out of swat vans (3rd preferred)
	[102106] = {
		values = {
			spawn_groups = { 400037, 400032, 400027, 400053 },
		},
	},
	-- farther backwards major ave. crossroad spawngroups with enemies properly coming out of swat vans (4th preferred)
	[102418] = {
		values = {
			spawn_groups = { 100597, 400048, 400053 },
		},
	},
	-- easy st. swat van spawns (5th preferred)
	[102440] = {
		values = {
			spawn_groups = { 400063, 400058, 400068, 400083 },
		},
	},
	-- farther easy st. swat van spawns (6th preferred)
	[102944] = {
		values = {
			spawn_groups = { 400068, 400073, 400078, 400083 },
		},
		on_executed = {
			{ id = 102734, remove = true }, -- 7th preferred add
		},
	},
	-- inkwell blockade swat van spawns (7th preferred)
	[102734] = {
		values = {
			spawn_groups = { 400073, 400078 },
		},
		on_executed = {
			{ id = 101086, delay = 0 }, -- 9th preferred (back to vanilla spawngroups)
		},
	},
	-- just disabled it for now, easier to skip (8th preferred)
	[100256] = disabled,
	[100281] = disabled,
	[101216] = { -- useless trigger close to eddie
		on_executed = {
			{ id = 102440, remove = true }, -- 5th preferred add
		},
	},
	[100570] = { -- useless trigger close to eddie #2
		on_executed = {
			{ id = 102418, remove = true }, -- 4th preferred add
		},
	},
	[103725] = { -- trigger area 054
		on_executed = {
			{ id = 102945, remove = true }, -- 6th preferred remove
		},
	},
	-- note: second preferred add is executed on player_spawned
	[102426] = { -- player_spawned
		on_executed = {
			{ id = 101476, remove = true }, -- 10th preferred
			{ id = 103355, remove = true }, -- 2nd preferred add
			{ id = 100742, remove = true }, -- startup music
		}, --  seriously what the fuck? why would you have enemies spawn all the way at the PARKING LOT - ARMITAGE AVE. ALLEYWAY while the players are only leaving SPAWN
	},
	[102098] = { -- reached first crossing trigger
		on_executed = {
			{ id = 102106, remove = true }, -- 3rd preferred add
		},
	},
	[100830] = { -- area bruce trigger
		on_executed = {
			{ id = 103356, remove = true }, -- 2nd preferred remove
			{ id = 103355, delay = 0 }, -- 2nd preferred add
			{ id = 101757, delay = 0 }, -- fake assault end
			{ id = 101329, delay = 1 }, -- besiege start
		},
	},
	[103082] = { -- trigger area 33 (useless trigger close to eddie #3)
		on_executed = {
			{ id = 102440, remove = true }, -- 5th preferred add
			{ id = 102419, remove = true }, -- 3rd preferred remove
		},
	},
	[100430] = { -- reached first crashsite trigger (eddie car crash)
		on_executed = {
			{ id = 103356, delay = 0 }, -- 2nd preferred remove
			{ id = 102106, delay = 0 }, -- 3rd preferred add
		},
	},
	[102786] = { -- trigger area 53 (next to before crane #1 trigger)
		on_executed = {
			{ id = 400096, delay = 0 }, -- major ave. sniper
			{ id = 102735, remove = true }, -- 4th preferred remove
		},
	},
	[102119] = { -- before crane #2 trigger
		on_executed = {
			{ id = 102419, delay = 0 }, -- 3rd preferred remove
			{ id = 102418, delay = 0 }, -- 4th preferred add
			{ id = 102944, remove = true }, -- 6th preferred add
		},
	},
	[100101] = { -- remove enemies trigger (reached the construction crane)
		on_executed = {
			{ id = 102735, delay = 0 }, -- 4th preferred remove
			{ id = 102440, delay = 0 }, -- 5th preferred add
			{ id = 102484, remove = true }, -- 5th preferred remove
		},
	},
	[400043] = { -- reached easy st. vans trigger
		on_executed = {
			{ id = 102484, delay = 0 }, -- 5th preferred remove
			{ id = 102944, delay = 0 }, -- 6th preferred add
			{ id = 101477, delay = 0 }, -- 10th preferred remove
		},
	},
	[103726] = { -- remove_enemy_spawns trigger
		on_executed = {
			{ id = 102445, remove = true }, -- 7th preferred remove
			{ id = 101477, remove = true }, -- 10th preferred remove
			{ id = 400093, delay = 0 }, -- dozer ambush
			{ id = 400094, delay = 0 },
		},
	},
	[400084] = { -- reached easy far st. vans trigger
		on_executed = {
			{ id = 102945, delay = 0 }, -- 6th preferred remove
			{ id = 102734, delay = 0 }, -- 7th preferred add
		},
	},
	[103883] = { -- matt is out, go to parking
		on_executed = {
			{ id = 102445, delay = 0 }, -- 7th preferred remove
		},
	},
}
