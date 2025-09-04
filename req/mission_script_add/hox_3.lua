---@module Hoxton Revenge
local M = {}

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400006, delay = 0 },
		{ id = 400008, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400015, delay = 0 },
		{ id = 400017, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_3 = {
	on_executed = {
		{ id = 400024, delay = 0 },
		{ id = 400026, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_4 = {
	on_executed = {
		{ id = 400033, delay = 0 },
		{ id = 400035, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}
local optsSwatVanArrive_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103517, notify_unit_sequence = "state_vis_show", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 103517, notify_unit_sequence = "anim_van_swat_hox_arrive_2", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 103517, notify_unit_sequence = "state_lights_on", time = 0 },
	},
}
local optsSwatVanArrive_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103519, notify_unit_sequence = "state_vis_show", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 103519, notify_unit_sequence = "anim_van_swat_hox_arrive_3", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 103519, notify_unit_sequence = "state_lights_on", time = 0 },
	},
}
local optsSwatVanArrive_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103520, notify_unit_sequence = "state_vis_show", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 103520, notify_unit_sequence = "anim_van_swat_hox_arrive_4", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 103520, notify_unit_sequence = "state_lights_on", time = 0 },
	},
}
local optsSwatVanArrive_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103516, notify_unit_sequence = "state_vis_show", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 103516, notify_unit_sequence = "queue_van_swat_hox_arrive_1_1", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 103516, notify_unit_sequence = "state_lights_on", time = 0 },
	},
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103517, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 103517, notify_unit_sequence = "state_lights_off", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103519, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 103519, notify_unit_sequence = "state_lights_off", time = 0 },
	},
}
local optsOpenSwatVanDoors_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103520, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 103520, notify_unit_sequence = "state_lights_off", time = 0 },
	},
}
local optsOpenSwatVanDoors_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103516, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_Trigger_1 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_car_anim", unit_id = 103517 },
	},
	on_executed = {
		{ id = 400005, delay = 0, delay_rand = 5 },
	},
}
local optsOpenSwatVanDoors_Trigger_2 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_car_anim", unit_id = 103519 },
	},
	on_executed = {
		{ id = 400014, delay = 0, delay_rand = 5 },
	},
}
local optsOpenSwatVanDoors_Trigger_3 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_car_anim", unit_id = 103520 },
	},
	on_executed = {
		{ id = 400023, delay = 0, delay_rand = 5 },
	},
}
local pick_a_swat_van = {
	amount = 1,
	trigger_times = 1,
	on_executed = {
		{ id = 400037, delay = 0 },
		{ id = 400038, delay = 0 },
		{ id = 400039, delay = 0 },
		{ id = 400040, delay = 0 },
	},
}
local swat_van_response_variant_1 = {
	on_executed = { { id = 400007, delay = 0 }, { id = 400016, delay = 120, delay_rand = 30 }, { id = 400025, delay = 180, delay_rand = 30 }, { id = 400034, delay = 240, delay_rand = 30 } },
	enabled = true,
}
local swat_van_response_variant_2 = {
	on_executed = { { id = 400034, delay = 0 }, { id = 400025, delay = 120, delay_rand = 30 }, { id = 400016, delay = 180, delay_rand = 30 }, { id = 400007, delay = 240, delay_rand = 30 } },
	enabled = true,
}
local swat_van_response_variant_3 = {
	on_executed = { { id = 400025, delay = 0 }, { id = 400034, delay = 120, delay_rand = 30 }, { id = 400007, delay = 180, delay_rand = 30 }, { id = 400016, delay = 240, delay_rand = 30 } },
	enabled = true,
}
local swat_van_response_variant_4 = {
	on_executed = { { id = 400016, delay = 0 }, { id = 400007, delay = 120, delay_rand = 30 }, { id = 400034, delay = 180, delay_rand = 30 }, { id = 400025, delay = 240, delay_rand = 30 } },
	enabled = true,
}

M.elements = {
	-- swat van 1
	Eclipse.mission_elements.gen_dummy(400001, "swat_van_spawn_1", Vector3(4063, -1547, 44.504), Rotation(-121, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_van_spawn_2", Vector3(4097.508, -1489.570, 44.504), Rotation(-121, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_3", Vector3(4110.832, -1572.241, 44.504), Rotation(-121, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_4", Vector3(4143.795, -1517.382, 44.504), Rotation(-121, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400006, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_object_editor(400007, "swat_arrive_new_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsSwatVanArrive_1),
	Eclipse.mission_elements.gen_spawngroup(400008, "swat_group_1", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),
	Eclipse.mission_elements.gen_object_editor_trigger(400009, "swat_van_doors_trigger", optsOpenSwatVanDoors_Trigger_1),

	-- swat van 2
	Eclipse.mission_elements.gen_dummy(400010, "swat_van_spawn_5", Vector3(1531, -4058, 789.901), Rotation(-138, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "swat_van_spawn_6", Vector3(1579.304, -4014.507, 789.901), Rotation(-138, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400012, "swat_van_spawn_7", Vector3(1580.590, -4111.581, 789.901), Rotation(-138, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400013, "swat_van_spawn_8", Vector3(1628.151, -4068.756, 789.901), Rotation(-138, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400014, "spawn_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400015, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_2),
	Eclipse.mission_elements.gen_object_editor(400016, "swat_arrive_new_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optsSwatVanArrive_2),
	Eclipse.mission_elements.gen_spawngroup(400017, "swat_group_2", { 400010, 400011, 400012, 400013 }, 0, opts_swat_group),
	Eclipse.mission_elements.gen_object_editor_trigger(400018, "swat_van_doors_trigger_2", optsOpenSwatVanDoors_Trigger_2),

	-- swat van 3
	Eclipse.mission_elements.gen_dummy(400019, "swat_van_spawn_9", Vector3(-1370, -4731, 789.901), Rotation(-139, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400020, "swat_van_spawn_10", Vector3(-1320.944, -4688.356, 789.901), Rotation(-139, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400021, "swat_van_spawn_11", Vector3(-1328.407, -4784.944, 789.901), Rotation(-139, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400022, "swat_van_spawn_12", Vector3(-1276.332, -4739.676, 789.901), Rotation(-139, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400023, "spawn_swats_3", optsspawnvanSWATs_3),
	Eclipse.mission_elements.gen_object_editor(400024, "open_swat_doors_3", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_3),
	Eclipse.mission_elements.gen_object_editor(400025, "swat_arrive_new_3", Vector3(0, 0, 0), Rotation(0, 0, -0), optsSwatVanArrive_3),
	Eclipse.mission_elements.gen_spawngroup(400026, "swat_group_3", { 400019, 400020, 400021, 400022 }, 0, opts_swat_group),
	Eclipse.mission_elements.gen_object_editor_trigger(400027, "swat_van_doors_trigger", optsOpenSwatVanDoors_Trigger_3),

	-- swat van 4
	Eclipse.mission_elements.gen_dummy(400028, "swat_van_spawn_13", Vector3(-1694, 0, -9.738), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400029, "swat_van_spawn_14", Vector3(-1694, -74, -9.738), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400030, "swat_van_spawn_15", Vector3(-1778, 0, -9.738), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400031, "swat_van_spawn_16", Vector3(-1778, -74, -9.738), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400032, "spawn_swats_4", optsspawnvanSWATs_4),
	Eclipse.mission_elements.gen_object_editor(400033, "open_swat_doors_4", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_4),
	Eclipse.mission_elements.gen_object_editor(400034, "swat_arrive_new_4", Vector3(0, 0, 0), Rotation(0, 0, -0), optsSwatVanArrive_4),
	Eclipse.mission_elements.gen_spawngroup(400035, "swat_group_4", { 400028, 400029, 400030, 400031 }, 0, opts_swat_group),

	-- new vans arrival stuff
	Eclipse.mission_elements.gen_element_random(400036, "begin_swat_vans", pick_a_swat_van),
	Eclipse.mission_elements.gen_missionscript(400037, "swat_van_response_1", swat_van_response_variant_1),
	Eclipse.mission_elements.gen_missionscript(400038, "swat_van_response_2", swat_van_response_variant_2),
	Eclipse.mission_elements.gen_missionscript(400039, "swat_van_response_3", swat_van_response_variant_3),
	Eclipse.mission_elements.gen_missionscript(400040, "swat_van_response_4", swat_van_response_variant_4),
}

return M
