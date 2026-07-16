---@module Birth Of Sky
local M = {}

local is_pro_job = Eclipse.utils.is_pro_job()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local scripted_enemy = Eclipse.scripted_enemy

local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2

local swats = { [swat_1] = 2, [swat_2] = 1 }

local random_dozers = {
	scripted_enemy.bulldozer_1,
	scripted_enemy.bulldozer_2,
}
local random_elite_dozers = {
	scripted_enemy.elite_bulldozer_1,
	scripted_enemy.elite_bulldozer_2,
}

local optsSWATEnemy_Van = {
	enemy_table = swats,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsDozerEnemy_Van = {
	enemy_table = is_eclipse_pro and random_elite_dozers or random_dozers,
	spawn_action = "e_sp_armored_truck_3rd",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsCloakerEnemy_Van = {
	enemy = scripted_enemy.cloaker,
	spawn_action = "e_sp_clk_over_2_5m",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsTaserEnemy_Van = {
	enemy = scripted_enemy.taser_1,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}

local optsHuntSO = {
	SO_access = tostring(128 + 1024 + 4096 + 8192),
	path_style = "none",
	scan = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_hunt",
}

local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100397, notify_unit_sequence = "anim_door_top_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100397, notify_unit_sequence = "anim_doors_rear_open", time = 2 },
	},
	on_executed = {
		{ id = 400005, delay = 0 },
		{ id = 400006, delay = 2 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100417, notify_unit_sequence = "anim_door_top_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100417, notify_unit_sequence = "anim_doors_rear_open", time = 2 },
	},
	on_executed = {
		{ id = 400015, delay = 0 },
		{ id = 400016, delay = 2 },
	},
}
local optsOpenSwatVanDoors_Trigger_1 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_car_anim", unit_id = 100397 },
	},
	on_executed = {
		{ id = 400007, delay = 0, delay_rand = 5 },
	},
}
local optsOpenSwatVanDoors_Trigger_2 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_car_anim", unit_id = 100417 },
	},
	on_executed = {
		{ id = 400017, delay = 0, delay_rand = 5 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400003, delay = 0 },
		{ id = 400004, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_3 = {
	on_executed = {
		{ id = 400009, delay = 0 },
		{ id = 400010, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_4 = {
	on_executed = {
		{ id = 400011, delay = 0 },
		{ id = 400012, delay = 0 },
		{ id = 400013, delay = 0 },
		{ id = 400014, delay = 0 },
	},
	enabled = true,
}

M.elements = {
	-- swat van 1
	Eclipse.mission_elements.gen_dummy(400001, "cloaker_van_spawn_1", Vector3(-58, 3692, 7.500), Rotation(-90, 0, 0), optsCloakerEnemy_Van),
	Eclipse.mission_elements.gen_dummy(400002, "cloaker_van_spawn_2", Vector3(-489, 3692, 7.500), Rotation(90, 0, 0), optsCloakerEnemy_Van),
	Eclipse.mission_elements.gen_dummy(400003, "bulldozer_van_spawn_1", Vector3(-240.620, 4141.241, 6), Rotation(-13, 0, 0), optsDozerEnemy_Van),
	Eclipse.mission_elements.gen_dummy(400004, "bulldozer_van_spawn_2", Vector3(-183.132, 4127.949, 6), Rotation(-13, 0, 0), optsDozerEnemy_Van),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_cloakers_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_missionscript(400006, "spawn_dozers_1", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400007, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_object_editor_trigger(400008, "swat_van_doors_trigger_1", optsOpenSwatVanDoors_Trigger_1),

	-- swat van 2
	Eclipse.mission_elements.gen_dummy(400009, "cloaker_van_spawn_3", Vector3(69, -2835, 7.500), Rotation(90, 0, 0), optsCloakerEnemy_Van),
	Eclipse.mission_elements.gen_dummy(400010, "cloaker_van_spawn_4", Vector3(495, -2835, 7.500), Rotation(-90, 0, 0), optsCloakerEnemy_Van),
	Eclipse.mission_elements.gen_dummy(400011, "taser_van_spawn_1", Vector3(227, -3193, 7.500), Rotation(-180, 0, 0), optsTaserEnemy_Van),
	Eclipse.mission_elements.gen_dummy(400012, "swat_van_spawn_1", Vector3(298, -3193, 7.500), Rotation(-180, 0, 0), optsSWATEnemy_Van),
	Eclipse.mission_elements.gen_dummy(400013, "swat_van_spawn_2", Vector3(298, -3246, 7.500), Rotation(-180, 0, 0), optsSWATEnemy_Van),
	Eclipse.mission_elements.gen_dummy(400014, "swat_van_spawn_3", Vector3(224, -3246, 7.500), Rotation(-180, 0, 0), optsSWATEnemy_Van),
	Eclipse.mission_elements.gen_missionscript(400015, "spawn_cloakers_2", optsspawnvanSWATs_3),
	Eclipse.mission_elements.gen_missionscript(400016, "spawn_swats_1", optsspawnvanSWATs_4),
	Eclipse.mission_elements.gen_object_editor(400017, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_2),
	Eclipse.mission_elements.gen_object_editor_trigger(400018, "swat_van_doors_trigger_2", optsOpenSwatVanDoors_Trigger_2),

	Eclipse.mission_elements.gen_so(400019, "hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsHuntSO),
}

return M
