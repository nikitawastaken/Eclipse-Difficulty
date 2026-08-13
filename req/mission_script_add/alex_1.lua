---@module Rats Day 1
local M = {}
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy
local get_navlink_so_opts = Eclipse.utils.get_navlink_so_opts

local optsBesiegeDummyCloaker01 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	enabled = true,
}
local optsBesiegeDummyCloaker02 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_climb_over_2m",
	enabled = true,
}
local optsPreferedCloakerAdd = {
	spawn_groups = { 400020, 400021, 400022, 400023 },
	on_executed = {
		{ id = 101946, delay = 0 },
	},
	enabled = true,
}
local activate_navlinks = {
	enabled = is_eclipse,
	trigger_times = 1,
	on_executed = {
		{ id = 101483, delay = 0 },
		{ id = 101484, delay = 0 },
		{ id = 101485, delay = 0 },
		{ id = 101486, delay = 0 },
		{ id = 101508, delay = 0 },
		{ id = 101770, delay = 0 },
		{ id = 101509, delay = 0 },
		{ id = 101510, delay = 0 },
		{ id = 102124, delay = 0 },
		{ id = 102125, delay = 0 },
		{ id = 101872, delay = 0 },
		{ id = 101873, delay = 0 },
		{ id = 400013, delay = 0 },
		{ id = 400014, delay = 0 },
		{ id = 400015, delay = 0 },
	},
}
local optschopper_loop = {
	on_executed = { { id = 100965, delay = 300, delay_rand = 60 } },
	enabled = true,
}
local optsBesiegeDummy = {
	trigger_times = 0,
	participate_to_group_ai = true,
	spawn_action = "e_sp_climb_over_2m",
	enabled = true,
}
local optsPolice_chopper_fix = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101646, notify_unit_sequence = "swat_night", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 101646, notify_unit_sequence = "flyin_fwd_hover", time = 0 },
	},
	on_executed = {
		{ id = 101648, delay = 50 },
	},
}
local optsCookedBagsCounter = {
	enabled = true,
}
local optsCookedBagsCounterOperator = {
	operation = "add",
	amount = 1,
	elements = {
		400010,
	},
	enabled = true,
}
local optsCookedBagsCounterTrigger = {
	trigger_type = "value",
	amount = 15,
	elements = {
		400010,
	},
	enabled = true,
}
local optsBasementNavlink01 = get_navlink_so_opts("e_nl_slide_down_2m", Vector3(1650, 1325, 925), 6, false, true, true, nil, tostring(128 + 512 + 1024 + 8192))
local optsBasementNavlink02 = get_navlink_so_opts("e_nl_slide_down_2m", Vector3(2150, 825, 925), 6, false, true, true, nil, tostring(128 + 512 + 1024 + 8192))
local optsBasementNavlink03 = get_navlink_so_opts("e_nl_slide_down_2m", Vector3(2150, 525, 925), 6, false, true, true, nil, tostring(128 + 512 + 1024 + 8192))

M.elements = {
	-- Activate Eclipse exclusive event
	Eclipse.mission_elements.gen_missionscript(400001, "activate_eclipse_navlinks", activate_navlinks),
	-- Restoration of unused fence spawn
	Eclipse.mission_elements.gen_dummy(400002, "eclipse_spawn_enemy_001", Vector3(1800, -1925, 875), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "eclipse_spawn_enemy_002", Vector3(1700, -1925, 875), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "eclipse_spawn_enemy_003", Vector3(1600, -1925, 875), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400005, "eclipse_spawn_enemy_004", Vector3(1500, -1925, 875), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400006, "eclipse_spawn_enemy_005", Vector3(1400, -1925, 875), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400007, "alex_fence_enemy_group01", { 400002, 400003, 400004, 400005, 400006 }, 0),
	-- Fix for police chopper
	Eclipse.mission_elements.gen_object_editor(400008, "cook_off_police_chopper_fix", Vector3(0, 0, 0), Rotation(0, 0, -0), optsPolice_chopper_fix),
	-- Loop script for the choppers
	Eclipse.mission_elements.gen_missionscript(400009, "chopper_loop", optschopper_loop),
	Eclipse.mission_elements.gen_counter(400010, "cooked_bags_counter", optsCookedBagsCounter),
	Eclipse.mission_elements.gen_counter_operator(400011, "cooked_bags_counter_addend", optsCookedBagsCounterOperator),
	Eclipse.mission_elements.gen_counter_trigger(400012, "cooked_bags_counter_trigger", optsCookedBagsCounterTrigger),
	-- Add new navlinks to give enemies alternate routes into the basement
	Eclipse.mission_elements.gen_so(400013, "basement_navlink01", Vector3(1450, 1325, 1130), Rotation(-90, 0, 0), optsBasementNavlink01),
	Eclipse.mission_elements.gen_so(400014, "basement_navlink02", Vector3(2400, 825, 1130), Rotation(90, 0, 0), optsBasementNavlink02),
	Eclipse.mission_elements.gen_so(400015, "basement_navlink03", Vector3(2400, 525, 1130), Rotation(90, 0, 0), optsBasementNavlink03),
	-- Add recurring Cloaker groups to use the restored hide SOs
	Eclipse.mission_elements.gen_dummy(400016, "cloaker_spawn01", Vector3(1225, 4875, 1425), Rotation(180, 0, 0), optsBesiegeDummyCloaker01),
	Eclipse.mission_elements.gen_dummy(400017, "cloaker_spawn02", Vector3(4600, 975, 1200), Rotation(90, 0, 0), optsBesiegeDummyCloaker01),
	Eclipse.mission_elements.gen_dummy(400018, "cloaker_spawn03", Vector3(2100, -1950, 875), Rotation(0, 0, 0), optsBesiegeDummyCloaker02),
	Eclipse.mission_elements.gen_dummy(400019, "cloaker_spawn04", Vector3(-4200, -1950, 1250), Rotation(-90, 0, 0), optsBesiegeDummyCloaker01),
	Eclipse.mission_elements.gen_spawngroup(400020, "alex_cloaker_spawngroup_01", { 400016 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400021, "alex_cloaker_spawngroup_02", { 400017 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400022, "alex_cloaker_spawngroup_03", { 400018 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400023, "alex_cloaker_spawngroup_04", { 400019 }, 0),
	Eclipse.mission_elements.gen_preferedadd(400024, "alex_cloaker_spawns", optsPreferedCloakerAdd),
	-- Restoration of unused fence spawn 2.0
	Eclipse.mission_elements.gen_dummy(400025, "eclipse_spawn_enemy_006", Vector3(3375, -1300, 875), Rotation(45, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400026, "eclipse_spawn_enemy_007", Vector3(3275, -1400, 875), Rotation(45, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400027, "eclipse_spawn_enemy_008", Vector3(3175, -1500, 875), Rotation(45, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400028, "eclipse_spawn_enemy_009", Vector3(3075, -1600, 875), Rotation(45, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400029, "eclipse_spawn_enemy_010", Vector3(2975, -1700, 875), Rotation(45, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400030, "alex_fence_enemy_group02", { 400025, 400026, 400027, 400028, 400029 }, 0),
}

return M
