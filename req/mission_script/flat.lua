local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_pro_job = Eclipse.utils.is_pro_job()
local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local enabled_blocked_roof_access = math.random() <= 0.45 + (is_pro_job and 0.1 or 0)
local gangsters = {
	Idstring("units/payday2/characters/ene_gang_black_1/ene_gang_black_1"),
	Idstring("units/payday2/characters/ene_gang_black_2/ene_gang_black_2"),
	Idstring("units/payday2/characters/ene_gang_black_3/ene_gang_black_3"),
	Idstring("units/payday2/characters/ene_gang_black_4/ene_gang_black_4"),
	Idstring("units/payday2/characters/ene_gang_mexican_1/ene_gang_mexican_1"),
	Idstring("units/payday2/characters/ene_gang_mexican_2/ene_gang_mexican_2"),
	Idstring("units/payday2/characters/ene_gang_mexican_3/ene_gang_mexican_3"),
	Idstring("units/payday2/characters/ene_gang_mexican_4/ene_gang_mexican_4"),
}
local chavez_dealer = Idstring("units/pd2_dlc_flat/characters/npc_jamaican/npc_jamaican")
local enabled = {
	values = {
		enabled = true,
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local sniper_kills = {
	values = {
		counter_target = normal and 6 or hard and 8 or 10,
	},
}
local retrigger = {
	values = {
		trigger_times = 0,
	},
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_spawn = {
	values = {
		interval = 120,
	},
	groups = preferred.only_cloakers,
}
local gangster = {
	enemy = gangsters,
}
local dealer = {
	enemy = chavez_dealer,
}
local dealer_walk_so = {
	values = {
		patrol_path = "inpath2",
	},
}
return {
	-- Add point of no return
	[101016] = {
		ponr = {
			length = 180,
			player_mul = { 1.33, 1.167, 1, 1 },
		},
	},
	-- Restore roof access blockade
	[100095] = {
		on_executed = {
			{ id = 100569, remove = true },
			{ id = 400064, delay = 0 },
		},
	},
	[100297] = {
		values = {
			enabled = enabled_blocked_roof_access,
		},
		on_executed = {
			{ id = 103611, delay = 0 },
			{ id = 400065, delay = 0 },
		},
	},
	[100569] = enabled,
	[103610] = enabled,
	[103611] = enabled,
	[103648] = {
		on_executed = {
			{ id = 103611, remove = true },
		},
	},
	-- stop with the smoke bombs, jeez....
	[103034] = disabled,
	[103106] = disabled,
	-- 2 scripted cloakers spawn on overkill and above when the cops arrive
	[100314] = {
		on_executed = {
			{ id = 103038, delay = overkill_and_above and 20 or math.huge },
			{ id = 103080, delay = overkill_and_above and 20 or math.huge },
		},
	},
	-- make some beat cops camp near police cars
	[100040] = {
		on_executed = {
			{ id = 102579, remove = true },
		},
	},
	[100035] = {
		on_executed = {
			{ id = 102579, remove = true },
		},
	},
	[100037] = {
		on_executed = {
			{ id = 102579, remove = true },
		},
	},
	-- disable scripted spawn spam
	[101745] = disabled,
	-- disable "passive cloaker spawns"
	[104185] = disabled,
	-- add new cloaker spawn groups reusing vanilla enemy dummies
	[100270] = { -- remove a random disconnected SWAT from this group, he is a Cloaker now
		values = {
			elements = {
				101669,
				103217,
				103225,
				103226,
			},
		},
	},
	[102087] = { -- add back spawns
		on_executed = {
			{ id = 400057, delay = 0, delay_rand = 20 },
		},
	},
	-- don't remove ground level spawns at any point
	[102092] = disabled,
	[102097] = disabled,
	-- disable cloaker spawns on startup
	[102263] = {
		on_executed = {
			{ id = 400039, delay = 3 },
		},
	},
	-- Add new reinforce
	[100533] = { -- saws are done, roof objectives begin
		reinforce = {
			{
				name = "third_floor",
				force = 2,
				position = Vector3(-925, 600, 700),
			},
			{
				name = "fourth_floor",
				force = 2,
				position = Vector3(-1600, 500, 1025),
			},
		},
	},
	-- add missing navlinks
	[103247] = {
		on_executed = {
			{ id = 102468, delay = 0 },
			{ id = 104179, delay = 0 },
			{ id = 102455, delay = 0 },
			{ id = 104720, delay = 0 },
			{ id = 102454, delay = 0 },
			{ id = 104721, delay = 0 },
			{ id = 102453, delay = 0 },
			{ id = 104341, delay = 0 },
			{ id = 104338, delay = 0 },
			{ id = 104342, delay = 0 },
			{ id = 104343, delay = 0 },
			{ id = 103402, delay = 0 },
			{ id = 103888, delay = 0 },
			{ id = 103890, delay = 0 },
			{ id = 102377, delay = 0 },
			{ id = 104709, delay = 0 },
			{ id = 102399, delay = 0 },
			{ id = 104708, delay = 0 },
			{ id = 102401, delay = 0 },
			{ id = 104707, delay = 0 },
		},
	},
	-- trigger event spawns after each start of the assault wave
	[104656] = {
		on_executed = {
			{ id = 400015, delay = 30 },
			{ id = 400020, delay = 60 },
			{ id = 400037, delay = 75 },
		},
	},
	-- spawn Shields after placing the last c4
	[101787] = {
		on_executed = {
			{ id = 400043, delay = 0 },
		},
	},
	-- spawn Rooftop Heavy SWATs after killing all of the snipers
	-- enable Cloaker spawns
	-- increase diff
	[104573] = {
		on_executed = {
			{ id = 400025, delay = 15 },
			{ id = 400038, delay = 0 },
		},
	},
	--change chopper squad
	[101658] = {
		on_executed = {
			{ id = 104561, remove = true },
			{ id = 400032, delay = 17 },
		},
	},
	-- delay Bile's chopper trigger after c4 blows up
	[100082] = {
		on_executed = {
			{ id = 101562, delay = 110 },
		},
	},
	-- trigger dozer spawn during the escape
	[104706] = {
		reinforce = { -- remove reinforce
			{ name = "third_floor" },
			{ name = "fourth_floor" },
		},
		on_executed = {
			{ id = 400040, delay = 0 },
		},
	},
	-- cops now spawn when you open the red door rather than when killing Chavez (like in PDTH)
	[101853] = {
		on_executed = {
			{ id = 104691, remove = true },
		},
	},
	-- call the cops when the red door opens
	[102680] = {
		on_executed = {
			{ id = 104691, delay = 0 },
		},
	},
	-- spawn Heavy SWAT squad if it's overkill above
	-- earlier cops
	[100528] = {
		on_executed = {
			{ id = 400001, delay = 10 },
			{ id = 103960, delay = 20 }, -- make the cop cars sequence always trigger after 20 seconds
		},
	},
	-- late cops
	[100527] = {
		on_executed = {
			{ id = 400001, delay = 45 },
		},
	},
	-- more oppressive open door amounts
	[103616] = { -- tweak 4th floor front doors
		on_executed = {
			{ id = 100517, delay = 2 }, -- normally executed by random elements in 103490, potential softlock if not executed
		},
	},
	[103490] = {
		values = {
			amount = 0,
			amount_random = 2,
		},
	},
	[103491] = {
		on_executed = {
			{ id = 100517, remove = true },
		},
	},
	[103492] = {
		on_executed = {
			{ id = 100517, remove = true },
		},
	},
	[103455] = { -- fewer open doors to the coke lab
		values = {
			amount = 0,
			amount_random = 2,
		},
	},
	[103618] = { -- fewer other open doors
		values = {
			amount = 1, -- potential softlock if none
			amount_random = 2,
		},
	},
	-- disable roof/stairs reinforcement
	[103181] = disabled, -- 5, fucking, force
	-- adjust the Sniper kill objective
	[104516] = sniper_kills,
	[104692] = sniper_kills,
	[104693] = sniper_kills,
	-- re-allow sniper respawns
	[104556] = disabled,
	-- reenable far sniper
	[101521] = enabled,
	[101599] = {
		values = {
			trigger_times = 0,
			enabled = true,
		},
	},
	[103143] = retrigger,
	[103134] = retrigger,
	[103137] = retrigger,
	[103130] = retrigger,
	[103126] = retrigger,
	[102833] = retrigger,
	[101801] = retrigger,
	[102614] = retrigger,
	[102612] = retrigger,
	[103148] = retrigger,
	[103168] = retrigger,
	[100793] = retrigger,
	[100645] = retrigger,
	[103111] = retrigger,
	[100693] = retrigger,
	-- disable panic room reenforce (sh disables the other two points, and this heist doesnt really need it)
	[103348] = disabled,
	-- ambush line fix ?  hasnt been working for me since forever
	[100501] = {
		values = {
			use_play_func = true,
		},
	},
	-- reduce delay on mask up when ambushed (this triggers loud)
	[102329] = {
		on_executed = {
			{ id = 102332, delay = 1.5 },
		},
	},
	-- reenable alleyway drop
	[102261] = {
		values = {
			on_executed = {
				{ delay = 0, id = 101591 },
				{ delay = 0, id = 101573 },
				{ delay = 0, id = 100350 },
			},
		},
	},
	-- enable civilian on bridge
	[103353] = enabled,
	[103354] = {
		values = {
			SO_access = managers.navigation:convert_access_filter_to_number({ "civ_male" }),
		},
	},
	-- always make dealer walk up to 4th floor (from ASS)
	[101888] = dealer_walk_so,
	[101891] = dealer_walk_so,
	[101899] = dealer_walk_so,
	-- change gangster spawns
	-- outside
	[101881] = gangster,
	[101395] = gangster,
	[101746] = gangster,
	[101749] = gangster,
	[102330] = gangster,
	[102333] = gangster,
	[102335] = gangster,
	[100767] = gangster,
	[102717] = gangster,
	[102718] = gangster,
	-- 1st floor
	[102332] = gangster,
	[100085] = gangster,
	[102456] = gangster,
	[102197] = gangster,
	[101375] = gangster,
	[101743] = gangster,
	[100169] = gangster,
	[101802] = gangster,
	[101804] = gangster,
	-- 2nd floor
	[102596] = gangster,
	[102592] = gangster,
	[101401] = gangster,
	[101539] = gangster,
	[101540] = gangster,
	[101433] = gangster,
	[101435] = gangster,
	[102586] = gangster,
	[101668] = gangster,
	[101434] = gangster,
	-- 3rd floor
	[104793] = gangster,
	[102563] = gangster,
	[101441] = gangster,
	[102558] = gangster,
	[101442] = gangster,
	[102564] = gangster,
	[101422] = gangster,
	[101437] = gangster,
	[103450] = gangster,
	-- 4th floor
	[100431] = gangster,
	[101661] = gangster,
	[104889] = gangster,
	[100234] = gangster,
	[104930] = gangster,
	[104932] = gangster,
	[100496] = gangster,
	[100495] = gangster,
	[100494] = gangster,
	[100484] = gangster,
	-- 5th floor
	[101425] = gangster,
	[100418] = gangster,
	[100081] = gangster,
	[101200] = gangster,
	[101438] = gangster,
	[103702] = gangster,
	[103703] = gangster,
	[102191] = gangster,
	[102192] = gangster,
	[102193] = gangster,
	-- basement
	[100253] = gangster,
	[100236] = gangster,
	[103102] = gangster,
	[103101] = gangster,
	[100305] = gangster,
	[103104] = gangster,
	[103180] = gangster,
	[103103] = gangster,
	[102562] = gangster,
	[103179] = gangster,
	-- misc
	-- dealer
	[104782] = dealer,

	[100025] = gangster,
	[100039] = gangster,
	[100050] = gangster,
	[100055] = gangster,
	[100056] = gangster,
	[100057] = gangster,
	[101512] = gangster,
	[102170] = gangster,
	[101421] = gangster,
	[102165] = gangster,

	[100513] = gangster,
	[100512] = gangster,
	[100516] = gangster,
	[104781] = gangster,
	[100407] = gangster,
	[100406] = gangster,
	[100409] = gangster,

	-- 145+ room (unused)
	[103231] = gangster,
	[103232] = gangster,
	[103234] = gangster,
	[103235] = gangster,
	[103236] = gangster,
	-- slow down roof spawns, these are really fuckng annoying
	[104650] = roof_spawn,
	[100504] = roof_spawn,
	[100505] = roof_spawn,
	[100509] = roof_spawn,
	[100396] = roof_spawn,
	[400053] = cloaker_spawn,
	[400054] = cloaker_spawn,
	[400055] = cloaker_spawn,
	[400056] = cloaker_spawn,
}
