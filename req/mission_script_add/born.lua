---@module Biker Heist Day 1
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local cloaker = scripted_enemy.cloaker

local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts

local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

local optsBesiegeDummyCloaker_1 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_over_3m_fwd_2m_roll",
	enabled = true,
}
local optsBesiegeDummyCloaker_2 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_crh_to_std_rifle",
	enabled = true,
}

local optsPreferedCloakerAdd1 = {
	spawn_groups = { 100852, 100844, 100848, 400027, 400028, 400029, 400030 },
	on_executed = {
		{ id = 400032, delay = 0 },
	},
	enabled = true,
}
local optsAddCloakerHideGroup = {
	enabled = true,
	on_executed = {
		{ id = 400031, delay = 0 },
	},
}
local optsCloakerHideGroup = {
	followup_elements = {
		400010,
		400011,
		400012,
		400013,
		400014,
		400015,
		400016,
		400017,
		400018,
		400019,
		400020,
		400021,
		400022,
		101191,
	},
}

-- Hiding Cloaker SOs are funny
local hide_so_search_pos = Vector3(0, 0, 100)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_hide_under_car_enter", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var3", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts("e_so_sneak_wait_stand", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_4 = get_hiding_cloaker_so_opts("e_so_hide_behind_door_enter", hide_so_search_pos)

M.elements = {
	-- tweak swat chopper
	Eclipse.mission_elements.gen_spawngroup(400001, "swat_group", { 101560, 101814, 101627, 101672 }, 0, opts_swat_group),
	
	-- New Cloakers and their hiding spots
	-- hiding spots
	Eclipse.mission_elements.gen_so(400010, "cloaker_hide_so_1", Vector3(-746, 189, 99.977), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400011, "cloaker_hide_so_2", Vector3(279, 652, 100), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400012, "cloaker_hide_so_3", Vector3(1111, 576, 100), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400013, "cloaker_hide_so_4", Vector3(-3, -1325, 50), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400014, "cloaker_hide_so_5", Vector3(793, -448, 500), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400015, "cloaker_hide_so_6", Vector3(-2652, 1230, 11.603), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400016, "cloaker_hide_so_7", Vector3(-56.802, 2542.942, 0), Rotation(177, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400017, "cloaker_hide_so_8", Vector3(-2047.193, 1932.094, 0), Rotation(-114, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400018, "cloaker_hide_so_9", Vector3(973, 836, 100), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400019, "cloaker_hide_so_10", Vector3(-361, -1926, 30.558), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400020, "cloaker_hide_so_11", Vector3(-168.259, -1178.034, 50), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400021, "cloaker_hide_so_12", Vector3(-96, -250, 99.979), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400022, "cloaker_hide_so_13", Vector3(840, 2227, 0), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	-- cloakers
	Eclipse.mission_elements.gen_dummy(400023, "cloaker_spawn_1", Vector3(832, -2524, 0.001), Rotation(90, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(400024, "cloaker_spawn_2", Vector3(-3474, 1897, 0), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(400025, "cloaker_spawn_3", Vector3(631, -946, 864.146), Rotation(0, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400026, "cloaker_spawn_4", Vector3(1472.215, 1144.785, 0), Rotation(45, 0, 0), optsBesiegeDummyCloaker_1),
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(400027, "born_cloaker_spawngroup_01", { 400023 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400028, "born_cloaker_spawngroup_02", { 400024 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400029, "born_cloaker_spawngroup_03", { 400025 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400030, "born_cloaker_spawngroup_04", { 400026 }, 0),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(400031, "born_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_sogroup(400032, "born_cloaker_hide_group", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup),
	Eclipse.mission_elements.gen_missionscript(400033, "born_cloaker_spawn_global", optsAddCloakerHideGroup),
}

return M
