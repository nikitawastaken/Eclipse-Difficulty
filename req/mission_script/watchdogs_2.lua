local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job
local shield = scripted_enemy.shield
local elite_shield = scripted_enemy.elite_shield
local taser = scripted_enemy.taser
local bulldozer = scripted_enemy.bulldozer_1
local elite_bulldozer = scripted_enemy.elite_bulldozer_2
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
local ship_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents,
}
local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}
local no_participate_to_group_ai = {
	values = {
		participate_to_group_ai = false,
	},
}
local blockade_enemy1 = {
	values = {
		enemy = is_eclipse and elite_bulldozer or bulldozer,
	},
}
local blockade_enemy2 = {
	values = {
		enemy = is_eclipse_pro and elite_shield or shield,
	},
}
local heli_enemy1 = {
	values = {
		enemy = taser,
	},
}
local heli_enemy2 = {
	values = {
		enemy = is_eclipse_pro and elite_bulldozer or bulldozer,
		trigger_times = 0,
	},
}
local heli_chance = (is_pro_job and 1.25 or 1) * (diff_i - 2) * 20
local function cloaker_add(id)
	return id and {
		modify_list_value = {
			elements = {
				[id] = true,
			},
		},
	} or nil
end

local john_boat_driver_chance = math.random() <= 0.1

local john_dialogue_1 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_01" or "bot_wd2_01"
local john_dialogue_2 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_05" or "bot_wd2_02"
local john_dialogue_3 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_06" or "bot_wd2_04a"
local john_dialogue_4 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_07" or "bot_wd2_03"
local john_dialogue_5 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_08" or "bot_wd2_06"
local john_dialogue_6 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_09" or "bot_wd2_07"
local john_dialogue_7 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_10" or "bot_wd2_08"
local john_dialogue_8 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_07" or "bot_wd2_10"
local john_dialogue_9 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_11" or "bot_wd2_11"
local john_dialogue_10 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_12" or "bot_wd2_19"
local john_dialogue_11 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_13" or "bot_wd2_20"
local john_dialogue_12 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_14" or "bot_wd2_21b"
local john_dialogue_13 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_02" or "Play_bot_a04"
local john_dialogue_14 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_03" or "Play_bot_a05"
local john_dialogue_15 = john_boat_driver_chance and "Play_bot_watchdogs_new_stage2_04" or "Play_bot_a06"

return {
	-- 10% of pre beta boat driver taking it's place
	-- lights are on
	[101233] = {
		values = {
			dialogue = john_dialogue_1,
		},
	},
	-- 2 mins to arrive
	[100628] = {
		values = {
			dialogue = john_dialogue_13,
		},
	},
	-- 1 min to arrive
	[101231] = {
		values = {
			dialogue = john_dialogue_14,
		},
	},
	-- 30 secs to arrive
	[101232] = {
		values = {
			dialogue = john_dialogue_15,
		},
	},
	-- boat arrived
	[101586] = {
		values = {
			dialogue = john_dialogue_2,
		},
	},
	-- 4 bags only reminder
	[101588] = {
		values = {
			dialogue = john_dialogue_3,
		},
	},
	-- bag secured
	[101592] = {
		values = {
			dialogue = john_dialogue_4,
		},
	},
	-- all 4 bags are in
	[102357] = {
		values = {
			dialogue = john_dialogue_5,
		},
	},
	-- going back soon, unloading the bags
	[103808] = {
		values = {
			dialogue = john_dialogue_6,
		},
	},
	-- going back soon, bags unloaded
	[103809] = {
		values = {
			dialogue = john_dialogue_7,
		},
	},
	-- 4 bags only reminder (again)
	[103810] = {
		values = {
			dialogue = john_dialogue_8,
		},
	},
	-- threw the bag into the water
	[103811] = {
		values = {
			dialogue = john_dialogue_9,
		},
	},
	-- coming in dock 7
	[103812] = {
		values = {
			dialogue = john_dialogue_10,
		},
	},
	-- coming in dock 8
	[103813] = {
		values = {
			dialogue = john_dialogue_11,
		},
	},
	-- coming in dock 9
	[103815] = {
		values = {
			dialogue = john_dialogue_12,
		},
	},
	-- 1st assault reinforce
	[100511] = {
		reinforce = {
			{
				name = "diff50_reinforce1",
				force = 3,
				position = Vector3(-1500, 800, 0),
			},
			{
				name = "diff50_reinforce2",
				force = 3,
				position = Vector3(-800, 3200, 0),
			},
		},
	},
	-- 2nd assault reinforce
	[103637] = {
		reinforce = {
			{
				name = "diff75_reinforce1",
				force = 3,
				position = Vector3(400, 1200, 0),
			},
			{
				name = "diff75_reinforce2",
				force = 3,
				position = Vector3(900, -800, 0),
			},
		},
	},
	-- initial bag blockade is now EVIL (on DWPJ)
	[102040] = {
		values = {
			difficulty_overkill = true,
		},
	},
	[102375] = blockade_enemy1,
	[102374] = blockade_enemy1,
	[104026] = blockade_enemy2,
	[104027] = blockade_enemy2,
	[102157] = blockade_enemy2,
	[102256] = blockade_enemy2,
	[104025] = disabled,
	[104028] = disabled,
	[102117] = disabled,
	[102369] = disabled,
	-- helicopter spawns
	[100443] = {
		on_executed = {
			{ id = 100446, delay = 0.5, delay_rand = 0.5 },
			{ id = 100447, delay = 0.5, delay_rand = 0.5 },
			{ id = 100448, delay = 2, delay_rand = 2 }, -- logic link 28
		},
	},
	[100448] = {
		on_executed = {
			{ id = 100454, delay = eclipse and 120 or 180, delay_rand = 120 },
			{ id = 100446, remove = true }, -- don't make taser spawn twice
		},
	},
	[100454] = {
		values = {
			chance = heli_chance,
		},
	},
	[100446] = heli_enemy1,
	[100447] = heli_enemy2,
	-- open warehouse on all difficulties
	[104004] = disabled,
	[104002] = disabled,
	[104069] = disabled,
	-- disable some sketchy cheat sapwns
	[101007] = disabled,
	[100844] = disabled,
	-- make early spawns not participate to group AI
	[100761] = no_participate_to_group_ai,
	[100765] = no_participate_to_group_ai,
	[101212] = no_participate_to_group_ai,
	[101214] = no_participate_to_group_ai,
	[101216] = no_participate_to_group_ai,
	[101218] = no_participate_to_group_ai,
	[101412] = no_participate_to_group_ai,
	[101413] = no_participate_to_group_ai,
	[101222] = no_participate_to_group_ai,
	[100344] = no_participate_to_group_ai,
	-- add cloakers
	[103962] = cloaker_add(103961),
	[103964] = cloaker_add(103963),
	[103966] = cloaker_add(103965),
	[103968] = cloaker_add(103967),
	[103970] = cloaker_add(103969),
	[103972] = cloaker_add(103971),
	[103974] = cloaker_add(103973),
	[103976] = cloaker_add(103975),
	[103978] = cloaker_add(103977),
	[103980] = cloaker_add(103979),
	-- spawn Ground Snipers after 3-5 minutes
	[100486] = {
		on_executed = {
			{ id = 400035, delay = normal and 240 or 180 },
		},
	},
	-- spawn Snipers on the ships
	[102182] = {
		on_executed = {
			{ id = 400013, delay = 30, delay_rand = normal and 60 or 30 },
		},
	},
	[102388] = {
		on_executed = {
			{ id = 400014, delay = 30, delay_rand = normal and 60 or 30 },
		},
	},
	[102335] = {
		on_executed = {
			{ id = 400015, delay = 30, delay_rand = normal and 60 or 30 },
		},
	},
	-- Disable some sketchy cheat sapwns
	[101007] = disabled,
	[100844] = disabled,
	-- Spawn group intervals
	-- Not much going on here, you won't be getting swarmed by enemies that spawn on the ships.
	[400042] = scripted_swat_van_spawn,
	[400050] = scripted_swat_van_spawn,
	[102387] = ship_spawn,
	[102331] = ship_spawn,
	[102173] = ship_spawn,
}
