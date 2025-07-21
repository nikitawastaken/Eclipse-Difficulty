---@module Four Stores
local M = {}
local optsPreferedAdd = {
	spawn_groups = { 101375 },
	enabled = true,
}

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100453, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400007, delay = 0 },
		{ id = 400008, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

M.elements = {
	Eclipse.mission_elements.gen_preferedadd(400001, "eclipse_rappel_preferedadd", optsPreferedAdd),
	-- swat van
	Eclipse.mission_elements.gen_dummy(400002, "swat_van_spawn_1", Vector3(-329, -3309, 5.001), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_2", Vector3(-329, -3397, 5.001), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_3", Vector3(-382, -3297, 5.001), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400005, "swat_van_spawn_4", Vector3(-382, -3397, 5.001), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400006, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400007, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_spawngroup(400008, "swat_group_1", { 400002, 400003, 400004, 400005 }, 0, opts_swat_group),
}
return M
