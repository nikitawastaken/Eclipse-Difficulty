---@module Rats Day 1
local M = {}
local is_eclipse = Eclipse.utils.is_eclipse()

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

M.elements = {
	-- activate Eclipse exclusive event
	Eclipse.mission_elements.gen_missionscript(400001, "activate_eclipse_navlinks", activate_navlinks),
	-- restoration of unused fence spawn
	Eclipse.mission_elements.gen_dummy(400002, "eclipse_spawn_enemy_001", Vector3(1733, -1931, 874.683), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "eclipse_spawn_enemy_002", Vector3(1672, -1931, 874.683), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "eclipse_spawn_enemy_003", Vector3(1605, -1931, 874.683), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400005, "eclipse_spawn_enemy_004", Vector3(1539, -1931, 874.683), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400006, "eclipse_spawn_enemy_005", Vector3(1469, -1931, 874.683), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400007, "eclipse_enemy_group_001", { 400002, 400003, 400004, 400005, 400006 }, 0),
	-- fix for police chopper
	Eclipse.mission_elements.gen_object_editor(400008, "cook_off_police_chopper_fix", Vector3(0, 0, 0), Rotation(0, 0, -0), optsPolice_chopper_fix),
	-- loop script for the choppers
	Eclipse.mission_elements.gen_missionscript(400009, "activate_eclipse_navlinks", optschopper_loop),
}

return M
