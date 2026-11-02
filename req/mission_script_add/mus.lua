---@module The Diamond
local M = {}

local scripted_enemy = Eclipse.scripted_enemy

local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts

local optsDisable_first_sniper_dialogue = {
	toggle = "off",
	trigger_times = 1,
	enabled = true,
	elements = {
		400003,
	},
}
local optsEnable_more_snipers_dialogue = {
	trigger_times = 1,
	enabled = true,
	elements = {
		400004,
	},
}
local Bain_sendsnipers = {
	dialogue = "play_pln_gen_snip_01",
}
local Bain_sendmoresnipers = {
	dialogue = "play_pln_gen_snip_02",
}

local optsBesiegeDummyCloaker_1 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_over_1m_swing_dwn_7m_window",
	enabled = true,
}
local optsBesiegeDummyCloaker_2 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_dwn_11m",
	enabled = true,
}
local optsBesiegeDummyCloaker_3 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_swing_dwn_7m_window",
	enabled = true,
}
local optsBesiegeDummyCloaker_4 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_down_6m_var2",
	enabled = true,
}

local optsPreferedCloakerAdd1 = {
	spawn_groups = { 500044, 500045, 500046, 500047, 500048, 500049, 500050, 500051, 500052, 500053, 500054, 500055 },
	on_executed = {
		{ id = 500068, delay = 0 },
	},
	enabled = true,
}
local optsAddCloakerHideGroup = {
	enabled = true,
	on_executed = {
		{ id = 500067, delay = 0 },
	},
}
local optsCloakerHideGroup = {
	followup_elements = {
		500000,
		500001,
		500002,
		500003,
		500004,
		500005,
		500006,
		500007,
		500008,
		500009,
		500010,
		500011,
		500012,
		500013,
		500014,
		500015,
		500016,
		500017,
		500018,
		500019,
		500020,
		500021,
		500022,
		500023,
		500024,
		500025,
		500026,
		500027,
		500028,
		500029,
		500030,
		500031,
	},
}
local optsspooc_spawned_1 = {
	on_executed = {
		{ id = 100208, delay = 0 },
	},
	elements = {
		500035,
	},
}
local optsspooc_spawned_2 = {
	on_executed = {
		{ id = 102088, delay = 0 },
	},
	elements = {
		500037,
	},
}
local optsspooc_spawned_3 = {
	on_executed = {
		{ id = 100771, delay = 0 },
	},
	elements = {
		500038,
	},
}
local optsspooc_spawned_4 = {
	on_executed = {
		{ id = 100710, delay = 0 },
	},
	elements = {
		500039,
	},
}
local optsspooc_spawned_5 = {
	on_executed = {
		{ id = 102098, delay = 0 },
	},
	elements = {
		500040,
	},
}
local optsspooc_spawned_6 = {
	on_executed = {
		{ id = 500064, delay = 0 },
	},
	elements = {
		500041,
	},
}
local optsspooc_spawned_7 = {
	on_executed = {
		{ id = 500065, delay = 0 },
	},
	elements = {
		500042,
	},
}
local optsspooc_spawned_8 = {
	on_executed = {
		{ id = 500066, delay = 0 },
	},
	elements = {
		500043,
	},
}
local optsDestroyTheGlass_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 300257, notify_unit_sequence = "break_11", time = 0 },
	},
}
local optsDestroyTheGlass_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 300371, notify_unit_sequence = "break_frame", time = 0 },
	},
}
local optsDestroyTheGlass_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 300364, notify_unit_sequence = "break_frame", time = 0 },
	},
}
local optsAssaultStarted = {
	enabled = true,
	global_event = "start_assault",
	trigger_times = 1,
	on_executed = {
		{ id = 500069, delay = 0 },
	},
}

-- Hiding Cloaker SOs are funny
local hide_so_search_pos = Vector3(0, 650, -363.758)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_sneak_wait_stand", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var3", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_4 = get_hiding_cloaker_so_opts("e_so_hide_under_car_enter", hide_so_search_pos)

M.elements = {
	-- sniper warning dialogue stuff
	Eclipse.mission_elements.gen_toggleelement(400001, "enable_more_snipers_dialogue", optsEnable_more_snipers_dialogue),
	Eclipse.mission_elements.gen_toggleelement(400002, "disable_first_snipers_dialogue", optsDisable_first_sniper_dialogue),
	Eclipse.mission_elements.gen_dialogue(400003, "they_sending_snipers", Bain_sendsnipers),
	Eclipse.mission_elements.gen_dialogue(400004, "they_sending_more_snipers", Bain_sendmoresnipers),
	
	-- New Cloakers and their hiding spots
	-- hiding spots
	Eclipse.mission_elements.gen_so(500000, "cloaker_hide_so_1", Vector3(-1359, -1799, -300), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500001, "cloaker_hide_so_2", Vector3(-1349, 2103, -300), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500002, "cloaker_hide_so_3", Vector3(1249, 2191, -300), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500003, "cloaker_hide_so_4", Vector3(1249, -1706, -300), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500004, "cloaker_hide_so_5", Vector3(225.023, -749.971, -361), Rotation(71, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500005, "cloaker_hide_so_6", Vector3(237.058, 1153.622, -361), Rotation(140, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500006, "cloaker_hide_so_7", Vector3(899.951, 2775.983, -297), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500007, "cloaker_hide_so_8", Vector3(-161.730, 3153.373, -297), Rotation(66, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500008, "cloaker_hide_so_9", Vector3(-1323.210, 3180.855, -798), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500009, "cloaker_hide_so_10", Vector3(-2250.077, 2575.097, -1188), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500010, "cloaker_hide_so_11", Vector3(-2961.490, -409.719, -1193), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500011, "cloaker_hide_so_12", Vector3(-2454.177, -393.959, -1193), Rotation(-38, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500012, "cloaker_hide_so_13", Vector3(-1925, -3176, -1200), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500013, "cloaker_hide_so_14", Vector3(-1325, 62, -700.005), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500014, "cloaker_hide_so_15", Vector3(-2419, -2122, -800.004), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500015, "cloaker_hide_so_16", Vector3(368.250, -2874.964, -800.005), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500016, "cloaker_hide_so_17", Vector3(-575.047, -2439, -800.005), Rotation(115, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500017, "cloaker_hide_so_18", Vector3(947, -2538, -800), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500018, "cloaker_hide_so_19", Vector3(933, -2764, -300), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500019, "cloaker_hide_so_20", Vector3(-968, -2375, -300), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500020, "cloaker_hide_so_21", Vector3(863.592, -1265.879, -297), Rotation(152, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500021, "cloaker_hide_so_22", Vector3(-990, -2149, -300), Rotation(-50, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500022, "cloaker_hide_so_23", Vector3(-999, 2776, -300), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500023, "cloaker_hide_so_24", Vector3(3124, -815, -297.500), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500024, "cloaker_hide_so_25", Vector3(5135, -935, -297.500), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500025, "cloaker_hide_so_26", Vector3(5117, 1329, -297.500), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500026, "cloaker_hide_so_27", Vector3(1625.700, -173.912, -350), Rotation(71, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500027, "cloaker_hide_so_28", Vector3(1861, 749, -300.553), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500028, "cloaker_hide_so_29", Vector3(2248.999, -349, -300.553), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500029, "cloaker_hide_so_30", Vector3(2481.696, -551.380, -300), Rotation(124, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500030, "cloaker_hide_so_31", Vector3(1583.849, 929.297, -300), Rotation(-40, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500031, "cloaker_hide_so_32", Vector3(682, 2486, -300), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_3),
	-- cloakers
	Eclipse.mission_elements.gen_dummy(500032, "cloaker_spawn_1", Vector3(248.057, -985.992, -300), Rotation(180, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500033, "cloaker_spawn_2", Vector3(-381.740, 1402.370, 1175), Rotation(0, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500034, "cloaker_spawn_3", Vector3(-3435, 1231, -700), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(500035, "cloaker_spawn_4", Vector3(-603, 4241, -500), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_3),
	Eclipse.mission_elements.gen_dummy(500036, "cloaker_spawn_5", Vector3(-3402.922, -830.375, -700), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(500037, "cloaker_spawn_6", Vector3(986, -3854, -500), Rotation(0, 0, 0), optsBesiegeDummyCloaker_3),
	Eclipse.mission_elements.gen_dummy(500038, "cloaker_spawn_7", Vector3(1840, 1449, -300), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_4),
	Eclipse.mission_elements.gen_dummy(500039, "cloaker_spawn_8", Vector3(2102.630, -1583.132, -300), Rotation(90, 0, 0), optsBesiegeDummyCloaker_4),
	Eclipse.mission_elements.gen_dummy(500040, "cloaker_spawn_9", Vector3(-553, -1572, -300), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_4),
	Eclipse.mission_elements.gen_dummy(500041, "cloaker_spawn_10", Vector3(414.999, 2251, -300), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_4),
	Eclipse.mission_elements.gen_dummy(500042, "cloaker_spawn_11", Vector3(1080, 812, -350), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500043, "cloaker_spawn_12", Vector3(-1183, 795, -350), Rotation(90, 0, 0), optsBesiegeDummyCloaker_1),
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(500044, "mus_cloaker_spawngroup_01", { 500032 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500045, "mus_cloaker_spawngroup_02", { 500033 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500046, "mus_cloaker_spawngroup_03", { 500034 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500047, "mus_cloaker_spawngroup_04", { 500035 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500048, "mus_cloaker_spawngroup_05", { 500036 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500049, "mus_cloaker_spawngroup_06", { 500037 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500050, "mus_cloaker_spawngroup_07", { 500038 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500051, "mus_cloaker_spawngroup_08", { 500039 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500052, "mus_cloaker_spawngroup_09", { 500040 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500053, "mus_cloaker_spawngroup_10", { 500041 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500054, "mus_cloaker_spawngroup_11", { 500042 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500055, "mus_cloaker_spawngroup_12", { 500043 }, 0),
	-- spawn events for spoocs
	Eclipse.mission_elements.gen_dummytrigger(500056, "spooc_spawned_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_1),
	Eclipse.mission_elements.gen_dummytrigger(500057, "spooc_spawned_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_2),
	Eclipse.mission_elements.gen_dummytrigger(500058, "spooc_spawned_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_3),
	Eclipse.mission_elements.gen_dummytrigger(500059, "spooc_spawned_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_4),
	Eclipse.mission_elements.gen_dummytrigger(500060, "spooc_spawned_5", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_5),
	Eclipse.mission_elements.gen_dummytrigger(500061, "spooc_spawned_6", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_6),
	Eclipse.mission_elements.gen_dummytrigger(500062, "spooc_spawned_7", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_7),
	Eclipse.mission_elements.gen_dummytrigger(500063, "spooc_spawned_8", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_8),
	Eclipse.mission_elements.gen_object_editor(500064, "destroy_the_glass_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDestroyTheGlass_1),
	Eclipse.mission_elements.gen_object_editor(500065, "destroy_the_glass_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDestroyTheGlass_2),
	Eclipse.mission_elements.gen_object_editor(500066, "destroy_the_glass_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDestroyTheGlass_3),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(500067, "mus_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_sogroup(500068, "mus_cloaker_hide_group", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup),
	Eclipse.mission_elements.gen_missionscript(500069, "mus_cloaker_spawn_global", optsAddCloakerHideGroup),
	Eclipse.mission_elements.gen_global_event(500070, "mus_assault_start", Vector3(0, 0, 0), Rotation(0, 0, 0), optsAssaultStarted),
}

return M
