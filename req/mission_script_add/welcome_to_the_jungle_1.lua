---@module Big Oil Day 1
local M = {}

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsOpenSwatVanDoors = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101379, notify_unit_sequence = "anim_door_right_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 101379, notify_unit_sequence = "anim_door_left_open", time = 0 },
	},
}
local optsspawnvanSWATs = {
	on_executed = {
		{ id = 400007, delay = 0 },
		{ id = 400006, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

M.elements = {
	-- swat van
	Eclipse.mission_elements.gen_dummy(400001, "swat_van_spawn_1", Vector3(7602, -9027, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_van_spawn_2", Vector3(7615.272, -8970.512, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_3", Vector3(7675.528, -9042.923, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_4", Vector3(7688.350, -8987.384, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_swats", optsspawnvanSWATs),
	Eclipse.mission_elements.gen_object_editor(400006, "open_swat_doors", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors),
	Eclipse.mission_elements.gen_spawngroup(400007, "swat_group", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),
}

return M
