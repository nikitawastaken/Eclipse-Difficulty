local preferred = Eclipse.preferred
local level_id = Eclipse.utils.level_id()
local scripted_enemy = Eclipse.scripted_enemy
local is_pro_job = Eclipse.utils.is_pro_job()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = is_eclipse and is_pro_job
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local cook_off = level_id ~= "alex_1"
local meth_lab_in_basement_chance = cook_off and math.random() < 0.2
local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
-- credit for these changes goes to ASS, thanks miki <3
local mendoza_enemy = {
	Idstring("units/payday2/characters/ene_gang_mexican_1/ene_gang_mexican_1"),
	Idstring("units/payday2/characters/ene_gang_mexican_2/ene_gang_mexican_2"),
	Idstring("units/payday2/characters/ene_gang_mexican_3/ene_gang_mexican_3"),
	Idstring("units/payday2/characters/ene_gang_mexican_4/ene_gang_mexican_4"),
}
local mendoza = { enemy = mendoza_enemy }
local heli_dozer = is_eclipse_pro and random_elite_dozers or diff_i > 3 and random_dozers or green_bulldozer
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
local cloaker_enemy = {
	enemy = normal and scripted_enemy.heavy_swat_1 or scripted_enemy.cloaker,
}
local exclude_cop_agents_shields_dozers = {
	so_access_filter = { "swat", "taser", "spooc" },
}
local chopper_amount = is_eclipse and 2 or 1
local sniper_respawn_1 = (is_eclipse and 80 or hard and 100 or 140) - (is_pro_job and 30 or 0)
local sniper_respawn_2 = (is_eclipse and 60 or hard and 70 or 90) - (is_pro_job and 20 or 0)
local sniper_respawn_3 = (is_eclipse and 30 or hard and 40 or 60) - (is_pro_job and 10 or 0)
local bridge_far_spawn = {
	values = {
		interval = 10,
	},
}
local lumber_far_spawn = {
	values = {
		interval = 10,
	},
}
local bridge_close_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_bulldozers,
}
local lumber_close_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_bulldozers,
}
local flank_spawn_1 = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields_bulldozers_snipers,
}
local flank_spawn_2 = {
	values = {
		interval = 30,
	},
}
return {
	-- replace Heavy SWATs that spawn from the chopper with cloakers on higher difficulties
	[101571] = cloaker_enemy,
	[101572] = cloaker_enemy,
	-- replace scripted heavies with cloakers on higher difficulties
	[101660] = cloaker_enemy,
	[101661] = cloaker_enemy,
	-- randomize dozer spawn
	-- let bulldozer end his spawn anim before going into hunt mode
	[100952] = {
		enemy = heli_dozer,
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
	-- faster sniper respawns on higher diificulties
	[101137] = {
		on_executed = {
			{ id = 101256, delay = sniper_respawn_3 },
			{ id = 101070, delay = sniper_respawn_3 },
		},
	},
	[101138] = {
		on_executed = {
			{ id = 101256, delay = sniper_respawn_2 },
			{ id = 101070, delay = sniper_respawn_2 },
		},
	},
	[101141] = {
		on_executed = {
			{ id = 101256, delay = sniper_respawn_1 },
			{ id = 101070, delay = sniper_respawn_1 },
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
	[100965] = {
		on_executed = {
			{ id = 400009, delay = 0 },
			{ id = 100966, delay = 0 },
		},
	},
	-- this makes the dozer chopper spawn twice sometimes
	[100239] = {
		values = {
			enabled = false,
		},
	},
	[100966] = {
		values = {
			amount = chopper_amount,
		},
		on_executed = {
			{ id = 100993, remove = cook_off and true or false }, -- unused spawn snipers script
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
	-- fix the police chopper on cook off being invisible
	[100922] = {
		on_executed = {
			{ id = 101647, remove = true },
			{ id = 400008, delay = 0 },
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
				name = "such_a_nice_car", -- mendoza car to the right of player spawn, near cloaker hiding spot
				force = 2,
				position = Vector3(675, -1200, 900),
			},
			{
				name = "such_an_ugly_car",
				force = 2,
				position = Vector3(300, 1300, 1200),
			},
			{
				name = "redeyes",
				force = 2,
				position = Vector3(3000, -900, 900),
			},
		},
	},
	-- add new unused spawngroup
	[100846] = {
		values = {
			spawn_groups = {
				400007,
				100874,
				100880,
				100863,
			},
		},
	},
	[101525] = mendoza, -- gangsters
	[101527] = mendoza,
	[100825] = mendoza,
	[100826] = mendoza,
	[101529] = mendoza,
	[101530] = mendoza,
	[101531] = mendoza,
	[101284] = mendoza,
	[101286] = mendoza,
	[100417] = mendoza,
	[100420] = mendoza,
	[101060] = mendoza,
	[101061] = mendoza,
	[101293] = mendoza,
	[101288] = mendoza,
	[101294] = mendoza,
	[100426] = mendoza,
	[100431] = mendoza,
	[101262] = mendoza,
	[101263] = mendoza,
	-- Spawn Group delays
	[100671] = bridge_far_spawn,
	[100880] = lumber_far_spawn,
	[100672] = bridge_close_spawn,
	[100924] = bridge_close_spawn,
	[100863] = lumber_close_spawn,
	[100874] = lumber_close_spawn,
	[100925] = flank_spawn,
	[400007] = flank_spawn_2,
}
