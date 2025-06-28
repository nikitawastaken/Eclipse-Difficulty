local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local diff_i_no_norm = diff_i - 2
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = is_eclipse and is_pro_job
local ready_team_1 = scripted_enemy.ready_team_1
local swat_1 = scripted_enemy.swat_1
local heavy_2 = scripted_enemy.heavy_swat_2
local medic_1 = scripted_enemy.medic_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local elite_sniper = scripted_enemy.elite_sniper
local disabled = {
	values = {
		enabled = false,
	},
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}
local filter_normal_above = {
	values = Eclipse.utils.set_diff_groups("normal_above"),
}
local fbi_agents = {
	Idstring("units/payday2/characters/ene_fbi_office_1/ene_fbi_office_1"),
	Idstring("units/payday2/characters/ene_fbi_office_2/ene_fbi_office_2"),
	Idstring("units/payday2/characters/ene_fbi_office_3/ene_fbi_office_3"),
	Idstring("units/payday2/characters/ene_fbi_office_4/ene_fbi_office_4"),
	Idstring("units/payday2/characters/ene_fbi_female_2/ene_fbi_female_2"),
	Idstring("units/payday2/characters/ene_fbi_female_3/ene_fbi_female_3"),
	Idstring("units/payday2/characters/ene_fbi_female_4/ene_fbi_female_4"),
}
local fbi_agent = {
	enemy = fbi_agents,
}
local regular_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local eclipse_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local escape_dozer = {
	enemy = is_eclipse and eclipse_dozers or regular_dozers,
}
local harasser_enemy = is_eclipse and { [swat_1] = 15, [elite_sniper] = 1 } or swat_1
local harasser = {
	enemy = harasser_enemy,
}
local harassers = normal and 3 or hard and 4 or 5
local harasser_amount = {
	values = {
		amount = harassers,
	},
}
local harasser_counter = {
	values = {
		counter_target = harassers,
	},
}
local sniper_amount = {
	values = {
		amount = (normal and 4 or hard and 6 or 8) + (is_pro_job and 2 or 0),
	},
}
local law_team = {
	values = {
		team = "law1",
	},
}
local fbi_intro_so = {
	so_access_filter = { "cop", "fbi", "gangster" },
}
local heli_enemy1 = {
	enemy = is_eclipse_pro and eclipse_dozers or regular_dozers,
}
local heli_enemy2 = {
	enemy = heavy_2,
}
local heli_enemy3 = {
	enemy = heavy_2,
}
local heli_enemy4 = {
	enemy = diff_i < 5 and heavy_2 or medic_1,
}
local street_heli_amount = {
	values = {
		amount = 4,
		amount_random = 0,
	},
}
local street_heli_enemy = {
	enemy = ready_team_1,
}
local breach_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_shields_bulldozers,
}
local window_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local roof_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local new_cloaker_spawn = {
	values = {
		interval = 90,
	},
	groups = preferred.only_cloakers,
}
local chopper_delay_init = 420 - (diff_i_no_norm * 30) - (is_pro_job and 120 or 0)
local chopper_delay = 480 - (diff_i_no_norm * 15) - (is_pro_job and 90 or 0)
local harasser_delay = (normal and 60 or 30) - (is_pro_job and 15 or 0)
return {
	-- Combine some navigation areas
	[100053] = {
		ai_area = {
			{ 38, 39, 40 },
			{ 50, 51, 52 },
			{ 55, 78 },
			{ 61, 165 },
		},
	},
	--PONR
	[100695] = {
		ponr = {
			length = 60,
			player_mul = { 1.25, 1, 0.75, 0.5 },
		},
	},
	-- Add new reinforce
	[101825] = { -- Interrogation started
		difficulty = 0.75,
		reinforce = {
			{
				name = "staircase_main1",
				force = 2,
				position = Vector3(-1250, -2750, 300),
			},
			{
				name = "staircase_main2",
				force = 2,
				position = Vector3(-1250, -2750, 1000),
			},
			{
				name = "staircase_side1",
				force = 2,
				position = Vector3(-1250, 975, 475),
			},
			{
				name = "staircase_side2",
				force = 2,
				position = Vector3(-1850, 1000, 1375),
			},
		},
		on_executed = { -- Bain diff increase line
			{ id = 103896, delay = 0 },
		},
	},
	-- Tweak diff scaling
	[102305] = disabled, -- saw in place, diff 0.75
	[101760] = disabled, -- interrogation started, diff 1
	[102305] = { -- initial diff
		values = {
			difficulty = 0.5,
		},
	},
	[102013] = { -- 1st hack done
		difficulty = 1,
	},
	-- Multiple interrupts once more (pain)
	[102978] = {
		on_executed = {
			{ id = 103385, delay = 0 },
		},
	},
	-- fix Taxman's getting into the limo event
	[101581] = {
		on_executed = {
			{ id = 101599, delay = 2.5 },
			{ id = 101582, delay = 2.5 },
		},
	},
	[101578] = {
		on_executed = {
			{ id = 101582, remove = true },
			{ id = 101599, remove = true },
		},
	},
	-- lower no-fence chance for Pro Jobs
	[102766] = {
		chance = is_pro_job and 100 or 50,
	},
	-- Enables/disables NPCs flashlights when the power is off/on like in PDTH
	[100756] = {
		flashlight = true,
	},
	[101801] = {
		flashlight = false,
	},
	-- fix the early loud issue
	[103178] = {
		values = {
			elements = {
				102601,
				102600,
				102599,
				102602,
				102633,
				102634,
				101614,
				103078,
				103079,
				102591,
				102592,
				102588,
				102586,
				101575,
				101946,
				101949,
				101948,
				101955,
				101956,
				101957,
				101953,
				101952,
				104051,
				103315,
				104055,
				104054,
				104059,
				104058,
				104060,
				104061,
				104056,
				104057,
				104052,
				104053,
			},
		},
	},
	-- increase the amount of planks
	[101661] = {
		values = {
			amount = 20,
		},
	},
	-- add new cloaker spawns to dummy trigger
	-- on spawn
	[103544] = {
		values = {
			elements = {
				400000,
			},
		},
	},
	-- disable the spawn
	[103535] = {
		values = {
			elements = {
				400000,
			},
		},
	},
	-- enable the spawn
	[103534] = {
		values = {
			elements = {
				400000,
			},
		},
	},
	-- on spawn
	[103540] = {
		values = {
			elements = {
				400001,
			},
		},
	},
	-- disable the spawn
	[103531] = {
		values = {
			elements = {
				400001,
			},
		},
	},
	-- enable the spawn
	[103530] = {
		values = {
			elements = {
				400001,
			},
		},
	},
	-- on spawn
	[103479] = {
		values = {
			elements = {
				400002,
			},
		},
	},
	-- disable the spawn
	[103483] = {
		values = {
			elements = {
				400002,
			},
		},
	},
	-- enable the spawn
	[103482] = {
		values = {
			elements = {
				400002,
			},
		},
	},
	-- on spawn
	[103474] = {
		values = {
			elements = {
				400003,
			},
		},
	},
	-- disable the spawn
	[103473] = {
		values = {
			elements = {
				400003,
			},
		},
	},
	-- enable the spawn
	[103472] = {
		values = {
			elements = {
				400003,
			},
		},
	},
	-- replace cloaker spawngroup with new one
	[103792] = {
		on_executed = {
			{ id = 103798, remove = true },
		},
	},
	[100130] = {
		on_executed = {
			{ id = 400005, delay = 20 },
			{ id = 103765, remove = true },
			{ id = 103766, remove = true },
		},
	},
	-- get rid off medium spawn
	[100055] = {
		on_executed = {
			{ id = 103589, remove = true },
		},
	},
	-- trigger taser chopper event if the limo stays on the roof
	[101782] = {
		on_executed = {
			{ id = 400010, delay = 60, delay_rand = is_pro_job and 60 or 90 },
		},
	},
	-- tweak the PC hack to use PDTH values
	-- lower floor
	-- startup and first hack
	[102119] = {
		on_executed = {
			{ id = 103798, remove = true },
			{ id = 400013, delay = 9 },
		},
	},
	-- higher floor
	[102338] = {
		on_executed = {
			{ id = 102339, remove = true },
			{ id = 400016, delay = 9 },
		},
	},
	-- second hack
	[102103] = {
		on_executed = {
			-- lower floor
			{ id = 102050, remove = true },
			{ id = 400014, delay = 0 },
			-- higher floor
			{ id = 102340, remove = true },
			{ id = 400017, delay = 0 },
		},
	},
	-- third hack
	[102104] = {
		on_executed = {
			-- lower floor
			{ id = 102051, remove = true },
			{ id = 400015, delay = 0 },
			-- higher floor
			{ id = 102342, remove = true },
			{ id = 400018, delay = 0 },
		},
	},
	-- toggles (lower floor)
	[102038] = {
		values = {
			elements = {
				102036,
				102056,
				102264,
				102052,
				400013, -- first hack
				102119,
				400014, -- second hack
				400015, -- third hack
				102071,
				102011,
				102085,
				102086,
				102049,
				102324,
				101866,
				102323,
				101844,
				102009,
				102833,
				102867,
				102832,
				103095,
				100234,
				100235,
				101815,
				103213,
				103242,
				103418,
				103776,
				103822,
				103804,
				103465,
				102956,
				102631,
				103783,
			},
		},
	},
	-- toggles (higher floor)
	[102039] = {
		values = {
			elements = {
				102037,
				102057,
				102265,
				102282,
				102343,
				400016, -- first hack
				102338,
				400017, -- second hack
				400018, -- third hack
				102341,
				102345,
				102344,
				102336,
				102871,
				102332,
				102333,
				102935,
				102335,
				102830,
				102938,
				102829,
				102954,
				100008,
				100208,
				101816,
				103214,
				103241,
				103419,
				103775,
				103777,
				103823,
				103805,
				103870,
				101969,
				102632,
				103799,
			},
		},
	},
	-- Unused snipers
	[102160] = enabled,
	[101815] = disabled,
	[101816] = disabled,
	[102155] = enabled,
	[102156] = enabled,
	[102157] = enabled,
	[102238] = enabled,
	[102232] = enabled,
	[102191] = enabled,
	-- Disable this element which disables 7 Sniper spawns when the limo lands on the balcony
	[101267] = disabled,
	-- Sniper amounts
	[102167] = sniper_amount,
	[102168] = sniper_amount,
	[102169] = sniper_amount,
	[102170] = sniper_amount,
	[102171] = sniper_amount,
	-- Gas Heli shit (it's evil)
	[104041] = {
		values = filter_normal_above.values, -- No need for these filters to handle spawns
		on_executed = { -- Spawn 4 heli enemies
			{ id = 104045, delay = 0 },
			{ id = 104046, delay = 0 },
		},
	},
	[104042] = filter_disable,
	[104043] = filter_disable,
	[104044] = filter_disable,
	[103298] = {
		on_executed = {
			{ id = 101716, delay = 1.5 }, -- enemy spawn delay (normally 0, causing them to spawn before the door opens)
			{ id = 103299, delay = 6 }, -- flyaway delay (normally 20)
		},
	},
	-- Replace the spawns with a Dozer + Medic + 2 Heavy Shotgunners
	[103293] = heli_enemy1,
	[103294] = heli_enemy2,
	[104045] = heli_enemy3,
	[104046] = heli_enemy4,
	[104047] = heli_enemy1,
	[104048] = heli_enemy2,
	[104049] = heli_enemy3,
	[104050] = heli_enemy4,
	[103295] = {
		on_executed = {
			{ id = 102950, remove = true }, -- Remove bain's *chopper coming in, roof guys roof!* as it doesn't deploy tear gas anymore
			{ id = 103298, delay = 24 }, -- door open delay (normally 27)
		},
	},
	[100131] = { -- police called, call in da choppa
		on_executed = {
			{ id = 101608, delay = chopper_delay_init, delay_rand = 120 },
		},
	},
	[101608] = {
		values = {
			trigger_times = 0,
		},
	},
	[102010] = {
		on_executed = {
			{ id = 101608, remove = true },
			{ id = 103765, delay = 60, delay_rand = 30 }, -- trigger the c4 breach during hacking objetives rather than in police_called
			{ id = 103766, delay = 60, delay_rand = 30 },
		},
	},
	[103765] = {
		values = {
			trigger_times = 1,
		},
	},
	[103766] = {
		values = {
			trigger_times = 1,
		},
	},
	[103434] = {
		values = filter_normal_above.values,
		on_executed = {
			{ id = 101608, delay = chopper_delay, delay_rand = 60 },
		},
	},
	-- The other (lame) chopper
	[102629] = street_heli_amount,
	[100431] = street_heli_amount,
	[102628] = street_heli_amount,
	[104067] = street_heli_amount,
	[102599] = street_heli_enemy,
	[102600] = street_heli_enemy,
	[102601] = street_heli_enemy,
	[102602] = street_heli_enemy,
	[103315] = street_heli_enemy,
	[104051] = street_heli_enemy,
	[104052] = street_heli_enemy,
	[104053] = street_heli_enemy,
	[104054] = street_heli_enemy,
	[104055] = street_heli_enemy,
	[104056] = street_heli_enemy,
	[104057] = street_heli_enemy,
	[104058] = street_heli_enemy,
	[104059] = street_heli_enemy,
	[104060] = street_heli_enemy,
	[104061] = street_heli_enemy,
	-- Escape harassers amount
	[102444] = {
		values = {
			amount = harassers,
			amount_random = 3,
		},
	},
	-- Regular harasser stuff
	[102269] = {
		on_executed = {
			{ id = 102268, delay = harasser_delay, delay_rand = 30 },
		},
	},
	[101731] = {
		on_executed = {
			{ id = 102269, delay = 0 },
		},
	},
	[102268] = harasser_amount,
	[103247] = harasser_counter,
	[102946] = harasser_counter,
	[103833] = {
		on_executed = {
			{ id = 103832, delay = harasser_delay, delay_rand = 30 },
		},
	},
	[103832] = harasser_amount,
	[103837] = harasser_counter,
	[103835] = harasser_counter,
	--  Keep close roof harassers after sawing the limo open
	[102989] = disabled,
	-- Vent cloaker group, disable this non-vent spawn point
	[103801] = disabled,
	[103366] = { -- why do cloakers have gas masks if the masks cant handle gas? -Idk.
		on_executed = {
			{ id = 103458, remove = true },
		},
	},
	[103441] = {
		on_executed = {
			{ id = 103794, remove = true },
		},
	},
	-- Give saw to all players
	[101865] = {
		func = function(self)
			managers.network:session():send_to_peers_synched("give_equipment", self._values.equipment, self._values.amount)
		end,
	},
	-- This disables multiple spawn points when limo lands on the balcony, which is weird, to say the least
	[101898] = disabled,
	-- No code chance increase on fail or knockout
	[102865] = {
		on_executed = {
			{ id = 102887, remove = true },
		},
	},
	[102872] = {
		on_executed = {
			{ id = 102887, remove = true },
		},
	},
	-- Code chance increase each time taxman is hit
	[102006] = {
		on_executed = {
			{ id = 102887, delay = 0 },
		},
	},
	[102868] = {
		on_executed = {
			{ id = 102887, delay = 0 },
		},
	},
	-- Faint duration increase
	[102860] = {
		values = {
			action_duration_min = 60,
			action_duration_max = 90,
		},
	},
	-- C4 explosion amount increase for Pro Jobs (the building won't collapse if they do that, they're elites)
	[102088] = {
		values = {
			amount = is_pro_job and 2 or 1,
		},
	},
	-- Spawn group delays
	-- Undercover might be a pretty cramped heist, but its spawns are pretty well distributed.
	-- Originally the spawns were nothing to write home about, so I had to come up with my own delays.
	-- Most notably, the spawn group behind which slides into the corrider through a hole in the wall has been slowed down and cannot be used by Shield groups, it's hard to slide like that with a massive shield.
	-- Window spawns are much slower too, having enemies spawn right next to you is pretty annoying.
	[102368] = breach_spawn,
	[101940] = window_spawn,
	[101954] = window_spawn,
	[101950] = window_spawn,
	[101951] = window_spawn,
	[101937] = roof_spawn,
	[102189] = roof_spawn,
	[400004] = new_cloaker_spawn,
	-- Scripted FBI agents
	[101614] = fbi_agent,
	[102633] = fbi_agent,
	[102634] = fbi_agent,
	[102591] = fbi_agent,
	[102592] = fbi_agent,
	[102586] = fbi_agent,
	[102588] = fbi_agent,
	-- set the undercover cops be on law team (so the FBI won't kill them)
	[101609] = law_team,
	[101612] = law_team,
	[103078] = law_team,
	[103079] = law_team,
	-- tweak SO access
	[102610] = fbi_intro_so,
	-- Escape Dozers
	[102433] = escape_dozer,
	[102434] = escape_dozer,
	-- Harassers
	[102436] = harasser,
	[102437] = harasser,
	[102438] = harasser,
	[102439] = harasser,
	[102446] = harasser,
	[102448] = harasser,
	[102450] = harasser,
	[103228] = harasser,
	[103234] = harasser,
	[103235] = harasser,
	[103236] = harasser,
	[103237] = harasser,
	[102097] = harasser,
	[102443] = harasser,
	[103839] = harasser,
	[103841] = harasser,
	[103843] = harasser,
	[103845] = harasser,
	[103847] = harasser,
	[103849] = harasser,
}
