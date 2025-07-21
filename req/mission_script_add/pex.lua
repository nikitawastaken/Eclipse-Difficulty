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
	Eclipse.mission_elements.gen_spawngroup(400007, "eclipse_enemy_group_003", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),

	-- Arrive 2
	Eclipse.mission_elements.gen_dummy(400008, "eclipse_spawn_enemy_015", Vector3(2925, -50, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "eclipse_spawn_enemy_016", Vector3(2850, -75, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "eclipse_spawn_enemy_017", Vector3(2825, 0, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "eclipse_spawn_enemy_018", Vector3(2900, 25, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400012, "eclipse_spawn_van_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400013, "eclipse_open_van_doors_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_2),
	Eclipse.mission_elements.gen_spawngroup(400014, "eclipse_enemy_group_004", { 400008, 400009, 400010, 400011 }, 0, opts_swat_group),

	-- Arrive 3
	Eclipse.mission_elements.gen_dummy(400015, "eclipse_spawn_enemy_019", Vector3(3450, -3700, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400016, "eclipse_spawn_enemy_020", Vector3(3400, -3750, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400017, "eclipse_spawn_enemy_021", Vector3(3350, -3700, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400018, "eclipse_spawn_enemy_022", Vector3(3400, -3650, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400019, "eclipse_spawn_van_swats_3", optsspawnvanSWATs_3),
	Eclipse.mission_elements.gen_object_editor(400020, "eclipse_open_van_doors_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_3),
	Eclipse.mission_elements.gen_spawngroup(400021, "eclipse_enemy_group_005", { 400015, 400016, 400017, 400018 }, 0, opts_swat_group),
}

return M
