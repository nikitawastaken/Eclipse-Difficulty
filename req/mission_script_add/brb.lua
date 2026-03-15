---@module Brooklyn Bank
local M = {}
local scripted_enemy = Eclipse.scripted_enemy

local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts

local cloaker = scripted_enemy.cloaker

local optsBesiegeDummyCloaker = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	enabled = true,
}
local optsPreferedCloakerAdd1 = {
	spawn_groups = { 400020, 400021, 400022, 400023, 400024, 400025, 400026 },
	on_executed = {
		{ id = 400028, delay = 0 },
	},
	enabled = true,
}
local optsAddCloakerHideGroup = {
	enabled = true,
	on_executed = {
		{ id = 400027, delay = 0 },
	},
}
local optsCloakerHideGroup = {
	followup_elements = {
		400001,
		400002,
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
	},
}
local optsAssaultStartSpoocs = {
	enabled = true,
	trigger_times = 1,
	global_event = "start_assault",
	on_executed = {
		{ id = 400029, delay = 0 },
	},
}

-- Hiding Cloaker SOs are funny
local hide_so_search_pos = Vector3(820, -825, 5)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_hide_under_car_enter", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var3", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_4 = get_hiding_cloaker_so_opts("e_so_hide_behind_door_enter", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_5 = get_hiding_cloaker_so_opts("e_so_sneak_wait_stand", hide_so_search_pos)

M.elements = {
	-- New Cloakers and their hiding spots
	-- hiding spots
	Eclipse.mission_elements.gen_so(400001, "cloaker_hide_so_1", Vector3(1480, -1280, 0), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_5),
	Eclipse.mission_elements.gen_so(400002, "cloaker_hide_so_2", Vector3(2515, -260, 0), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400003, "cloaker_hide_so_3", Vector3(2400, -1240, 0), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_5),
	Eclipse.mission_elements.gen_so(400004, "cloaker_hide_so_4", Vector3(2000, -1380, 350), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400005, "cloaker_hide_so_5", Vector3(440, -2450, -150), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400006, "cloaker_hide_so_6", Vector3(2300, -2400, -150), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400007, "cloaker_hide_so_7", Vector3(-2215, -2175, -130), Rotation(10, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400008, "cloaker_hide_so_8", Vector3(-2775, -2250, -140), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400009, "cloaker_hide_so_9", Vector3(-3140, -2225, -20), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400010, "cloaker_hide_so_10", Vector3(1538, -1927, 2.395), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400011, "cloaker_hide_so_11", Vector3(2632, -1927, 2.395), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400012, "cloaker_hide_so_12", Vector3(-129, -641, 2.395), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_3),
	-- cloakers
	Eclipse.mission_elements.gen_dummy(400013, "cloaker_spawn_1", Vector3(4917, -823, 6.683), Rotation(180, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400014, "cloaker_spawn_2", Vector3(4878, -4544, 2.127), Rotation(0, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400015, "cloaker_spawn_3", Vector3(1881, -6260, 2), Rotation(-68, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400016, "cloaker_spawn_4", Vector3(340, 2750, 4.594), Rotation(0, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400017, "cloaker_spawn_5", Vector3(3547, 350, 676.187), Rotation(90, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400018, "cloaker_spawn_6", Vector3(-1945.647, -7802.516, 2.395), Rotation(-90, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400019, "cloaker_spawn_7", Vector3(1635, 797, 676.187), Rotation(-180, 0, 0), optsBesiegeDummyCloaker),
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(400020, "brb_cloaker_spawngroup_01", { 400013 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400021, "brb_cloaker_spawngroup_02", { 400014 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400022, "brb_cloaker_spawngroup_03", { 400015 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400023, "brb_cloaker_spawngroup_04", { 400016 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400024, "brb_cloaker_spawngroup_05", { 400017 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400025, "brb_cloaker_spawngroup_06", { 400018 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400026, "brb_cloaker_spawngroup_07", { 400019 }, 0),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(400027, "brb_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_sogroup(400028, "brb_cloaker_hide_group", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup),
	Eclipse.mission_elements.gen_missionscript(400029, "brb_cloaker_spawn_global", optsAddCloakerHideGroup),
	Eclipse.mission_elements.gen_global_event(400030, "brb_assault_start_cloaker", Vector3(0, 0, 0), Rotation(0, 0, 0), optsAssaultStartSpoocs),
}
return M
