---@module Breakfast in Tijuana
local M = {}
local optsBesiegeDummy = {
	trigger_times = 0,
	participate_to_group_ai = true,
	enabled = true,
}
local optsPreferedAdd1 = {
	spawn_groups = { 400006, 400012 },
	enabled = true,
}
local optsBesiegeDummy2 = {
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
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400019, delay = 0 },
		{ id = 400020, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400026, delay = 0 },
		{ id = 400027, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_3 = {
	on_executed = {
		{ id = 400033, delay = 0 },
		{ id = 400034, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}
M.elements = {
	Eclipse.mission_elements.gen_dummy(400001, "eclipse_spawn_enemy_001", Vector3(2200, 4500, -25), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "eclipse_spawn_enemy_002", Vector3(2100, 4500, -25), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "eclipse_spawn_enemy_003", Vector3(2000, 4500, -25), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "eclipse_spawn_enemy_004", Vector3(1900, 4500, -25), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400005, "eclipse_spawn_enemy_005", Vector3(1800, 4500, -25), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400006, "eclipse_enemy_group_001", { 400001, 400002, 400003, 400004, 400005 }, 0),

	Eclipse.mission_elements.gen_dummy(400007, "eclipse_spawn_enemy_006", Vector3(2500, -5000, 0), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400008, "eclipse_spawn_enemy_007", Vector3(2500, -5100, 0), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "eclipse_spawn_enemy_008", Vector3(2500, -5200, 0), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "eclipse_spawn_enemy_009", Vector3(2500, -5300, 0), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "eclipse_spawn_enemy_010", Vector3(2500, -5400, 0), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400012, "eclipse_enemy_group_002", { 400007, 400008, 400009, 400010, 400011 }, 0),

	Eclipse.mission_elements.gen_preferedadd(400013, "eclipse_street", optsPreferedAdd1),

	-- Arrive 1
	Eclipse.mission_elements.gen_dummy(400014, "eclipse_spawn_enemy_011", Vector3(4100, -1800, 0), Rotation(5, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_dummy(400015, "eclipse_spawn_enemy_012", Vector3(4025, -1800, 0), Rotation(5, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_dummy(400016, "eclipse_spawn_enemy_013", Vector3(4025, -1750, 0), Rotation(5, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_dummy(400017, "eclipse_spawn_enemy_014", Vector3(4100, -1750, 0), Rotation(5, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_missionscript(400018, "eclipse_spawn_van_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400019, "eclipse_open_van_doors_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_spawngroup(400020, "eclipse_enemy_group_003", { 400014, 400015, 400016, 400017 }, 0, opts_swat_group),

	-- Arrive 2
	Eclipse.mission_elements.gen_dummy(400021, "eclipse_spawn_enemy_015", Vector3(2925, -50, 0), Rotation(20, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_dummy(400022, "eclipse_spawn_enemy_016", Vector3(2850, -75, 0), Rotation(20, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_dummy(400023, "eclipse_spawn_enemy_017", Vector3(2825, 0, 0), Rotation(20, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_dummy(400024, "eclipse_spawn_enemy_018", Vector3(2900, 25, 0), Rotation(20, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_missionscript(400025, "eclipse_spawn_van_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400026, "eclipse_open_van_doors_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_2),
	Eclipse.mission_elements.gen_spawngroup(400027, "eclipse_enemy_group_004", { 400021, 400022, 400023, 400024 }, 0, opts_swat_group),

	-- Arrive 3
	Eclipse.mission_elements.gen_dummy(400028, "eclipse_spawn_enemy_019", Vector3(3450, -3700, 0), Rotation(-135, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_dummy(400029, "eclipse_spawn_enemy_020", Vector3(3400, -3750, 0), Rotation(-135, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_dummy(400030, "eclipse_spawn_enemy_021", Vector3(3350, -3700, 0), Rotation(-135, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_dummy(400031, "eclipse_spawn_enemy_022", Vector3(3400, -3650, 0), Rotation(-135, 0, 0), optsBesiegeDummy2),
	Eclipse.mission_elements.gen_missionscript(400032, "eclipse_spawn_van_swats_3", optsspawnvanSWATs_3),
	Eclipse.mission_elements.gen_object_editor(400033, "eclipse_open_van_doors_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_3),
	Eclipse.mission_elements.gen_spawngroup(400034, "eclipse_enemy_group_005", { 400028, 400029, 400030, 400031 }, 0, opts_swat_group),
}

return M
