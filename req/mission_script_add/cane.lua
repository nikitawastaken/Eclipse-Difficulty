---@module Santa's Workshop
local M = {}
local optsBesiegeDummy = {
	trigger_times = 0,
	participate_to_group_ai = true,
	enabled = true,
}
local optsPreferedAdd = {
	spawn_groups = { 400006, 400012 },
	enabled = true,
}
M.elements = {
	Eclipse.mission_elements.gen_dummy(400001, "eclipse_spawn_enemy_001", Vector3(8025, -4050, -40), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "eclipse_spawn_enemy_002", Vector3(8100, -4150, -40), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "eclipse_spawn_enemy_003", Vector3(8100, -4000, -40), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "eclipse_spawn_enemy_004", Vector3(8025, -3950, -40), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400005, "eclipse_spawn_enemy_005", Vector3(7797, -4000, -40), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400006, "eclipse_enemy_group_001", { 400001, 400002, 400003, 400004, 400005 }, 0),

	Eclipse.mission_elements.gen_dummy(400007, "eclipse_spawn_enemy_006", Vector3(7900, 3850, -40), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400008, "eclipse_spawn_enemy_007", Vector3(7750, 3975, -40), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "eclipse_spawn_enemy_008", Vector3(7850, 3925, -40), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "eclipse_spawn_enemy_009", Vector3(7900, 3875, -40), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "eclipse_spawn_enemy_010", Vector3(7850, 3825, -40), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400012, "eclipse_enemy_group_002", { 400007, 400008, 400009, 400010, 400011 }, 0),

	Eclipse.mission_elements.gen_preferedadd(400013, "eclipse_front_entrance", optsPreferedAdd),
}

return M
