---@module Hoxton Breakout Day 1
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local is_pro_job = Eclipse.utils.is_pro_job()
local cloaker_amount = 3
local cloaker_amount_random = overkill_and_above and 1 or 0

local light_harasser = { scripted_enemy.swat_1 }
local heavy_harasser = diff_i > 5 and { [scripted_enemy.heavy_swat_1] = 3, [scripted_enemy.elite_sniper] = 1 } or { scripted_enemy.heavy_swat_1 }

local harasser = diff_i >= 5 and heavy_harasser or light_harasser

local cloakers_in_the_garage_chance = is_eclipse and math.random() <= 1 or math.random() <= 0.4 + (is_pro_job and 0.2 or 0)
local ambush_cloaker_chance = math.random() <= 0.5
local dozer_van_chance = math.random() <= 0.8
local sniper_at_the_start_chance = math.random() <= 0.4

local optsCloaker_1 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400006, delay = 0 } },
	enabled = normal_and_above and cloakers_in_the_garage_chance,
}
local optsCloaker_2 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400007, delay = 0 } },
	enabled = normal_and_above and cloakers_in_the_garage_chance,
}
local optsCloaker_3 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400008, delay = 0 } },
	enabled = normal_and_above and cloakers_in_the_garage_chance,
}
local optsCloaker_4 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400009, delay = 0 } },
	enabled = normal_and_above and cloakers_in_the_garage_chance,
}
local optsCloaker_5 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400010, delay = 0 } },
	enabled = normal_and_above and cloakers_in_the_garage_chance,
}
local optsCloaker_6 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400011, delay = 0 } },
	enabled = normal_and_above and cloakers_in_the_garage_chance,
}
local optsCloaker_Ambush = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400039, delay = 0 } },
	enabled = normal_and_above and ambush_cloaker_chance,
}
local optsDozerVan = {
	enemy = is_eclipse_pro and scripted_enemy.elite_bulldozer_1 or scripted_enemy.bulldozer_1,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400031, delay = 0 } },
	enabled = true,
}
local optsSniper_1 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400015, delay = 0 },
	},
	enabled = true,
}
local optsSniper_2 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400016, delay = 0 },
	},
	enabled = enabled_chance_sniper_start,
	trigger_times = 1,
}
local optsSWAT_Harasser_1 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 102003, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_Harasser_2 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 102002, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_Harasser_3 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 102001, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_Harasser_4 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 102004, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_Harasser_5 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 102007, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_Harasser_6 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 102006, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_Harasser_7 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 102008, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_Harasser_8 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 102005, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_Harasser_9 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 101996, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_Harasser_10 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 101994, delay = 0 },
	},
	enabled = true,
}
local optsSWAT_Harasser_11 = {
	enemy_table = harasser,
	on_executed = {
		{ id = 101992, delay = 0 },
	},
	enabled = true,
}
local optsSniper_SO = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsDozerHunt = {
	SO_access = "4096",
	path_style = "none",
	scan = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_hunt",
}
local optsCloaker_Hide_SO_1 = {
	SO_access = "1024",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interrupt_dis = 7,
	interrupt_dmg = 0,
	interval = 2,
	so_action = "e_so_sneak_wait_crh_var3",
}
local optsCloaker_Hide_SO_2 = {
	SO_access = "1024",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interrupt_dis = 7,
	interrupt_dmg = 0,
	interval = 2,
	so_action = "e_so_hide_under_car_enter",
}
local optsCloaker_Hide_SO_3 = {
	SO_access = "1024",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interrupt_dis = 7,
	interrupt_dmg = 0,
	interval = 2,
	so_action = "e_so_sneak_wait_crh",
}
local optsCloaker_Hide_SO_Ambush = {
	SO_access = "1024",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "e_so_idle_by_container",
}
local optsOpenSwatVanDoors = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101023, notify_unit_sequence = "door_open_left_back", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 101023, notify_unit_sequence = "door_open_right_back", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100479, notify_unit_sequence = "door_open_left_back", time = 0 },
		{ id = 4, name = "run_sequence", notify_unit_id = 100479, notify_unit_sequence = "door_open_right_back", time = 0 },
	},
	on_executed = {
		{ id = 400028, delay = 0 },
		{ id = 400029, delay = 0 },
	},
}
local optsSpawnVanDozers = {
	on_executed = {
		{ id = 400030, delay = 0 },
	},
	enabled = overkill_and_above and dozer_van_chance,
	trigger_times = 1,
}
local optsSpawnHarassers_1 = {
	on_executed = {
		{ id = 400017, delay = 0 },
		{ id = 400018, delay = 0 },
	},
	enabled = true,
	trigger_times = 1,
}
local optsSpawnHarassers_2 = {
	on_executed = {
		{ id = 400019, delay = 0 },
		{ id = 400020, delay = 0 },
	},
	enabled = true,
	trigger_times = 1,
}
local optsSpawnHarassers_3 = {
	on_executed = {
		{ id = 400021, delay = 0 },
		{ id = 400022, delay = 0 },
	},
	enabled = true,
	trigger_times = 1,
}
local optsSpawnHarassers_4 = {
	on_executed = {
		{ id = 400023, delay = 0 },
		{ id = 400024, delay = 0 },
	},
	enabled = true,
	trigger_times = 1,
}
local optsSpawnHarassers_5 = {
	on_executed = {
		{ id = 400025, delay = 0 },
		{ id = 400026, delay = 0 },
		{ id = 400027, delay = 0 },
	},
	enabled = true,
	trigger_times = 1,
}
local spawn_random_cloakers = {
	amount = cloaker_amount,
	amount_random = cloaker_amount_random,
	on_executed = {
		{ id = 400000, delay = 0 },
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
		{ id = 400003, delay = 0 },
		{ id = 400004, delay = 0 },
		{ id = 400005, delay = 0 },
	},
}

M.elements = {
	-- Cloakers in the garage
	Eclipse.mission_elements.gen_dummy(400000, "garage_spooc_1", Vector3(8467, 5939, -2400), Rotation(-90, 0, 0), optsCloaker_1),
	Eclipse.mission_elements.gen_dummy(400001, "garage_spooc_2", Vector3(11876, 6918, -1992.450), Rotation(0, 0, 0), optsCloaker_2),
	Eclipse.mission_elements.gen_dummy(400002, "garage_spooc_3", Vector3(11544, 5074, -2800), Rotation(-90, 0, 0), optsCloaker_3),
	Eclipse.mission_elements.gen_dummy(400003, "garage_spooc_4", Vector3(12247, 5204, -2400), Rotation(-68, 0, 0), optsCloaker_4),
	Eclipse.mission_elements.gen_dummy(400004, "garage_spooc_5", Vector3(10769, 7915, -2578.823), Rotation(-90, 0, 0), optsCloaker_5),
	Eclipse.mission_elements.gen_dummy(400005, "garage_spooc_6", Vector3(9069, 6929, -2800), Rotation(0, 0, 0), optsCloaker_6),
	Eclipse.mission_elements.gen_so(400006, "spooc_hide_so_1", Vector3(8494, 5938, -2400), Rotation(-90, 0, 0), optsCloaker_Hide_SO_1),
	Eclipse.mission_elements.gen_so(400007, "spooc_hide_so_2", Vector3(11874, 6997, -2000.458), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400008, "spooc_hide_so_3", Vector3(11602, 5075, -2800), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400009, "spooc_hide_so_4", Vector3(12201, 5165, -2400), Rotation(-52, 0, 0), optsCloaker_Hide_SO_3),
	Eclipse.mission_elements.gen_so(400010, "spooc_hide_so_5", Vector3(10851.183, 7925.074, -2563.219), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400011, "spooc_hide_so_6", Vector3(9075, 7099, -2800), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),

	Eclipse.mission_elements.gen_element_random(400012, "cloaker_ambush_event", spawn_random_cloakers),

	-- suprise cloaker at the start of the heist (so evil)
	Eclipse.mission_elements.gen_dummy(400038, "spooc_ambush_1", Vector3(-7290, -8797, -2000), Rotation(-85, 0, 0), optsCloaker_Ambush),
	Eclipse.mission_elements.gen_so(400039, "spooc_ambush_hide_so_1", Vector3(-7229.177, -8819.247, -2000), Rotation(-66, 0, 0), optsCloaker_Hide_SO_Ambush),

	-- Snipers and Harassers
	Eclipse.mission_elements.gen_dummy(400013, "sniper_1", Vector3(1858, -7442, -1598.273), Rotation(0, 0, 0), optsSniper_1),
	Eclipse.mission_elements.gen_dummy(400014, "sniper_2", Vector3(-3496, -5789, -1999.987), Rotation(133, 0, 0), optsSniper_2),
	Eclipse.mission_elements.gen_so(400015, "sniper_so_1", Vector3(1697, -6645, -1598.273), Rotation(90, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400016, "sniper_so_2", Vector3(-3536, -5825, -1999.965), Rotation(122, 0, 0), optsSniper_SO),
	-- Harassers
	Eclipse.mission_elements.gen_dummy(400017, "harasser_1", Vector3(2132, 4211, -1205.630), Rotation(-180, 0, 0), optsSWAT_Harasser_1),
	Eclipse.mission_elements.gen_dummy(400018, "harasser_2", Vector3(2127, 4130, -1205.630), Rotation(-180, 0, 0), optsSWAT_Harasser_2),
	Eclipse.mission_elements.gen_dummy(400019, "harasser_3", Vector3(1899, 1954, -1205.630), Rotation(0, 0, 0), optsSWAT_Harasser_3),
	Eclipse.mission_elements.gen_dummy(400020, "harasser_4", Vector3(1877, 2019, -1205.630), Rotation(0, 0, 0), optsSWAT_Harasser_4),
	Eclipse.mission_elements.gen_dummy(400021, "harasser_5", Vector3(3870, 1962, -1205.828), Rotation(0, 0, 0), optsSWAT_Harasser_5),
	Eclipse.mission_elements.gen_dummy(400022, "harasser_6", Vector3(3870, 2046, -1205.828), Rotation(0, 0, 0), optsSWAT_Harasser_6),
	Eclipse.mission_elements.gen_dummy(400023, "harasser_7", Vector3(4092, 2042, -1205.828), Rotation(0, 0, 0), optsSWAT_Harasser_7),
	Eclipse.mission_elements.gen_dummy(400024, "harasser_8", Vector3(4014, 2020, -1205.828), Rotation(0, 0, 0), optsSWAT_Harasser_8),
	Eclipse.mission_elements.gen_dummy(400025, "harasser_9", Vector3(2407, -182, -1200), Rotation(-180, 0, 0), optsSWAT_Harasser_9),
	Eclipse.mission_elements.gen_dummy(400026, "harasser_10", Vector3(2908, -182, -1200), Rotation(-180, 0, 0), optsSWAT_Harasser_10),
	Eclipse.mission_elements.gen_dummy(400027, "harasser_11", Vector3(3520, -182, -1200), Rotation(-180, 0, 0), optsSWAT_Harasser_11),

	Eclipse.mission_elements.gen_missionscript(400033, "spawn_harassers_1", optsSpawnHarassers_1),
	Eclipse.mission_elements.gen_missionscript(400034, "spawn_harassers_2", optsSpawnHarassers_2),
	Eclipse.mission_elements.gen_missionscript(400035, "spawn_harassers_3", optsSpawnHarassers_3),
	Eclipse.mission_elements.gen_missionscript(400036, "spawn_harassers_4", optsSpawnHarassers_4),
	Eclipse.mission_elements.gen_missionscript(400037, "spawn_harassers_5", optsSpawnHarassers_5),

	-- Dozers coming out of the vans near parking garage entrance
	Eclipse.mission_elements.gen_dummy(400028, "bulldozer_1", Vector3(5345, 5625, -2020), Rotation(48, 0, 0), optsDozerVan),
	Eclipse.mission_elements.gen_dummy(400029, "bulldozer_2", Vector3(5255.336, 5525.419, -2020), Rotation(-14, 0, 0), optsDozerVan),

	Eclipse.mission_elements.gen_object_editor(400030, "open_swat_doors", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors),
	Eclipse.mission_elements.gen_so(400031, "dozer_hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDozerHunt),
	Eclipse.mission_elements.gen_missionscript(400032, "spawn_bulldozers", optsSpawnVanDozers),
}
return M
