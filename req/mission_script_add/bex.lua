---@module San Martin Bank
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()

local green_bulldozer = scripted_enemy.bulldozer_1
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local cloaker = scripted_enemy.bulldozer_1

local enabled_chance_dozers = math.random() <= 0.4

local optsDwTrailer_Dozer_1 = {
	enemy = elite_skull_bulldozer,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = {
		{ id = 400002, delay = 0 },
		{ id = 400008, delay = 0 },
	},
	enabled = true,
}
local optsDwTrailer_Dozer_2 = {
	enemy = elite_skull_bulldozer,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = {
		{ id = 400003, delay = 0 },
		{ id = 400007, delay = 0 },
	},
	enabled = true,
}
local optVaultDozer = {
	enemy = is_eclipse and elite_ben_bulldozer or green_bulldozer,
	enabled = overkill_and_above and enabled_chance_dozers,
}
local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsBesiegeDummyCloaker_1 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_repel_into_window",
	enabled = true,
}
local optsBesiegeDummyCloaker_2 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_window_down_4m",
	enabled = true,
}
local optsBesiegeDummyCloaker_3 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	enabled = true,
}
local optsPreferedCloakerAdd1 = {
	spawn_groups = { 400042, 400043, 400044, 400045, 400046, 400047, 400048, 400049, 400050, 400051 },
	on_executed = {
		{ id = 400063, delay = 0 },
	},
	enabled = true,
}
local optsCloakerHideGroup = {
	followup_elements = { 400025, 400026, 400027, 400028, 400029, 400030, 400031 },
}
local optsspooc_spawned_1 = {
	on_executed = {
		{ id = 400057, delay = 0 },
	},
	elements = {
		400032,
	},
}
local optsspooc_spawned_2 = {
	on_executed = {
		{ id = 400058, delay = 0 },
	},
	elements = {
		400033,
	},
}
local optsspooc_spawned_3 = {
	on_executed = {
		{ id = 400059, delay = 0 },
	},
	elements = {
		400034,
	},
}
local optsspooc_spawned_4 = {
	on_executed = {
		{ id = 400060, delay = 0 },
	},
	elements = {
		400040,
	},
}
local optsspooc_spawned_5 = {
	on_executed = {
		{ id = 400061, delay = 0 },
	},
	elements = {
		400041,
	},
}
local optsDefend_Dozer = {
	SO_access = "4096",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
}
-- Hiding Cloaker SOs are funny
local hide_so_search_pos = Vector3(268, 169, 0)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_idle_by_container", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_hide_under_car_enter", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts(" e_so_sneak_wait_stand", hide_so_search_pos)

local optsDisable_dwdozers = {
	toggle = "off",
	enabled = true,
	elements = {
		400000,
		400001,
	},
}
local optsEnable_dwdozer = {
	enabled = is_eclipse,
	elements = {
		400000,
		400001,
	},
}
local optsDestroyTheGlass_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 400145, notify_unit_sequence = "break_window_01", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 400145, notify_unit_sequence = "break_window_02", time = 0 },
	},
}
local optsDestroyTheGlass_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 400146, notify_unit_sequence = "break_window_01", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 400146, notify_unit_sequence = "break_window_02", time = 0 },
	},
}
local optsDestroyTheGlass_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 400142, notify_unit_sequence = "break_window_01", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 400142, notify_unit_sequence = "break_window_02", time = 0 },
	},
}
local optsDestroyTheGlass_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 400123, notify_unit_sequence = "break_window_01", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 400123, notify_unit_sequence = "break_window_02", time = 0 },
	},
}
local optsDestroyTheGlass_5 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 400140, notify_unit_sequence = "break_window_01", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 400140, notify_unit_sequence = "break_window_02", time = 0 },
	},
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102986, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 104797, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102821, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 104798, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400016, delay = 0 },
		{ id = 400017, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400023, delay = 0 },
		{ id = 400024, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

M.elements = {
	-- dw trailer styled skullies
	Eclipse.mission_elements.gen_dummy(400000, "tank_1", Vector3(1509, 4783, -13.500), Rotation(41, 0, 0), optsDwTrailer_Dozer_1),
	Eclipse.mission_elements.gen_dummy(400001, "tank_2", Vector3(-1864.375, 4782.167, -13.500), Rotation(37, 0, 0), optsDwTrailer_Dozer_2),
	Eclipse.mission_elements.gen_so(400002, "tank_so_1", Vector3(3013, 3481, 0), Rotation(90, 0, 0), optsDefend_Dozer),
	Eclipse.mission_elements.gen_so(400003, "tank_so_2", Vector3(-2979.969, 3633.456, 0), Rotation(-90, 0, 0), optsDefend_Dozer),

	Eclipse.mission_elements.gen_toggleelement(400004, "disable_dozers", optsDisable_dwdozers),
	Eclipse.mission_elements.gen_toggleelement(400005, "enable_dozers", optsEnable_dwdozer),

	Eclipse.mission_elements.gen_object_editor(400007, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_object_editor(400008, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_2),

	-- bulldozers inside the vault
	Eclipse.mission_elements.gen_dummy(400009, "tank_vault_1", Vector3(45, -5729, -400), Rotation(0, 0, 0), optVaultDozer),
	Eclipse.mission_elements.gen_dummy(400010, "tank_vault_2", Vector3(-53, -5729, -400), Rotation(0, 0, 0), optVaultDozer),

	-- swat van 1 (that crashes at the wall)
	Eclipse.mission_elements.gen_dummy(400011, "swat_van_spawn_1", Vector3(-2325, -6200, -15), Rotation(115, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400012, "swat_van_spawn_2", Vector3(-2300, -6250, -15), Rotation(115, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400013, "swat_van_spawn_3", Vector3(-2350, -6275, -15), Rotation(115, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400014, "swat_van_spawn_4", Vector3(-2375, -6225, -15), Rotation(115, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400015, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400016, "open_swat_doors_3", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_3),
	Eclipse.mission_elements.gen_spawngroup(400017, "swat_group_1", { 400011, 400012, 400013, 400014 }, 0, opts_swat_group),

	-- swat van 2 (middle)
	Eclipse.mission_elements.gen_dummy(400018, "swat_van_spawn_5", Vector3(-2600, 50, -15), Rotation(100, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400019, "swat_van_spawn_6", Vector3(-2600, -25, -15), Rotation(100, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400020, "swat_van_spawn_7", Vector3(-2650, 50, -15), Rotation(100, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400021, "swat_van_spawn_8", Vector3(-2650, -25, -15), Rotation(100, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400022, "spawn_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400023, "open_swat_doors_4", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_4),
	Eclipse.mission_elements.gen_spawngroup(400024, "swat_group_2", { 400018, 400019, 400020, 400021 }, 0, opts_swat_group),
	
	-- New Cloakers and their hiding spots
	-- hiding spots
	Eclipse.mission_elements.gen_so(400025, "cloaker_hide_so_1", Vector3(-317, 1536, -100), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400026, "cloaker_hide_so_2", Vector3(890, 1147, -100), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400027, "cloaker_hide_so_3", Vector3(1295, 4243, -495), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400028, "cloaker_hide_so_4", Vector3(663, 3340, -500), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400029, "cloaker_hide_so_5", Vector3(-1275, 2394, -100), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400030, "cloaker_hide_so_6", Vector3(-812.010, 4542.311, -100), Rotation(-93, 0, 0), optsCloaker_Hide_SpotSO_5),
	Eclipse.mission_elements.gen_so(400031, "cloaker_hide_so_7", Vector3(-1275, 1713, -100), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_3),
	-- cloakers
	Eclipse.mission_elements.gen_dummy(400032, "cloaker_spawn_1", Vector3(378, -5345, 400), Rotation(0, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(400033, "cloaker_spawn_2", Vector3(-167, -5345, 400), Rotation(0, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(400034, "cloaker_spawn_3", Vector3(1651, -4404, 400), Rotation(90, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(400035, "cloaker_spawn_4", Vector3(3221, -2530, 0), Rotation(90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400036, "cloaker_spawn_5", Vector3(2813, -2570, 0), Rotation(0, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400037, "cloaker_spawn_6", Vector3(-1223, -7786, -13.500), Rotation(90, 0, 0), optsBesiegeDummyCloaker_3),
	Eclipse.mission_elements.gen_dummy(400038, "cloaker_spawn_7", Vector3(-5355, -701, 0), Rotation(0, 0, 0), optsBesiegeDummyCloaker_3),
	Eclipse.mission_elements.gen_dummy(400039, "cloaker_spawn_8", Vector3(2516, 6424, 0), Rotation(90, 0, 0), optsBesiegeDummyCloaker_3),
	Eclipse.mission_elements.gen_dummy(400040, "cloaker_spawn_9", Vector3(-1431, -2623, 400) Rotation(-90, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(400041, "cloaker_spawn_10", Vector3(1651, -3595, 400), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_1),
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(400042, "bex_cloaker_spawngroup_01", { 400032 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400043, "bex_cloaker_spawngroup_02", { 400033 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400044, "bex_cloaker_spawngroup_03", { 400034 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400045, "bex_cloaker_spawngroup_04", { 400035 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400046, "bex_cloaker_spawngroup_05", { 400036 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400047, "bex_cloaker_spawngroup_06", { 400037 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400048, "bex_cloaker_spawngroup_07", { 400038 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400049, "bex_cloaker_spawngroup_08", { 400039 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400050, "bex_cloaker_spawngroup_09", { 400040 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400051, "bex_cloaker_spawngroup_10", { 400041 }, 0),
	-- spawn events for rappeling spoocs
	Eclipse.mission_elements.gen_dummytrigger(400052, "rappel_spooc_spawned_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_1),
	Eclipse.mission_elements.gen_dummytrigger(400053, "rappel_spooc_spawned_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_2),
	Eclipse.mission_elements.gen_dummytrigger(400054, "rappel_spooc_spawned_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_3),
	Eclipse.mission_elements.gen_dummytrigger(400055, "rappel_spooc_spawned_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_4),
	Eclipse.mission_elements.gen_dummytrigger(400056, "rappel_spooc_spawned_5", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_5),
	Eclipse.mission_elements.gen_object_editor(400057, "destroy_the_glass_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsDestroyTheGlass_1),
	Eclipse.mission_elements.gen_object_editor(400058, "destroy_the_glass_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optsDestroyTheGlass_2),
	Eclipse.mission_elements.gen_object_editor(400059, "destroy_the_glass_3", Vector3(0, 0, 0), Rotation(0, 0, -0), optsDestroyTheGlass_3),
	Eclipse.mission_elements.gen_object_editor(400060, "destroy_the_glass_4", Vector3(0, 0, 0), Rotation(0, 0, -0), optsDestroyTheGlass_4),
	Eclipse.mission_elements.gen_object_editor(400061, "destroy_the_glass_5", Vector3(0, 0, 0), Rotation(0, 0, -0), optsDestroyTheGlass_5),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(400062, "bex_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_sogroup(400063, "bex_cloaker_hide_group", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup),
}
return M
