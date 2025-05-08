---@module Framing Frame Day 2
local M = {}

local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy
local enabled_chance_dozer = math.random() < 0.45

local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local shield = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield
local taser = scripted_enemy.taser_1
local black_bulldozer = scripted_enemy.bulldozer_2

local swats = { [swat_1] = 2, [swat_2] = 1 }

local optsBulldozer = {
	enemy = black_bulldozer,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400002, delay = 0 } },
	enabled = overkill_and_above and enabled_chance_dozer,
}
local optsSWAT = {
	enemy_table = swats,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400009, delay = 0 } },
	enabled = true,
}
local optsTaser = {
	enemy = taser,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400009, delay = 0 } },
	enabled = true,
}
local optsShield = {
	enemy = shield,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400009, delay = 0 } },
	enabled = true,
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102776, notify_unit_sequence = "open", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102777, notify_unit_sequence = "open", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = { { id = 400003, delay = 0 }, { id = 400004, delay = 0 }, { id = 400005, delay = 0 }, { id = 400006, delay = 0 }, { id = 400007, delay = 0 }, { id = 400009, delay = 0 } },
	enabled = true,
}
local optsHuntSO = {
	SO_access = tostring(128 + 2048 + 4096 + 8192),
	path_style = "none",
	scan = true,
	so_action = "AI_hunt",
}

M.elements = {
	-- blackdozer
	Eclipse.mission_elements.gen_dummy(400001, "van_dozer", Vector3(7287, -3953, -39.280), Rotation(-90, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_object_editor(400002, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),

	-- swat van
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_1", Vector3(6330, 990, -39.280), Rotation(0, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_2", Vector3(6592, 990, -39.280), Rotation(0, 0, 0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400005, "swat_van_spawn_3", Vector3(6554, 990, -39.280), Rotation(0, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400006, "swat_van_spawn_4", Vector3(6627, 1042, -39.280), Rotation(0, 0, 0), optsShield),
	Eclipse.mission_elements.gen_dummy(400007, "swat_van_spawn_5", Vector3(6554, 1042, -39.280), Rotation(0, 0, 0), optsShield),
	Eclipse.mission_elements.gen_missionscript(400008, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400009, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_2),

	Eclipse.mission_elements.gen_so(400010, "hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsHuntSO),
}

return M
