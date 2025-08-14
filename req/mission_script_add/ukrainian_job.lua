---@module Ukrainian Job
local M = {}

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_jump_down_heli_cbt_left",
}
local optsOpenHeliLefttDoor = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102590, notify_unit_sequence = "open_door_left", time = 0 },
	},
}
local optsCloseHeliLeftDoor = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102590, notify_unit_sequence = "close_door_left", time = 0 },
	},
}
local optsspawnchopperSWATs_1 = {
	on_executed = {
		{ id = 400004, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

M.elements = {
	-- swat chopper
	Eclipse.mission_elements.gen_dummy(400001, "swat_chopper_spawn_1", Vector3(63.545, 3776.085, 25), Rotation(-2.446, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_chopper_spawn_2", Vector3(-3.394, 3778.944, 25), Rotation(-2.446, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400003, "spawn_swats_1", optsspawnchopperSWATs_1),
	Eclipse.mission_elements.gen_spawngroup(400004, "swat_group_1", { 102602, 102595, 400001, 400002 }, 0, opts_swat_group),
	Eclipse.mission_elements.gen_object_editor(400005, "open_heli_door_left", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenHeliLefttDoor),
	Eclipse.mission_elements.gen_object_editor(400006, "close_heli_door_left", Vector3(0, 0, 0), Rotation(0, 0, -0), optsCloseHeliLeftDoor),
}

return M
