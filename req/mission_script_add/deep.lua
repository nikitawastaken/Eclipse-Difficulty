---@module Crude Awakening
local M = {}

local optsBesiegeDummy = {
	trigger_times = 0,
	participate_to_group_ai = true,
	spawn_action = "e_sp_climb_up_3m_down_1m",
	enabled = true,
}
local optsDifficultyAddend01 = {
	trigger_times = 1,
	difficulty_addends = {
		{
			amount = 1 / 3,
			delay = 0,
			time = 90,
			time_balance_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	enabled = true,
}

M.elements = {
	Eclipse.mission_elements.gen_dummy(400001, "eclipse_spawn_enemy_001", Vector3(-2425, -3250, 4900), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "eclipse_spawn_enemy_002", Vector3(-2225, -3250, 4900), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "eclipse_spawn_enemy_003", Vector3(-2025, -3250, 4900), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "eclipse_spawn_enemy_004", Vector3(-1825, -3250, 4900), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400005, "eclipse_spawn_enemy_005", Vector3(-1625, -3250, 4900), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400006, "deep_pipe_puzzle_enemy_group_01", { 400001, 400002, 400003, 400004, 400005 }, 0),

	Eclipse.mission_elements.gen_dummy(400007, "eclipse_spawn_enemy_006", Vector3(-200, -3200, 4900), Rotation(45, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400008, "eclipse_spawn_enemy_007", Vector3(-75, -3075, 4900), Rotation(45, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "eclipse_spawn_enemy_008", Vector3(50, -2950, 4900), Rotation(45, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "eclipse_spawn_enemy_009", Vector3(175, -2825, 4900), Rotation(45, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "eclipse_spawn_enemy_010", Vector3(300, -2700, 4900), Rotation(45, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400012, "deep_pipe_puzzle_enemy_group_02", { 400007, 400008, 400009, 400010, 400011 }, 0),

	Eclipse.mission_elements.gen_difficulty(400013, "deep_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400014, "deep_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
}

return M
