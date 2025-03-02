local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy
-- credit for these changes goes to ASS, thanks miki <3
local mexicans = {
	Idstring("units/payday2/characters/ene_gang_mexican_1/ene_gang_mexican_1"),
	Idstring("units/payday2/characters/ene_gang_mexican_2/ene_gang_mexican_2"),
	Idstring("units/payday2/characters/ene_gang_mexican_3/ene_gang_mexican_3"),
	Idstring("units/payday2/characters/ene_gang_mexican_4/ene_gang_mexican_4"),
}
local sniper_groups = {
	values = {
		amount = normal and 1 or hard and 2 or 3,
	},
}
local sniper_amount_counter = {
	values = {
		counter_target = normal and 2 or hard and 4 or 6,
	},
}
local cloaker_spawn = {
	values = {
		enemy = normal and scripted_enemy.heavy_swat_1 or scripted_enemy.cloaker,
	},
}
local exclude_cop_agents_shields_dozers = {
	so_access_filter = { "swat", "taser", "spooc" },
}
local chopper_amount = is_eclipse and 2 or 1

return {
	-- replace Heavy SWATs that spawn from the chopper with cloakers on higher difficulties
	[101571] = cloaker_spawn,
	[101572] = cloaker_spawn,
	-- let bulldozer end his spawn anim before going into hunt mode
	[100952] = {
		on_executed = {
			{ id = 100376, delay = 3.25 },
		},
	},
	-- more snipers on higher difficulties
	[101070] = sniper_groups,
	-- prevent snipers from stacking up
	[101135] = sniper_amount_counter,
	[101142] = sniper_amount_counter,
	-- only let swats, tasers and cloakers use climbing SOs
	-- e_nl_up_3_down_1m
	[101483] = exclude_cop_agents_shields_dozers,
	[101484] = exclude_cop_agents_shields_dozers,
	[101485] = exclude_cop_agents_shields_dozers,
	[101486] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_6m_var2
	[101508] = exclude_cop_agents_shields_dozers,
	[101770] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_6m_var3
	[101509] = exclude_cop_agents_shields_dozers,
	[101510] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_1_down_7_1m
	[102124] = exclude_cop_agents_shields_dozers,
	[102125] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_7_down_1m_var2
	[101872] = exclude_cop_agents_shields_dozers,
	[101873] = exclude_cop_agents_shields_dozers,
	-- e_nl_up_rats_roof (exclusive SO anim)
	[101435] = exclude_cop_agents_shields_dozers,
	[101436] = exclude_cop_agents_shields_dozers,
	[101507] = exclude_cop_agents_shields_dozers,
	-- cops now use climbing SOs on first assault (Eclipse exclusive event)
	-- disable this on Eclipse
	[101496] = {
		values = {
			enabled = is_eclipse and false,
		},
	},
	-- hell
	[100676] = {
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	-- fix Bain's sniper warning repeating two times
	[101071] = {
		on_executed = {
			{ id = 101256, remove = true },
		},
	},
	[101073] = {
		on_executed = {
			{ id = 101256, remove = true },
		},
	},
	[101126] = {
		on_executed = {
			{ id = 101256, remove = true },
		},
	},
	[101137] = {
		on_executed = {
			{ id = 101256, delay = 60 },
		},
	},
	[101138] = {
		on_executed = {
			{ id = 101256, delay = 90 },
		},
	},
	[101141] = {
		on_executed = {
			{ id = 101256, delay = 140 },
		},
	},
	-- loop helis
	-- remove the line+trigger the loop here
	[100945] = {
		on_executed = {
			{ id = 100946, remove = true },
			{ id = 100965, delay = 180 },
		},
	},
	-- loop the choppa+2 chopper spawns on Eclipse
	[100966] = {
		values = {
			amount = chopper_amount,
		},
		on_executed = {
			{ id = 100965, delay = 300 },
		},
	},
	-- trigger_times to 0; making the loop possible
	[100953] = {
		values = {
			trigger_times = 0,
		},
	},
	[100887] = {
		values = {
			trigger_times = 0,
		},
	},
	-- disable this just in case
	[101652] = {
		values = {
			enabled = false,
		},
	},
	-- faster chopper
	[100888] = {
		on_executed = {
			{ id = 100893, remove = true },
			{ id = 100894, delay = 24 },
		},
	},
	-- planks amount, normally always 3, now you can get anywhere from fuck-all to more than you know what to do with
	[100822] = {
		values = {
			amount = 0,
			amount_random = 6,
		},
	},
	-- hurry up bain (cook chance evaluation delay, vanilla is 25s, cheat faster is 1s)
	[100724] = {
		on_executed = {
			{ id = 100494, delay = 15, delay_rand = 10 },
		},
	},
	-- added chance to cook each time the evaluation runs and fails, vanilla is 10%
	[100723] = {
		chance = 20,
	},
	-- waiter !  waiter !  more gangsters please !
	[101520] = {
		values = {
			amount = 1,
			amount_random = 3,
		},
	},
	[101266] = {
		values = {
			amount = 2,
			amount_random = 2,
		},
	},
	[101297] = {
		values = {
			amount = 2,
			amount_random = 1,
		},
	},
	[101010] = {
		values = {
			amount = 2,
			amount_random = 3,
		},
	},
	-- some new reenforce spots
	[100941] = {
		reinforce = {
			{
				name = "basement",
				force = 1,
				position = Vector3(2050, 975, 924.84), -- point special objective 25
			},
			{
				name = "such_a_nice_car", -- mendoza car to the right of player spawn, near cloaker hiding spot
				force = 1,
				position = Vector3(675, -1197, 875.243), -- point special objective 28
			},
		},
	},
	[101525] = { enemy = mexicans }, -- gangsters
	[101527] = { enemy = mexicans },
	[100825] = { enemy = mexicans },
	[100826] = { enemy = mexicans },
	[101529] = { enemy = mexicans },
	[101530] = { enemy = mexicans },
	[101531] = { enemy = mexicans },
	[101284] = { enemy = mexicans },
	[101286] = { enemy = mexicans },
	[100417] = { enemy = mexicans },
	[100420] = { enemy = mexicans },
	[101060] = { enemy = mexicans },
	[101061] = { enemy = mexicans },
	[101293] = { enemy = mexicans },
	[101288] = { enemy = mexicans },
	[101294] = { enemy = mexicans },
	[100426] = { enemy = mexicans },
	[100431] = { enemy = mexicans },
	[101262] = { enemy = mexicans },
	[101263] = { enemy = mexicans },
}
