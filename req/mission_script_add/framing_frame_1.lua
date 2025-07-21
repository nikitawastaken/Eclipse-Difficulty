---@module Framing Frame Day 1
local M = {}
local optsVentBreaker = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 104021, notify_unit_sequence = "release_vent", time = 0 },
	},
}
local optscloakerspawned = {
	on_executed = {
		{ id = 400001, delay = 0 },
	},
	elements = {
		104056,
	},
}

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101884, notify_unit_sequence = "anim_door_right_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 101884, notify_unit_sequence = "anim_door_left_open", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400008, delay = 0 },
		{ id = 400009, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

M.elements = {
	-- vent fix
	Eclipse.mission_elements.gen_object_editor(400001, "break_the_vent", Vector3(0, 0, 0), Rotation(0, 0, 0), optsVentBreaker),
	Eclipse.mission_elements.gen_dummytrigger(400002, "cloaker_spawned", Vector3(0, 0, 0), Rotation(0, 0, 0), optscloakerspawned),
	-- swat van
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_1", Vector3(4182, 2978, -120), Rotation(-18, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_2", Vector3(4111.622, 3000.867, -120), Rotation(-18, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400005, "swat_van_spawn_3", Vector3(4130.472, 3058.882, -120), Rotation(-18, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400006, "swat_van_spawn_4", Vector3(4203.704, 3035.087, -120), Rotation(-18, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400007, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400008, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_spawngroup(400009, "swat_group_1", { 400003, 400004, 400005, 400006 }, 0, opts_swat_group),
}

return M
