---@module Santa's Workshop
local M = {}
local optsBesiegeDummy = {
	trigger_times = 0,
	participate_to_group_ai = true,
	enabled = true,
}
local optsPreferedAdd1 = {
	spawn_groups = { 400006, 400018, 400024, 400036 },
	enabled = true,
}
local optsPreferedAdd2 = {
	spawn_groups = { 400012, 400030 },
	enabled = true,
}
M.elements = {
	Eclipse.mission_elements.gen_dummy(400001, "eclipse_spawn_enemy_001", Vector3(8200, 350, -15), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "eclipse_spawn_enemy_002", Vector3(8300, 350, -15), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "eclipse_spawn_enemy_003", Vector3(8400, 350, -15), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "eclipse_spawn_enemy_004", Vector3(8200, 400, -15), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400005, "eclipse_spawn_enemy_005", Vector3(8300, 400, -15), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400006, "eclipse_enemy_group_001", { 400001, 400002, 400003, 400004, 400005 }, 0),

	Eclipse.mission_elements.gen_dummy(400007, "eclipse_spawn_enemy_006", Vector3(8300, 1550, 375), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400008, "eclipse_spawn_enemy_007", Vector3(8400, 1550, 375), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "eclipse_spawn_enemy_008", Vector3(8500, 1550, 375), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "eclipse_spawn_enemy_009", Vector3(8300, 1650, 375), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "eclipse_spawn_enemy_010", Vector3(8400, 1650, 375), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400012, "eclipse_enemy_group_002", { 400007, 400008, 400009, 400010, 400011 }, 0),

	Eclipse.mission_elements.gen_dummy(400013, "eclipse_spawn_enemy_011", Vector3(5400, 3800, -15), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400014, "eclipse_spawn_enemy_012", Vector3(5300, 3800, -15), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400015, "eclipse_spawn_enemy_013", Vector3(5200, 3800, -15), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400016, "eclipse_spawn_enemy_014", Vector3(5100, 3800, -15), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400017, "eclipse_spawn_enemy_015", Vector3(5000, 3800, -15), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400018, "eclipse_enemy_group_003", { 400013, 400014, 400015, 400016, 400017 }, 0),

	Eclipse.mission_elements.gen_dummy(400019, "eclipse_spawn_enemy_016", Vector3(7800, -3100, -15), Rotation(180, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400020, "eclipse_spawn_enemy_017", Vector3(7800, -3200, -15), Rotation(180, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400021, "eclipse_spawn_enemy_018", Vector3(7800, -3300, -15), Rotation(180, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400022, "eclipse_spawn_enemy_019", Vector3(7900, -3100, -15), Rotation(180, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400023, "eclipse_spawn_enemy_020", Vector3(7900, -3200, -15), Rotation(180, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400024, "eclipse_enemy_group_004", { 400019, 400020, 400021, 400022, 400023 }, 0),

	Eclipse.mission_elements.gen_dummy(400025, "eclipse_spawn_enemy_021", Vector3(7800, -2500, 390), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400026, "eclipse_spawn_enemy_022", Vector3(7800, -2400, 390), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400027, "eclipse_spawn_enemy_023", Vector3(7800, -2300, 390), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400028, "eclipse_spawn_enemy_024", Vector3(7900, -2500, 390), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400029, "eclipse_spawn_enemy_025", Vector3(7900, -2400, 390), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400030, "eclipse_enemy_group_005", { 400025, 400026, 400027, 400028, 400029 }, 0),

	Eclipse.mission_elements.gen_dummy(400031, "eclipse_spawn_enemy_026", Vector3(7800, 3850, -15), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400032, "eclipse_spawn_enemy_027", Vector3(7900, 3850, -15), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400033, "eclipse_spawn_enemy_028", Vector3(8000, 3850, -15), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400034, "eclipse_spawn_enemy_029", Vector3(8100, 3850, -15), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400035, "eclipse_spawn_enemy_030", Vector3(8200, 3850, -15), Rotation(90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400036, "eclipse_enemy_group_006", { 400031, 400032, 400033, 400034, 400035 }, 0),

	Eclipse.mission_elements.gen_preferedadd(400037, "eclipse_front_entrance", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedadd(400038, "eclipse_front_buildings", optsPreferedAdd2),
}

return M
