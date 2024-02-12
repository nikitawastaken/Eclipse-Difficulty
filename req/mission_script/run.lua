local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
local is_pro = Global.game_settings and Global.game_settings.one_down
local HeliDrop1 = Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")
local HeliDrop2 = Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
local HeliDropChance = 12.5 * diff_i
if diff_i == 6 and is_pro then -- you get fucked on eclipse pro job
	HeliDropChance = 85
	HeliDrop1 = Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
	HeliDrop2 = Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
end

return {
	[101356] = {
		ponr = {
			length = 480,
			player_mul = {2, 1.5, 1.25, 1}
		}
	},
	-- ovk145-alike dozer spawn on armitage ave.
	[103592] = {
		values = {
			enabled = true,
		},
		chance = HeliDropChance
	},
	[103591] = {
		values = {
			difficulty_overkill_145 = true, -- add ovk to low diff filter
			difficulty_normal = false, -- let's not do easy though
		},
	},
	[103590] = {
		values = {
			difficulty_overkill_145 = false -- exclude ovk from eclipse only filter
		}
	},
	[103593] = {
		chance = HeliDropChance
	},
	[103586] = {
		enemy = HeliDrop1,
		difficulty = 0.2 -- lower assault diff when bossfight begins
	},
	[100232] = {
		enemy = HeliDrop1
	},
	[100341] = {
		enemy = HeliDrop2
	},
	[100351] = {
		enemy = HeliDrop2
	},
	[101202] = {
		values = {
			on_executed = {
				{delay = 5, id = 100232},
				{delay = 5, id = 100341},
				{delay = 5, id = 100351},
				{delay = 5, id = 103586},
				{delay = 0, id = 101669},
				{delay = 15, id = 101648},
			}
		}
	},
	[100271] = {
		difficulty = 1 -- set difficulty to max after the bossfight
	},
	[103578] = {
		chance = 12.5 * diff_i -- roof snipers ovk/eclipse chance
	},
	[103579] = {
		chance = 12.5 * diff_i -- roof snipers normal/hard chance
	},
	[101412] = {
		chance = 10 * diff_i -- alleyway sniper chance
	},
	[101010] = {
		values = {
			enabled = false -- disable far armitage sniper trigger in the first sequence of the heist
		}
	},
	[101262] = {
		on_executed = {
			{ id = 100567, delay = 0} -- far armitage sniper
		}
	},
	[100567] = {
		values = {
			on_executed = {
				{ id = 103563, delay = 0 } -- new SO for far armitage sniper
			}
		}
	},
	[103447] = {
		values = {
			enabled = true, -- reenable balcony parking lot sniper
			participate_to_group_ai = false,
			trigger_times = 1
		}
	},
	[100959] = {
		on_executed = { -- roof snipers when you make a left turn to easy street
			{ id = 103581, delay = 0 }, -- ovk/eclipse filter
			{ id = 103582, delay = 0 }, -- normal/hard filter
		}
	},
	[103575] = { -- extra scripted sniper spots for ovk/eclipse filter
		values = {
			amount = 3 -- reduce total amount of snipers per trigger
		},
		on_executed = {
			{ id = 400085, delay = 0 },
			{ id = 400087, delay = 0 }
		}
	},
	-- make some snipers trigger only once
	[103538] = {
		values = {
			trigger_times = 1
		}
	},
	[103537] = {
		values = {
			trigger_times = 1
		}
	},
	[102866] = {
		values = {
			enabled = false -- disable vanilla ponr
		}
	},
	[102880] = {
		values = {
			enabled = false -- disable vanilla ponr
		}
	},
	[100029] = {
		values = {
			interval = 20
		}
	},
	-- slow down inkwell industrial spawnpoints
	[100441] = {
		values = {
			interval = 60
		}
	},
	[103333] = {
		values = {
			interval = 40
		}
	},
	[103719] = {
		values = {
			interval = 30
		}
	},
	-- slow down major ave. spawnpoints
	[100265] = {
		values = {
			interval = 10
		}
	},
	[103961] = {
		values = {
			interval = 10
		}
	},
	[100597] = {
		values = {
			interval = 10
		}
	},
	[103702] = {
		values = {
			interval = 15
		}
	},
	[103701] = {
		values = {
			interval = 15
		}
	},
	-- delay the beginning of besiege
	[100641] = {
		on_executed = {
			{ id = 101329, remove = true }
		}
	},
	[101270] = {
		on_executed = {
			{ id = 101329, delay = 10 }
		}
	},
	[102435] = { -- disable some scripted spawns that show up in the face cause of the delayed besiege
		values = {
			enabled = false
		}
	},
	-- add a missing cop to start beat cop sequence var1
	[101062] = {
		on_executed = {
			{ id = 400022, delay = 5 }
		}
	},
	-- custom scripted spawns
	[101240] = {
		on_executed = {
			{ id = 400000, delay = 0 },
			{ id = 400001, delay = 0 },
			{ id = 400002, delay = 0 },
			{ id = 400003, delay = 0 },
			{ id = 101476, delay = 0 }, -- tenth preferred add (have to put it here but whatever)
		}
	},
	[103729] = {
		on_executed = {
			{ id = 400008, delay = 0 },
			{ id = 400009, delay = 0 },
		}
	},
	[103214] = {
		on_executed = {
			{ id = 400012, delay = 0 },
		}
	},
	[100353] = {
		on_executed = {
			{ id = 400018, delay = 0 },
			{ id = 400020, delay = 0 }
		}
	},
	-- nuke the hunt_so loop, it isn't needed and it bugs out all of the lengthy spawn animations (heli spawns in this case)
	[100036] = {
		values = {
			enabled = false
		}
	},
	-- fix inkwell industrial helicopter deploying smoke but not spawning any enemies
	[102212] = {
		values = {
			elements = {
				102232,
				102261,
				102273,
				102279
			}
		}
	},
	[101173] = { -- change up the timers on this heli slightly so that it doesn't fly away too early
		on_executed = {
			{ id = 100476, delay = 1 },
			{ id = 100937, delay = 20}
		}
	},


	-- rework spawngroups for the entire chase section cause they're absolutely dogshit in vanilla
	-- lots of comments here so that i don't lose track of anything

	-- first disable all of the trash vanilla spawngroups
	[101431] = {
		values = {
			enabled = false -- this spawngroup is a single first preferred one which i'm too lazy to reuse so we'll just start with second preferred
		}
	},
	[102316] = {
		values = {
			enabled = false
		}
	},
	[103957] = {
		values = {
			enabled = false
		}
	},
	[103946] = {
		values = {
			enabled = false
		}
	},
	[103940] = {
		values = {
			enabled = false
		}
	},
	-- reuse the closest major ave. spawngroups + new swat van spawn (2nd preferred)
	[103355] = {
		values = {
			spawn_groups = { 100265, 103961, 400042 }
		}
	},
	-- main major ave. spawngroups with enemies properly coming out of swat vans (3rd preferred)
	[102106] = {
		values = {
			spawn_groups = { 400037, 400032, 400027, 400053 }
		}
	},
	-- farther backwards major ave. crossroad spawngroups with enemies properly coming out of swat vans (4th preferred)
	[102418] = {
		values = {
			spawn_groups = { 100597, 400048, 400053 }
		}
	},
	-- easy st. swat van spawns (5th preferred)
	[102440] = {
		values = {
			spawn_groups = { 400063, 400058, 400068, 400083 }
		}
	},
	-- farther easy st. swat van spawns (6th preferred)
	[102944] = {
		values = {
			spawn_groups = { 400068, 400073, 400078, 400083 }
		},
		on_executed = {
			{ id = 102734, remove = true }, -- 7th preferred add
		}
	},
	-- inkwell blockade swat van spawns (7th preferred)
	[102734] = {
		values = {
			spawn_groups = { 400073, 400078 }
		},
		on_executed = {
			{ id = 101086, delay = 0 } -- 9th preferred (back to vanilla spawngroups)
		}
	},
	-- just disabled it for now, easier to skip (8th preferred)
	[100256] = { -- add
		values = {
			enabled = false
		}
	},
	[100281] = { -- remove
		values = {
			enabled = false
		}
	},
	[101216] = { -- useless trigger close to eddie
		on_executed = {
			{ id = 102440, remove = true } -- 5th preferred add
		}
	},
	[100570] = { -- useless trigger close to eddie #2
		on_executed = {
			{ id = 102418, remove = true } -- 4th preferred add
		}
	},
	[103725] = { -- trigger area 054
		on_executed = {
			{ id = 102945, remove = true }, -- 6th preferred remove
		}
	},
	-- note: second preferred add is executed on player_spawned
	[102426] = { -- player_spawned
		on_executed = {
			{ id = 101476, remove = true } -- 10th preferred
		} --  seriously what the fuck? why would you have enemies spawn all the way at the PARKING LOT - ARMITAGE AVE. ALLEYWAY while the players are only leaving SPAWN
	},
	[102098] = { -- reached first crossing trigger
		on_executed = {
			{ id = 102106, remove = true } -- 3rd preferred add
		}
	},
	[100830] = { -- area bruce trigger
		on_executed = {
			{ id = 103356, remove = true }, -- 2nd preferred remove
		}
	},
	[103082] = { -- trigger area 33 (useless trigger close to eddie #3)
		on_executed = {
			{ id = 102440, remove = true }, -- 5th preferred add
			{ id = 102419, remove = true }, -- 3rd preferred remove
		}
	},
	[100430] = { -- reached first crashsite trigger (eddie car crash)
		on_executed = {
			{ id = 103356, delay = 0 }, -- 2nd preferred remove
			{ id = 102106, delay = 0 } -- 3rd preferred add
		}
	},
	[102119] = { -- before crane trigger
		on_executed = {
			{ id = 102419, delay = 0 }, -- 3rd preferred remove
			{ id = 102418, delay = 0 }, -- 4th preferred add
			{ id = 102944, remove = true } -- 6th preferred add
		}
	},
	[100101] = { -- remove enemies trigger (reached the construction crane)
		on_executed = {
			{ id = 102735, delay = 0 }, -- 4th preferred remove
			{ id = 102440, delay = 0 }, -- 5th preferred add
			{ id = 102484, remove = true } -- 5th preferred remove
		}
	},
	[400043] = { -- reached easy st. vans trigger
		on_executed = {
			{ id = 102484, delay = 0 }, -- 5th preferred remove
			{ id = 102944, delay = 0 }, -- 6th preferred add
			{ id = 101477, delay = 0 } -- 10th preferred remove
		}
	},
	[103726] = { -- remove_enemy_spawns trigger
		on_executed = {
			{ id = 102445, remove = true }, -- 7th preferred remove
			{ id = 101477, remove = true }, -- 10th preferred remove
		}
	},
	[400084] = { -- reached easy far st. vans trigger
		on_executed = {
			{ id = 102945, delay = 0  }, -- 6th preferred remove
			{ id = 102734, delay = 0  }, -- 7th preferred add
		}
	},
	[103883] = { -- matt is out, go to parking
		on_executed = {
			{ id = 102445, delay = 0 } -- 7th preferred remove
		}
	}
}
