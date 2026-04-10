local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local cop_1 = scripted_enemy.cop_1
local cop_2 = scripted_enemy.cop_2
local cop_3 = scripted_enemy.cop_3
local gensec_security = scripted_enemy.gensec_1
local cops = {
	cop_1,
	cop_2,
	cop_3,
	cop_1,
}
local beat_cops = {
	enemy = cops,
	values = {
		participate_to_group_ai = true,
	},
}
local gensec_enemy = {
	enemy = gensec_security,
}
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
local roof_far_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents,
}
local roof_close_spawn = {
	values = {
		interval = 45,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents,
}
local vault_spawn = {
	values = {
		interval = 45,
		interval_balance_mul = { 1.4, 1.2, 1, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local difficulty_add_20 = {
	difficulty_add = 0.20,
}
local bags_required = {
	values = {
		counter_target = (is_eclipse and 6 or 4) + (is_pro_job and 2 or 0),
	},
}
local exclude_cop_agents_shields_dozers = {
	so_access_filter = { "swat", "taser", "spooc" },
}
local vis_blockers = {}
local vis_blocker_ids = Idstring("units/dev_tools/level_tools/dev_ai_vis_blocker/dev_ai_vis_blocker_005x2x2m")
for i = 0, 11 do
	local y = 1300 - (i * 200)
	table.insert(vis_blockers, {
		name = vis_blocker_ids,
		pos = Vector3(-4240, y, 1060),
		visible = false,
	})
	table.insert(vis_blockers, {
		name = vis_blocker_ids,
		pos = Vector3(-2365, y, 1060),
		visible = false,
	})
end
return {
	[100757] = { -- first responders
		reinforce = {
			{
				name = "atrium_upper01",
				force = 2,
				position = Vector3(-4000, -2200, 750),
			},
			{
				name = "atrium_upper02",
				force = 2,
				position = Vector3(-2750, -2200, 750),
			},
			{
				name = "atrium_upper03",
				force = 2,
				position = Vector3(-2750, -1000, 750),
			},
			{
				name = "atrium_upper04",
				force = 2,
				position = Vector3(-4000, -1000, 750),
			},
		},
	},
	[100170] = { -- objective 8, entered the vault
		reinforce = {
			{
				name = "vault_entrance",
				force = 2,
				position = Vector3(-3300, -2100, 30),
			},
			{
				name = "atrium_lower01",
				force = 2,
				position = Vector3(-3800, -800, 400),
			},
			{
				name = "atrium_lower02",
				force = 2,
				position = Vector3(-2700, -800, 400),
			},
		},
	},
	-- Add scripted difficulty increases
--	[103049] = difficulty_add_20, -- obj_completed_013 (hacks done)
--	[100066] = difficulty_add_20, -- obj_complete004 (CFO escort done)
--	[100168] = difficulty_add_20, -- obj_started008 (vault is open)
	-- change the required amount of diamond bags
	[101608] = bags_required,
	[101609] = bags_required,
	[102003] = bags_required,
	[104657] = bags_required,
	[104658] = bags_required,
	[100177] = disabled,
	-- Disable outline for Ralph if he is tied
	[100461] = {
		on_executed = {
			{ id = 100082, delay = 0 },
		},
	},
	-- disable endless
	[101967] = disabled,
	[102061] = disabled,
	-- tweak almost all of SOs
	-- e_nl_dah_jump_down
	[104226] = exclude_cop_agents_shields_dozers,
	[104227] = exclude_cop_agents_shields_dozers,
	[104229] = exclude_cop_agents_shields_dozers,
	[104231] = exclude_cop_agents_shields_dozers,
	[104306] = exclude_cop_agents_shields_dozers,
	[104625] = exclude_cop_agents_shields_dozers,
	[104626] = exclude_cop_agents_shields_dozers,
	[104627] = exclude_cop_agents_shields_dozers,
	-- e_nl_dah_climb_up
	[100877] = exclude_cop_agents_shields_dozers,
	[102388] = exclude_cop_agents_shields_dozers,
	[102389] = exclude_cop_agents_shields_dozers,
	[102390] = exclude_cop_agents_shields_dozers,
	[104035] = exclude_cop_agents_shields_dozers,
	[104039] = exclude_cop_agents_shields_dozers,
	-- e_nl_dah_down_window_swing (SO FUCKING MANY, WHY THERE ARE SO MANY?????)
	[104225] = exclude_cop_agents_shields_dozers,
	[104282] = exclude_cop_agents_shields_dozers,
	[104283] = exclude_cop_agents_shields_dozers,
	[104285] = exclude_cop_agents_shields_dozers,
	[104286] = exclude_cop_agents_shields_dozers,
	[104287] = exclude_cop_agents_shields_dozers,
	[102398] = exclude_cop_agents_shields_dozers,
	[104289] = exclude_cop_agents_shields_dozers,
	[104292] = exclude_cop_agents_shields_dozers,
	[104293] = exclude_cop_agents_shields_dozers,
	[104294] = exclude_cop_agents_shields_dozers,
	[104295] = exclude_cop_agents_shields_dozers,
	[104298] = exclude_cop_agents_shields_dozers,
	[104299] = exclude_cop_agents_shields_dozers,
	[104302] = exclude_cop_agents_shields_dozers,
	[104303] = exclude_cop_agents_shields_dozers,
	[104305] = exclude_cop_agents_shields_dozers,
	[104307] = exclude_cop_agents_shields_dozers,
	[104565] = exclude_cop_agents_shields_dozers,
	[104566] = exclude_cop_agents_shields_dozers,
	[104569] = exclude_cop_agents_shields_dozers,
	[104570] = exclude_cop_agents_shields_dozers,
	[104571] = exclude_cop_agents_shields_dozers,
	[104572] = exclude_cop_agents_shields_dozers,
	[104575] = exclude_cop_agents_shields_dozers,
	[104576] = exclude_cop_agents_shields_dozers,
	[104580] = exclude_cop_agents_shields_dozers,
	[104581] = exclude_cop_agents_shields_dozers,
	[104582] = exclude_cop_agents_shields_dozers,
	[104584] = exclude_cop_agents_shields_dozers,
	[104585] = exclude_cop_agents_shields_dozers,
	[104586] = exclude_cop_agents_shields_dozers,
	[104587] = exclude_cop_agents_shields_dozers,
	[104590] = exclude_cop_agents_shields_dozers,
	[104591] = exclude_cop_agents_shields_dozers,
	[104592] = exclude_cop_agents_shields_dozers,
	[104593] = exclude_cop_agents_shields_dozers,
	[104596] = exclude_cop_agents_shields_dozers,
	[104597] = exclude_cop_agents_shields_dozers,
	[104598] = exclude_cop_agents_shields_dozers,
	[104599] = exclude_cop_agents_shields_dozers,
	[104602] = exclude_cop_agents_shields_dozers,
	[104603] = exclude_cop_agents_shields_dozers,
	[104604] = exclude_cop_agents_shields_dozers,
	[104430] = exclude_cop_agents_shields_dozers,
	[104431] = exclude_cop_agents_shields_dozers,
	[104484] = exclude_cop_agents_shields_dozers,
	[104485] = exclude_cop_agents_shields_dozers,
	[104486] = exclude_cop_agents_shields_dozers,
	[104663] = exclude_cop_agents_shields_dozers,
	[104670] = exclude_cop_agents_shields_dozers,
	[104671] = exclude_cop_agents_shields_dozers,
	[104672] = exclude_cop_agents_shields_dozers,
	[104673] = exclude_cop_agents_shields_dozers,
	[104674] = exclude_cop_agents_shields_dozers,
	[104677] = exclude_cop_agents_shields_dozers,
	[104678] = exclude_cop_agents_shields_dozers,
	[104679] = exclude_cop_agents_shields_dozers,
	[104680] = exclude_cop_agents_shields_dozers,
	[104683] = exclude_cop_agents_shields_dozers,
	[104684] = exclude_cop_agents_shields_dozers,
	[104685] = exclude_cop_agents_shields_dozers,
	[104686] = exclude_cop_agents_shields_dozers,
	[104689] = exclude_cop_agents_shields_dozers,
	[104690] = exclude_cop_agents_shields_dozers,
	[104691] = exclude_cop_agents_shields_dozers,
	[104692] = exclude_cop_agents_shields_dozers,
	[104695] = exclude_cop_agents_shields_dozers,
	[104696] = exclude_cop_agents_shields_dozers,
	[104697] = exclude_cop_agents_shields_dozers,
	[104698] = exclude_cop_agents_shields_dozers,
	[100312] = exclude_cop_agents_shields_dozers,
	[100313] = exclude_cop_agents_shields_dozers,
	[100317] = exclude_cop_agents_shields_dozers,
	[100318] = exclude_cop_agents_shields_dozers,
	[100322] = exclude_cop_agents_shields_dozers,
	[100323] = exclude_cop_agents_shields_dozers,
	[100324] = exclude_cop_agents_shields_dozers,
	[100325] = exclude_cop_agents_shields_dozers,
	-- e_nl_dah_up_roof_low
	[101220] = exclude_cop_agents_shields_dozers,
	[101385] = exclude_cop_agents_shields_dozers,
	[101386] = exclude_cop_agents_shields_dozers,
	[101387] = exclude_cop_agents_shields_dozers,
	[101470] = exclude_cop_agents_shields_dozers,
	[101472] = exclude_cop_agents_shields_dozers,
	[101477] = exclude_cop_agents_shields_dozers,
	[101479] = exclude_cop_agents_shields_dozers,
	[101480] = exclude_cop_agents_shields_dozers,
	[101481] = exclude_cop_agents_shields_dozers,
	[101482] = exclude_cop_agents_shields_dozers,
	[101485] = exclude_cop_agents_shields_dozers,
	[101496] = exclude_cop_agents_shields_dozers,
	[101501] = exclude_cop_agents_shields_dozers,
	[101502] = exclude_cop_agents_shields_dozers,
	[101503] = exclude_cop_agents_shields_dozers,
	[101504] = exclude_cop_agents_shields_dozers,
	-- e_nl_dah_climd_up_window_left/e_nl_dah_climd_up_window_right (climd instead of climb, what a typo)
	[102391] = exclude_cop_agents_shields_dozers,
	[104230] = exclude_cop_agents_shields_dozers,
	[104237] = exclude_cop_agents_shields_dozers,
	[104238] = exclude_cop_agents_shields_dozers,
	[104236] = exclude_cop_agents_shields_dozers,
	[104239] = exclude_cop_agents_shields_dozers,
	[104240] = exclude_cop_agents_shields_dozers,
	[104241] = exclude_cop_agents_shields_dozers,
	[104246] = exclude_cop_agents_shields_dozers,
	[104247] = exclude_cop_agents_shields_dozers,
	[104248] = exclude_cop_agents_shields_dozers,
	[104249] = exclude_cop_agents_shields_dozers,
	[104252] = exclude_cop_agents_shields_dozers,
	[104256] = exclude_cop_agents_shields_dozers,
	[101877] = exclude_cop_agents_shields_dozers,
	[104259] = exclude_cop_agents_shields_dozers,
	[104260] = exclude_cop_agents_shields_dozers,
	[104263] = exclude_cop_agents_shields_dozers,
	[104266] = exclude_cop_agents_shields_dozers,
	[104269] = exclude_cop_agents_shields_dozers,
	[102374] = exclude_cop_agents_shields_dozers,
	[102377] = exclude_cop_agents_shields_dozers,
	[104275] = exclude_cop_agents_shields_dozers,
	[104277] = exclude_cop_agents_shields_dozers,
	[104284] = exclude_cop_agents_shields_dozers,
	[100647] = exclude_cop_agents_shields_dozers,
	[104116] = exclude_cop_agents_shields_dozers,
	[104438] = exclude_cop_agents_shields_dozers,
	[104439] = exclude_cop_agents_shields_dozers,
	[104440] = exclude_cop_agents_shields_dozers,
	[104441] = exclude_cop_agents_shields_dozers,
	[104442] = exclude_cop_agents_shields_dozers,
	[104918] = exclude_cop_agents_shields_dozers,
	[104919] = exclude_cop_agents_shields_dozers,
	[104920] = exclude_cop_agents_shields_dozers,
	[104921] = exclude_cop_agents_shields_dozers,
	[104922] = exclude_cop_agents_shields_dozers,
	[104923] = exclude_cop_agents_shields_dozers,
	[102400] = exclude_cop_agents_shields_dozers,
	[102402] = exclude_cop_agents_shields_dozers,
	[102403] = exclude_cop_agents_shields_dozers,
	[102406] = exclude_cop_agents_shields_dozers,
	[102407] = exclude_cop_agents_shields_dozers,
	[102408] = exclude_cop_agents_shields_dozers,
	[102476] = exclude_cop_agents_shields_dozers,
	[102477] = exclude_cop_agents_shields_dozers,
	[102478] = exclude_cop_agents_shields_dozers,
	[104721] = exclude_cop_agents_shields_dozers,
	[104722] = exclude_cop_agents_shields_dozers,
	[104723] = exclude_cop_agents_shields_dozers,
	[104724] = exclude_cop_agents_shields_dozers,
	[104725] = exclude_cop_agents_shields_dozers,
	[104726] = exclude_cop_agents_shields_dozers,
	[104727] = exclude_cop_agents_shields_dozers,
	[104728] = exclude_cop_agents_shields_dozers,
	-- e_nl_down_4m_jump
	[100651] = exclude_cop_agents_shields_dozers,
	[100652] = exclude_cop_agents_shields_dozers,
	[100653] = exclude_cop_agents_shields_dozers,
	[100654] = exclude_cop_agents_shields_dozers,
	[100655] = exclude_cop_agents_shields_dozers,
	[100656] = exclude_cop_agents_shields_dozers,
	[100657] = exclude_cop_agents_shields_dozers,
	[100658] = exclude_cop_agents_shields_dozers,
	[100659] = exclude_cop_agents_shields_dozers,
	[100660] = exclude_cop_agents_shields_dozers,
	[101427] = exclude_cop_agents_shields_dozers,
	[101438] = exclude_cop_agents_shields_dozers,
	[101864] = exclude_cop_agents_shields_dozers,
	[101869] = exclude_cop_agents_shields_dozers,
	-- e_nl_dah_down_roof_rapel
	[103848] = exclude_cop_agents_shields_dozers,
	[104228] = exclude_cop_agents_shields_dozers,
	[104279] = exclude_cop_agents_shields_dozers,
	[104280] = exclude_cop_agents_shields_dozers,
	[104281] = exclude_cop_agents_shields_dozers,
	[104607] = exclude_cop_agents_shields_dozers,
	[104608] = exclude_cop_agents_shields_dozers,
	[104609] = exclude_cop_agents_shields_dozers,
	[104610] = exclude_cop_agents_shields_dozers,
	[100611] = exclude_cop_agents_shields_dozers,
	[104826] = exclude_cop_agents_shields_dozers,
	[104827] = exclude_cop_agents_shields_dozers,
	[104828] = exclude_cop_agents_shields_dozers,
	[104829] = exclude_cop_agents_shields_dozers,
	[104830] = exclude_cop_agents_shields_dozers,
	[104831] = exclude_cop_agents_shields_dozers,
	[104837] = exclude_cop_agents_shields_dozers,
	[104838] = exclude_cop_agents_shields_dozers,
	[104839] = exclude_cop_agents_shields_dozers,
	[104840] = exclude_cop_agents_shields_dozers,
	-- atrium navlinks
	[102127] = exclude_cop_agents_shields_dozers,
	[104068] = exclude_cop_agents_shields_dozers,
	[104069] = exclude_cop_agents_shields_dozers,
	[104070] = exclude_cop_agents_shields_dozers,
	[100788] = exclude_cop_agents_shields_dozers,
	[100787] = exclude_cop_agents_shields_dozers,
	[100797] = exclude_cop_agents_shields_dozers,
	[100798] = exclude_cop_agents_shields_dozers,
	[100785] = exclude_cop_agents_shields_dozers,
	[100786] = exclude_cop_agents_shields_dozers,
	[100789] = exclude_cop_agents_shields_dozers,
	[100800] = exclude_cop_agents_shields_dozers,
	[104612] = exclude_cop_agents_shields_dozers,
	[100799] = exclude_cop_agents_shields_dozers,
	[100801] = exclude_cop_agents_shields_dozers,
	[100802] = exclude_cop_agents_shields_dozers,
	[104613] = exclude_cop_agents_shields_dozers,
	[104614] = exclude_cop_agents_shields_dozers,
	[104615] = exclude_cop_agents_shields_dozers,
	[104664] = exclude_cop_agents_shields_dozers,
	[104665] = exclude_cop_agents_shields_dozers,
	[101473] = exclude_cop_agents_shields_dozers,
	[101505] = exclude_cop_agents_shields_dozers,
	-- e_nl_dah_climd_up_elevator/e_nl_dah_climd_down_elevator (same typo)
	[101285] = exclude_cop_agents_shields_dozers,
	[101292] = exclude_cop_agents_shields_dozers,
	[101293] = exclude_cop_agents_shields_dozers,
	[101294] = exclude_cop_agents_shields_dozers,
	[101506] = exclude_cop_agents_shields_dozers,
	[101509] = exclude_cop_agents_shields_dozers,
	-- disable atrium snipers on startup
	[100000] = {
		on_executed = {
			{ id = 400077, delay = 3 },
		},
		spawn = vis_blockers, -- Add vis blockers
	},
	-- delay the elevator spawn
	-- trigger the 3 cloakers event
	-- enable autrium snipers
	[100429] = {
		on_executed = {
			{ id = 102128, delay = 45 },
			{ id = 102196, delay = 10 },
			{ id = 400076, delay = 0 },
		},
	},
	-- replace guards in elevator with beat cops
	[100104] = beat_cops,
	[101787] = beat_cops,
	[102812] = beat_cops,
	[102813] = beat_cops,
	[102814] = beat_cops,
	--[[ replace Secret Service with GenSec Red Security (like in PDTH)
	[100034] = gensec_enemy,
	[100041] = gensec_enemy,
	[102322] = gensec_enemy,
	[102323] = gensec_enemy,
	[102326] = gensec_enemy,
	[102327] = gensec_enemy,
	[102328] = gensec_enemy,
	[101682] = gensec_enemy,
	[101718] = gensec_enemy,
	[101720] = gensec_enemy,
	[102450] = gensec_enemy,
	[101209] = gensec_enemy,
	[103561] = gensec_enemy,
	[102325] = gensec_enemy,
	[102458] = gensec_enemy,
	[102462] = gensec_enemy,
	[103574] = gensec_enemy,
	[103576] = gensec_enemy,
	[101261] = gensec_enemy,
	[103826] = gensec_enemy,
	[103827] = gensec_enemy,
	[103832] = gensec_enemy,
	[103834] = gensec_enemy,
	[102026] = gensec_enemy,
	[102028] = gensec_enemy,
	[102042] = gensec_enemy,
	[102043] = gensec_enemy,
	]]
	-- spawn dozer and 2 tasers on overkill above (comes a bit later after beat cops)
	[102128] = {
		on_executed = {
			{ id = 400061, delay = 40 },
			{ id = 400062, delay = 40 },
			{ id = 400063, delay = 40 },
		},
	},
	-- fix the elevator door
	[101642] = {
		values = {
			trigger_times = 0,
			elements = {
				102813,
				102812,
				102814,
				101787,
				100104,
				400061,
				400062,
				400063,
			},
		},
		on_executed = {
			{ id = 102820, delay = 8 },
		},
	},
	[101838] = {
		values = {
			sound_event = "elevator_doors_open",
		},
	},
	[101837] = {
		values = {
			sound_event = "elevator_doors_open",
		},
	},
	[102103] = disabled,
	-- Restore 3 cloakers event from PDTH
	-- remove 2 diff checkers, trigger it on hard and above
	[102196] = {
		values = {
			enabled = normal_and_above,
		},
		on_executed = {
			{ id = 102256, remove = true },
			{ id = 102257, remove = true },
			{ id = 102198, delay = 0 },
		},
	},
	-- add cloakers to mission scripts
	[102199] = {
		on_executed = {
			{ id = 102203, remove = true },
			{ id = 102204, remove = true },
			{ id = 102205, remove = true },
			{ id = 400007, delay = 0 },
			{ id = 400008, delay = 0.8 },
			{ id = 400009, delay = 1.3 },
		},
	},
	[102200] = {
		on_executed = {
			{ id = 102206, remove = true },
			{ id = 102207, remove = true },
			{ id = 102208, remove = true },
			{ id = 400004, delay = 0 },
			{ id = 400005, delay = 0.8 },
			{ id = 400006, delay = 1.3 },
		},
	},
	[102201] = {
		on_executed = {
			{ id = 102211, remove = true },
			{ id = 400001, delay = 0 },
			{ id = 400002, delay = 0.8 },
			{ id = 400003, delay = 1.3 },
		},
	},
	--spawn roof access blockades when CFO has been found (that respawn after 70 seconds of getting killed)
	--spawn dozer and 2 shields near helipad
	[100061] = {
		on_executed = {
			{ id = 400048, delay = 0 },
			{ id = 400049, delay = 1.4 },
			{ id = 400047, delay = 1.7 },
			{ id = 400055, delay = 0 },
			{ id = 400054, delay = 1.4 },
			{ id = 400053, delay = 1.7 },
			{ id = 400066, delay = 0 },
			{ id = 400067, delay = 0 },
			{ id = 400068, delay = 0 },
		},
	},
	--Spawn escape sniper when the heli escape gets triggered (also toggle ponr)
	[104949] = {
		set_ponr_state = true,
		on_executed = {
			{ id = 400059, delay = 3 },
		},
	},
	--Spawn atrium snipers when you pick up diamonds on loud
	[105129] = {
		on_executed = {
			{ id = 400072, delay = 0 },
			{ id = 400073, delay = 3 },
		},
	},
	--Get rid of cringe turret, replace with proper ambush from PDTH
	[104103] = {
		on_executed = {
			--be gone
			{ id = 102751, remove = true },
			--spawn snipers first
			{ id = 400010, delay = 3 },
			{ id = 400011, delay = 3 },
			{ id = 400012, delay = 3 },
			{ id = 400013, delay = 3 },
			--smoke bombs
			{ id = 400079, delay = 9 },
			{ id = 400080, delay = 9.5 },
			{ id = 400081, delay = 10 },
			--spawn SWAT squads with specials
			--1st squad
			{ id = 400023, delay = 11 },
			{ id = 400024, delay = 11 },
			{ id = 400025, delay = 11 },
			{ id = 400026, delay = 11 },
			{ id = 400027, delay = 11 },
			{ id = 400028, delay = 11 },
			{ id = 400018, delay = 11 },
			--2nd squad
			{ id = 400029, delay = 18 },
			{ id = 400030, delay = 18 },
			{ id = 400031, delay = 18 },
			{ id = 400032, delay = 18 },
			{ id = 400033, delay = 18 },
			{ id = 400034, delay = 18 },
			{ id = 400019, delay = 18 },
			{ id = 400022, delay = 18 },
			--3rd squad
			{ id = 400035, delay = 30 },
			{ id = 400036, delay = 30 },
			{ id = 400037, delay = 30 },
			{ id = 400038, delay = 30 },
			{ id = 400039, delay = 30 },
			{ id = 400040, delay = 30 },
			{ id = 400020, delay = 30 },
			--4th squad
			{ id = 400041, delay = 38 },
			{ id = 400042, delay = 38 },
			{ id = 400043, delay = 38 },
			{ id = 400044, delay = 38 },
			{ id = 400045, delay = 38 },
			{ id = 400046, delay = 38 },
			{ id = 400021, delay = 38 },
		},
	},
	-- add GenSec Security that tries to protect the CFO
	[103308] = {
		on_executed = {
			{ id = 400086, delay = 0 },
			{ id = 400087, delay = 0 },
		},
	},
	[103306] = {
		on_executed = {
			{ id = 400090, delay = 0 },
			{ id = 400091, delay = 0 },
		},
	},
	[103307] = {
		on_executed = {
			{ id = 410002, delay = 0 },
			{ id = 410003, delay = 0 },
		},
	},
	[103305] = {
		on_executed = {
			{ id = 400094, delay = 0 },
		},
	},
	-- Spawn Group delays
	[104896] = roof_close_spawn,
	[104852] = roof_close_spawn,
	[104846] = roof_close_spawn,
	[104764] = roof_close_spawn,
	[102772] = roof_close_spawn,
	[102784] = roof_far_spawn, -- intentionally slightly lower delay for the groups that are on the other side of the roof
	[102778] = roof_far_spawn,
	[100722] = vault_spawn,
	[100723] = vault_spawn,
	[104821] = vault_spawn,
	[104822] = vault_spawn,
}
