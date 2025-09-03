---@module Alaskan Deal
local M = {}

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400006, delay = 0 },
		{ id = 400007, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400014, delay = 0 },
		{ id = 400015, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_3 = {
	on_executed = {
		{ id = 400022, delay = 0 },
		{ id = 400023, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100677, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100131, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100678, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_Trigger_1 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_car_anim", unit_id = 100677 },
	},
	on_executed = {
		{ id = 400005, delay = 0, delay_rand = 5 },
	},
}
local optsOpenSwatVanDoors_Trigger_2 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_car_anim", unit_id = 100131 },
	},
	on_executed = {
		{ id = 400013, delay = 0, delay_rand = 5 },
	},
}
local optsOpenSwatVanDoors_Trigger_3 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_car_anim", unit_id = 100678 },
	},
	on_executed = {
		{ id = 400021, delay = 0, delay_rand = 5 },
	},
}

M.elements = {
	-- swat van 1
	Eclipse.mission_elements.gen_dummy(400001, "swat_van_spawn_1", Vector3(3935, 846, 1149.998), Rotation(-35, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_van_spawn_2", Vector3(3884.213, 881.562, 1149.998), Rotation(-35, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_3", Vector3(3971.555, 897.033, 1149.998), Rotation(-35, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_4", Vector3(3920.348, 933.168, -19.999), Rotation(-35, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400006, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_spawngroup(400007, "swat_group_1", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),
	Eclipse.mission_elements.gen_object_editor_trigger(400008, "swat_van_doors_trigger", optsOpenSwatVanDoors_Trigger_1),

	-- swat van 2
	Eclipse.mission_elements.gen_dummy(400009, "swat_van_spawn_5", Vector3(3292, 3732, 949.997), Rotation(75, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "swat_van_spawn_6", Vector3(3274.142, 3665.351, 949.997), Rotation(75, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "swat_van_spawn_7", Vector3(3227.990, 3748.116, 949.997), Rotation(75, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400012, "swat_van_spawn_8", Vector3(3210.132, 3681.447, 949.997), Rotation(75, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400013, "spawn_swats_2", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400014, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_2),
	Eclipse.mission_elements.gen_spawngroup(400015, "swat_group_2", { 400009, 400010, 400011, 400012 }, 0, opts_swat_group),
	Eclipse.mission_elements.gen_object_editor_trigger(400016, "swat_van_doors_trigger_2", optsOpenSwatVanDoors_Trigger_2),

	-- swat van 3
	Eclipse.mission_elements.gen_dummy(400017, "swat_van_spawn_9", Vector3(979, 3807, 949.997), Rotation(97, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400018, "swat_van_spawn_10", Vector3(986.068, 3749.432, 949.997), Rotation(97, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400019, "swat_van_spawn_11", Vector3(918.089, 3802.543, 949.997), Rotation(97, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400020, "swat_van_spawn_12", Vector3(925.523, 3741.998, 949.997), Rotation(97, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400021, "spawn_swats_3", optsspawnvanSWATs_3),
	Eclipse.mission_elements.gen_object_editor(400022, "open_swat_doors_3", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_3),
	Eclipse.mission_elements.gen_spawngroup(400023, "swat_group_1", { 400017, 400018, 400019, 400020 }, 0, opts_swat_group),
	Eclipse.mission_elements.gen_object_editor_trigger(400024, "swat_van_doors_trigger", optsOpenSwatVanDoors_Trigger_3),
}

return M
