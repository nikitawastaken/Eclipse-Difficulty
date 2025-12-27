---@module Breakfast in Tijuana
local M = {}
local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102206, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101645, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102207, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102208, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_5 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102209, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
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
		{ id = 400013, delay = 0 },
		{ id = 400014, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_3 = {
	on_executed = {
		{ id = 400020, delay = 0 },
		{ id = 400021, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_4 = {
	on_executed = {
		{ id = 400027, delay = 0 },
		{ id = 400028, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_5 = {
	on_executed = {
		{ id = 400034, delay = 0 },
		{ id = 400036, delay = 0 },
	},
	enabled = true,
}
local optsOpenSwatVanDoors_Trigger_1 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_car_anim", unit_id = 102209 },
	},
	on_executed = {
		{ id = 400033, delay = 0, delay_rand = 5 },
	},
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}
M.elements = {
	-- Arrive 1
	Eclipse.mission_elements.gen_dummy(400001, "eclipse_spawn_enemy_011", Vector3(4100, -1800, 0), Rotation(5, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "eclipse_spawn_enemy_012", Vector3(4025, -1800, 0), Rotation(5, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "eclipse_spawn_enemy_013", Vector3(4025, -1750, 0), Rotation(5, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "eclipse_spawn_enemy_014", Vector3(4100, -1750, 0), Rotation(5, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "eclipse_spawn_van_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400006, "eclipse_open_van_doors_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_spawngroup(400007, "eclipse_enemy_group_001", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),

	-- Arrive 2
	Eclipse.mission_elements.gen_dummy(400008, "eclipse_spawn_enemy_015", Vector3(2925, -50, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "eclipse_spawn_enemy_016", Vector3(2850, -75, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "eclipse_spawn_enemy_017", Vector3(2825, 0, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "eclipse_spawn_enemy_018", Vector3(2900, 25, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400012, "eclipse_spawn_van_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400013, "eclipse_open_van_doors_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_2),
	Eclipse.mission_elements.gen_spawngroup(400014, "eclipse_enemy_group_002", { 400008, 400009, 400010, 400011 }, 0, opts_swat_group),

	-- Arrive 3
	Eclipse.mission_elements.gen_dummy(400015, "eclipse_spawn_enemy_019", Vector3(3450, -3700, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400016, "eclipse_spawn_enemy_020", Vector3(3400, -3750, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400017, "eclipse_spawn_enemy_021", Vector3(3350, -3700, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400018, "eclipse_spawn_enemy_022", Vector3(3400, -3650, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400019, "eclipse_spawn_van_swats_3", optsspawnvanSWATs_3),
	Eclipse.mission_elements.gen_object_editor(400020, "eclipse_open_van_doors_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_3),
	Eclipse.mission_elements.gen_spawngroup(400021, "eclipse_enemy_group_003", { 400015, 400016, 400017, 400018 }, 0, opts_swat_group),

	-- Arrive 4
	Eclipse.mission_elements.gen_dummy(400022, "eclipse_spawn_enemy_023", Vector3(-3416.319, -2584.237, -24.871), Rotation(136, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400023, "eclipse_spawn_enemy_024", Vector3(-3364.526, -2634.252, -24.871), Rotation(136, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400024, "eclipse_spawn_enemy_025", Vector3(-3455.914, -2625.239, -24.871), Rotation(136, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400025, "eclipse_spawn_enemy_026", Vector3(-3403.402, -2675.949, -24.871), Rotation(136, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400026, "eclipse_spawn_van_swats_4", optsspawnvanSWATs_4),
	Eclipse.mission_elements.gen_object_editor(400027, "eclipse_open_van_doors_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_4),
	Eclipse.mission_elements.gen_spawngroup(400028, "eclipse_enemy_group_004", { 400022, 400023, 400024, 400025 }, 0, opts_swat_group),

	-- Arrive 5
	Eclipse.mission_elements.gen_dummy(400029, "eclipse_spawn_enemy_023", Vector3(-4324, -3326, -24.871), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400030, "eclipse_spawn_enemy_024", Vector3(-4388, -3324, -24.871), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400031, "eclipse_spawn_enemy_025", Vector3(-4327, -3258, -24.871), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400032, "eclipse_spawn_enemy_026", Vector3(-4388, -3258, -24.871), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400033, "eclipse_spawn_van_swats_5", optsspawnvanSWATs_5),
	Eclipse.mission_elements.gen_object_editor(400034, "eclipse_open_van_doors_5", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_5),
	Eclipse.mission_elements.gen_object_editor_trigger(400035, "swat_van_doors_trigger_1", optsOpenSwatVanDoors_Trigger_1),
	Eclipse.mission_elements.gen_spawngroup(400036, "eclipse_enemy_group_005", { 400029, 400030, 400031, 400032 }, 0, opts_swat_group),
}

return M
