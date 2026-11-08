---@module Buluc's Mansion
local M = {}

local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value

local scripted_enemy = Eclipse.scripted_enemy

local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts

local optsDifficultyAddend01 = {
	trigger_times = 1,
	difficulty_addends = {
		{
			amount = 0.25,
			delay = 0,
			time = 60,
			time_mul = get_difficulty_specific_value({ 1.2, 1.1, 1, 0.9, 0.8 }),
			time_balance_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	enabled = true,
}
local optsBesiegeDummyCloaker_1 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	enabled = true,
}
local optsBesiegeDummyCloaker_2 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_roof_run_repel_into_window",
	enabled = true,
}
local optsBesiegeDummyCloaker_3 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_climb_up_bridge_v2",
	enabled = true,
}
local optsBesiegeDummyCloaker_4 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_climb_over_4m",
	enabled = true,
}
local optsBesiegeDummyCloaker_5 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_over_3m",
	enabled = true,
}

local optsPreferedCloakerAdd1 = {
	spawn_groups = { 500031, 500032, 500033, 500034, 500035, 500036, 500037, 500038 },
	on_executed = {
		{ id = 500042, delay = 0 },
	},
	enabled = true,
}
local optsAddCloakerHideGroup = {
	enabled = true,
	on_executed = {
		{ id = 500041, delay = 0 },
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
	},
}
local optsspooc_spawned_1 = {
	on_executed = {
		{ id = 500040, delay = 0 },
	},
	elements = {
		500026,
	},
}
local optsDestroyTheGlass_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 800087, notify_unit_sequence = "break_window_01", time = 0 },
	},
}
local optsAssaultStarted = {
	enabled = true,
	global_event = "start_assault",
	trigger_times = 1,
	on_executed = {
		{ id = 500043, delay = 0 },
	},
}

-- Hiding Cloaker SOs are funny
local hide_so_search_pos = Vector3(0, 0, 14)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_hide_behind_door_enter", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var3", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_4 = get_hiding_cloaker_so_opts("e_so_hide_under_car_enter", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_5 = get_hiding_cloaker_so_opts("e_so_sit_student_var5", hide_so_search_pos) -- funny spot
local optsCloaker_Hide_SpotSO_6 = get_hiding_cloaker_so_opts("e_so_sneak_wait_stand", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_7 = get_hiding_cloaker_so_opts("e_so_hide_ledge_enter", hide_so_search_pos)

M.elements = {
	Eclipse.mission_elements.gen_difficulty(400001, "fex_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400002, "fex_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),

	-- New Cloakers and their hiding spots
	-- hiding spots
	Eclipse.mission_elements.gen_so(500000, "cloaker_hide_so_1", Vector3(118, 1878, 5.393), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500001, "cloaker_hide_so_2", Vector3(-2425, 2947, 0), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500002, "cloaker_hide_so_3", Vector3(90, 4954, 100), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500003, "cloaker_hide_so_4", Vector3(1150, 2217, 4.125), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500004, "cloaker_hide_so_5", Vector3(2761, 3008, 3.094), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500005, "cloaker_hide_so_6", Vector3(969, 1560, 3.094), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500006, "cloaker_hide_so_7", Vector3(2726, 2150, 9.581), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500007, "cloaker_hide_so_8", Vector3(-1293, 3394, 500), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500008, "cloaker_hide_so_9", Vector3(-2180, 3234, 500), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500009, "cloaker_hide_so_10", Vector3(2313.542, -937.517, -1000), Rotation(134, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500010, "cloaker_hide_so_11", Vector3(-78, 1681, 0), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500011, "cloaker_hide_so_12", Vector3(-2076, 1166, 0), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_6),
	Eclipse.mission_elements.gen_so(500012, "cloaker_hide_so_13", Vector3(-2060, 3749.024, -298), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_6),
	Eclipse.mission_elements.gen_so(500013, "cloaker_hide_so_14", Vector3(2329, 4055, 0), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500014, "cloaker_hide_so_15", Vector3(-54, 5582, 100), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_7),
	Eclipse.mission_elements.gen_so(500015, "cloaker_hide_so_16", Vector3(-1349.113, 4378.285, -300), Rotation(11, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500016, "cloaker_hide_so_17", Vector3(2275, 4428, -300), Rotation(19, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500017, "cloaker_hide_so_18", Vector3(-323, 824, 500), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_7),
	Eclipse.mission_elements.gen_so(500018, "cloaker_hide_so_19", Vector3(1977.371, 1983.832, 0), Rotation(-126, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500019, "cloaker_hide_so_20", Vector3(-525, 1125, 0), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_6),
	Eclipse.mission_elements.gen_so(500020, "cloaker_hide_so_21", Vector3(-986.854, 2047.550, 0), Rotation(67, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500021, "cloaker_hide_so_22", Vector3(3273, 2725, 0), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_5),
	Eclipse.mission_elements.gen_so(500022, "cloaker_hide_so_23", Vector3(-1411, 2650, 4.125), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_5),
	-- cloakers
	Eclipse.mission_elements.gen_dummy(500023, "cloaker_spawn_1", Vector3(2735, 3995, 501.098), Rotation(90, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500024, "cloaker_spawn_2", Vector3(-2010, 4516, 1055.709), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500025, "cloaker_spawn_3", Vector3(-2359, 2637, 500), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(500026, "cloaker_spawn_4", Vector3(5, 1575, 504.478), Rotation(180, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(500027, "cloaker_spawn_5", Vector3(-1040, 2902, 503.094), Rotation(90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(500028, "cloaker_spawn_6", Vector3(-405, 5505, 100), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_3),
	Eclipse.mission_elements.gen_dummy(500029, "cloaker_spawn_7", Vector3(-2340, -1899, 0), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_4),
	Eclipse.mission_elements.gen_dummy(500030, "cloaker_spawn_8", Vector3(2555, 1582, 1.190), Rotation(90, 0, 0), optsBesiegeDummyCloaker_5),
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(500031, "fex_cloaker_spawngroup_01", { 500023 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500032, "fex_cloaker_spawngroup_02", { 500024 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500033, "fex_cloaker_spawngroup_03", { 500025 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500034, "fex_cloaker_spawngroup_04", { 500026 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500035, "fex_cloaker_spawngroup_05", { 500027 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500036, "fex_cloaker_spawngroup_06", { 500028 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500037, "fex_cloaker_spawngroup_07", { 500029 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500038, "fex_cloaker_spawngroup_08", { 500030 }, 0),
	-- spawn events for spoocs
	Eclipse.mission_elements.gen_dummytrigger(500039, "spooc_spawned_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_1),
	Eclipse.mission_elements.gen_object_editor(500040, "destroy_the_glass_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDestroyTheGlass_1),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(500041, "fex_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_sogroup(500042, "fex_cloaker_hide_group", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup),
	Eclipse.mission_elements.gen_missionscript(500043, "fex_cloaker_spawn_global", optsAddCloakerHideGroup),
	Eclipse.mission_elements.gen_global_event(500044, "fex_assault_start", Vector3(0, 0, 0), Rotation(0, 0, 0), optsAssaultStarted),
}

return M
