---@module Heat Street
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
}

return M
