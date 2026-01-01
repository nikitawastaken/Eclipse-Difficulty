---@module Stealing Xmas
local M = {}
local scripted_enemy = Eclipse.scripted_enemy

local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts

local cloaker = scripted_enemy.cloaker

local optsBesiegeDummyCloaker_1 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_run_jump_far",
	enabled = true,
}
local optsBesiegeDummyCloaker_2 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	enabled = true,
}
local optsPreferedCloakerAdd1 = {
	spawn_groups = { 400028, 400029, 400030, 400031, 400032, 400033, 400034, 400035, 400036 },
	on_executed = {
		{ id = 400038, delay = 0 },
	},
	enabled = true,
}
local optsAddCloakerHideGroup = {
	enabled = true,
	on_executed = {
		{ id = 400037, delay = 0 },
	},
}
local optsCloakerHideGroup = {
	followup_elements = {
		400003,
		400004,
		400005,
		400006,
		400007,
		400008,
		400009,
		400010,
		400011,
		400012,
		400013,
		400014,
		400015,
		400016,
		400017,
		400018,
	},
}

-- Hiding Cloaker SOs are funny
local hide_so_search_pos = Vector3(0, 350, -95)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_hide_under_car_enter", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var3", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_4 = get_hiding_cloaker_so_opts("e_so_hide_behind_door_enter", hide_so_search_pos)

local optsPreferedAdd1 = {
	spawn_groups = { 100128, 100130, 100131, 100133 },
	enabled = true,
}
local optsPreferedAdd2 = {
	spawn_groups = { 100007, 100019, 100132, 101470 },
	enabled = true,
}
M.elements = {
	Eclipse.mission_elements.gen_preferedadd(400001, "eclipse_street_preferredadd", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedadd(400002, "eclipse_roof_preferredadd", optsPreferedAdd2),

	-- New Cloakers and their hiding spots
	-- hiding spots
	Eclipse.mission_elements.gen_so(400003, "cloaker_hide_so_1", Vector3(-648.686, 2211.427, 400), Rotation(-134, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400004, "cloaker_hide_so_2", Vector3(1424, -1244, 400), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400005, "cloaker_hide_so_3", Vector3(-392.736, 440.808, 400), Rotation(-48, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400006, "cloaker_hide_so_4", Vector3(-151.394, 2358.696, 400), Rotation(43, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400007, "cloaker_hide_so_5", Vector3(-155.973, 1899.677, 1000), Rotation(-132, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400008, "cloaker_hide_so_6", Vector3(1339, -1424, 1000), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400009, "cloaker_hide_so_7", Vector3(-667.477, 1242.322, 1000), Rotation(135, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400010, "cloaker_hide_so_8", Vector3(1712, -1363, 400), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400011, "cloaker_hide_so_9", Vector3(-2061, -1383, 0), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400012, "cloaker_hide_so_10", Vector3(-1242.360, -1297.438, 0), Rotation(-46, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400013, "cloaker_hide_so_11", Vector3(1402.970, -604.770, 0), Rotation(-137, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400014, "cloaker_hide_so_12", Vector3(-1530, 757, 1000), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400015, "cloaker_hide_so_13", Vector3(1007, -2807, 1000), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400016, "cloaker_hide_so_14", Vector3(1140.249, 599.957, 400), Rotation(138, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400017, "cloaker_hide_so_15", Vector3(739.191, -338.585, -100), Rotation(49, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400018, "cloaker_hide_so_16", Vector3(-1983.786, -2176.263, 0), Rotation(73, 0, 0), optsCloaker_Hide_SpotSO_3),
	-- cloakers
	Eclipse.mission_elements.gen_dummy(400019, "cloaker_spawn_1", Vector3(1833, -2078, 1475), Rotation(90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400020, "cloaker_spawn_2", Vector3(-943, -2575, 1556.213), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400021, "cloaker_spawn_3", Vector3(-12, -2996, 1000), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(400022, "cloaker_spawn_4", Vector3(-3876, -958, 4.500), Rotation(0, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400023, "cloaker_spawn_5", Vector3(1063, -3873, 3.500), Rotation(90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400024, "cloaker_spawn_6", Vector3(-467, -3998, 3.500), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400025, "cloaker_spawn_7", Vector3(-3909, 1143, 4.500), Rotation(180, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400026, "cloaker_spawn_8", Vector3(2933, 1376, 1611.859), Rotation(137, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400027, "cloaker_spawn_9", Vector3(-1417, 1826, 1496.140), Rotation(0, 0, 0), optsBesiegeDummyCloaker_2),
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(400028, "moon_cloaker_spawngroup_01", { 400019 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400029, "moon_cloaker_spawngroup_02", { 400020 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400030, "moon_cloaker_spawngroup_03", { 400021 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400031, "moon_cloaker_spawngroup_04", { 400022 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400032, "moon_cloaker_spawngroup_05", { 400023 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400033, "moon_cloaker_spawngroup_06", { 400024 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400034, "moon_cloaker_spawngroup_07", { 400025 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400035, "moon_cloaker_spawngroup_08", { 400026 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400036, "moon_cloaker_spawngroup_09", { 400027 }, 0),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(400037, "moon_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_sogroup(400038, "moon_cloaker_hide_group", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup),
	Eclipse.mission_elements.gen_missionscript(400039, "moon_cloaker_spawn_global", optsAddCloakerHideGroup),
}
return M
