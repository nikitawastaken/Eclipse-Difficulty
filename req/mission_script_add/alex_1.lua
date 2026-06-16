---@module Rats Day 1
local M = {}
local is_eclipse = Eclipse.utils.is_eclipse()
local get_navlink_so_opts = Eclipse.utils.get_navlink_so_opts
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
	amount = 15,
	elements = {
		400010,
	},
	enabled = true,
}
local optsBasementNavlink01 = get_navlink_so_opts("e_nl_slide_down_2m", Vector3(1650, 1325, 925), 10, nil, tostring(128 + 512 + 1024 + 8192))
local optsBasementNavlink02 = get_navlink_so_opts("e_nl_slide_down_2m", Vector3(2150, 825, 925), 10, nil, tostring(128 + 512 + 1024 + 8192))
local optsBasementNavlink03 = get_navlink_so_opts("e_nl_slide_down_2m", Vector3(2150, 525, 925), 10, nil, tostring(128 + 512 + 1024 + 8192))

M.elements = {
	-- Activate Eclipse exclusive event
	Eclipse.mission_elements.gen_missionscript(400001, "activate_eclipse_navlinks", activate_navlinks),
	-- Restoration of unused fence spawn
	Eclipse.mission_elements.gen_dummy(400002, "eclipse_spawn_enemy_001", Vector3(1733, -1931, 874.683), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "eclipse_spawn_enemy_002", Vector3(1672, -1931, 874.683), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "eclipse_spawn_enemy_003", Vector3(1605, -1931, 874.683), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400005, "eclipse_spawn_enemy_004", Vector3(1539, -1931, 874.683), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400006, "eclipse_spawn_enemy_005", Vector3(1469, -1931, 874.683), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400007, "eclipse_enemy_group_001", { 400002, 400003, 400004, 400005, 400006 }, 0),
	-- Fix for police chopper
	Eclipse.mission_elements.gen_object_editor(400008, "cook_off_police_chopper_fix", Vector3(0, 0, 0), Rotation(0, 0, -0), optsPolice_chopper_fix),
	-- Loop script for the choppers
	Eclipse.mission_elements.gen_missionscript(400009, "chopper_loop", optschopper_loop),
--	Eclipse.mission_elements.gen_counter(400010, "cooked_bags_counter", optsCookedBagsCounter),
--	Eclipse.mission_elements.gen_counter_operator(400011, "cooked_bags_counter_addend", optsCookedBagsCounterOperator),
--	Eclipse.mission_elements.gen_counter_trigger(400012, "cooked_bags_counter_trigger", optsCookedBagsCounterTrigger),
	-- Add new navlinks to give enemies alternate routes into the basement
	Eclipse.mission_elements.gen_so(400013, "basement_navlink01", Vector3(1450, 1325, 1115), Rotation(-90, 0, 0), optsBasementNavlink01),
	Eclipse.mission_elements.gen_so(400014, "basement_navlink02", Vector3(2350, 825, 1115), Rotation(90, 0, 0), optsBasementNavlink02),
	Eclipse.mission_elements.gen_so(400015, "basement_navlink03", Vector3(2350, 525, 1115), Rotation(90, 0, 0), optsBasementNavlink03),
}

return M
