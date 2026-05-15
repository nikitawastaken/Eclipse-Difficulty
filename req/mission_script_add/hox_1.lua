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
	trigger_times = 1,
	enabled = true,
}
local optsSniper_2 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400016, delay = 0 },
	},
	enabled = enabled_chance_sniper_start,
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
		{ id = 400086, delay = 0 },
		{ id = 400087, delay = 0.5 },
		{ id = 400088, delay = 1 },
		{ id = 400089, delay = 1.5 },
		{ id = 400090, delay = 2 },
		{ id = 400091, delay = 2.5 },
	},
}
local optsSpawnVanDozers = {
	on_executed = {
		{ id = 400030, delay = 0 },
	},
	enabled = overkill_and_above and dozer_van_chance,
	trigger_times = 1,
}
local Smoke_bomb_dozer_van = {
	duration = 20,
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

local optsBesiegeDummy_Heli_1 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_dwn_17m_var2",
}

local optsBesiegeDummy_Heli_2 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_dwn_10m",
}

local optsBesiegeDummy_Heli_3 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_dwn_5m",
}

local optsBesiegeDummy_Heli_4 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_dwn_11m_var2",
}

local optsSWATChopper_intro_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "flyin_fwd_hover", time = 0 },
	},
	on_executed = {
		{ id = 400046, delay = 24 },
		{ id = 400081, delay = 0 },
	},
}

local optsSWATChopper_deploy_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "open_door_left", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "open_door_right", time = 0 },
	},
	on_executed = {
		{ id = 400082, delay = 3 },
		{ id = 400050, delay = 4 },
		{ id = 400047, delay = 12 },
	},
}

local optsSWATChopper_leave_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "close_door_left", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "close_door_right", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "hover_flyout_back", time = 0 },
	},
	on_executed = {
		{ id = 400048, delay = 18 },
	},
}

local optsSWATChopper_hide_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "hidden", time = 0 },
	},
}

local optsSWATChopper_intro_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100001, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100001, notify_unit_sequence = "flyin_fwd_hover", time = 0 },
	},
	on_executed = {
		{ id = 400056, delay = 24 },
		{ id = 400081, delay = 0 },
	},
}

local optsSWATChopper_deploy_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100001, notify_unit_sequence = "open_door_left", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100001, notify_unit_sequence = "open_door_right", time = 0 },
	},
	on_executed = {
		{ id = 400083, delay = 3 },
		{ id = 400060, delay = 4 },
		{ id = 400057, delay = 12 },
	},
}

local optsSWATChopper_leave_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100001, notify_unit_sequence = "close_door_left", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100001, notify_unit_sequence = "close_door_right", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100001, notify_unit_sequence = "hover_flyout_back", time = 0 },
	},
	on_executed = {
		{ id = 400058, delay = 18 },
	},
}

local optsSWATChopper_hide_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100001, notify_unit_sequence = "hidden", time = 0 },
	},
}

local optsSWATChopper_intro_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "flyin_fwd_hover", time = 0 },
	},
	on_executed = {
		{ id = 400066, delay = 20 },
		{ id = 400081, delay = 0 },
	},
}

local optsSWATChopper_deploy_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "hover_land", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "open_door_left", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "open_door_right", time = 0 },
	},
	on_executed = {
		{ id = 400085, delay = 9 },
		{ id = 400070, delay = 10 },
		{ id = 400067, delay = 15 },
	},
}

local optsSWATChopper_leave_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "takeoff_hover", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "close_door_left", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "close_door_right", time = 0 },
		{ id = 4, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "hover_flyout_back", time = 7 },
	},
	on_executed = {
		{ id = 400068, delay = 25 },
	},
}

local optsSWATChopper_hide_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "hidden", time = 0 },
	},
}

local optsSWATChopper_intro_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100003, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100003, notify_unit_sequence = "heli_street_fourth_flyin", time = 0 },
	},
	on_executed = {
		{ id = 400076, delay = 15 },
		{ id = 400081, delay = 0 },
	},
}

local optsSWATChopper_deploy_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100003, notify_unit_sequence = "hover_land", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100003, notify_unit_sequence = "open_door_left", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100003, notify_unit_sequence = "open_door_right", time = 0 },
	},
	on_executed = {
		{ id = 400084, delay = 9 },
		{ id = 400080, delay = 10 },
		{ id = 400077, delay = 15 },
	},
}

local optsSWATChopper_leave_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100003, notify_unit_sequence = "takeoff_hover", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100003, notify_unit_sequence = "close_door_left", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100003, notify_unit_sequence = "close_door_right", time = 0 },
		{ id = 4, name = "run_sequence", notify_unit_id = 100003, notify_unit_sequence = "hover_flyout_back", time = 7 },
	},
	on_executed = {
		{ id = 400078, delay = 18 },
	},
}

local optsSWATChopper_hide_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "hidden", time = 0 },
	},
}

local optsSWATChopper_hide_startup = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "hidden", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100001, notify_unit_sequence = "hidden", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100002, notify_unit_sequence = "hidden", time = 0 },
		{ id = 4, name = "run_sequence", notify_unit_id = 100003, notify_unit_sequence = "hidden", time = 0 },
	},
}

local optsspawnswatchopper_1 = {
	on_executed = {
		{ id = 400045, delay = 0 },
	},
	trigger_times = 1,
	enabled = true,
}

local optsspawnswatchopper_2 = {
	on_executed = {
		{ id = 400055, delay = 0 },
	},
	trigger_times = 1,
	enabled = true,
}

local optsspawnswatchopper_3 = {
	on_executed = {
		{ id = 400065, delay = 0 },
	},
	trigger_times = 1,
	enabled = true,
}

local optsspawnswatchopper_4 = {
	on_executed = {
		{ id = 400075, delay = 0 },
	},
	trigger_times = 1,
	enabled = true,
}

local Smoke_bomb_heli = {
	duration = 7,
}

local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

local Bain_chopperinbound = {
	dialogue = "Play_pln_heli_01",
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
	Eclipse.mission_elements.gen_smokegrenade(400086, "smoke_grenade_dozer_1", Vector3(4744, 4454, -2000), Rotation(0, 0, 0), Smoke_bomb_dozer_van),
	Eclipse.mission_elements.gen_smokegrenade(400087, "smoke_grenade_dozer_2", Vector3(5013, 4457, -2020), Rotation(0, 0, 0), Smoke_bomb_dozer_van),
	Eclipse.mission_elements.gen_smokegrenade(400088, "smoke_grenade_dozer_3", Vector3(5303, 4443, -2020), Rotation(0, 0, 0), Smoke_bomb_dozer_van),
	Eclipse.mission_elements.gen_smokegrenade(400089, "smoke_grenade_dozer_4", Vector3(5543, 4458, -2020), Rotation(0, 0, 0), Smoke_bomb_dozer_van),
	Eclipse.mission_elements.gen_smokegrenade(400090, "smoke_grenade_dozer_5", Vector3(5799, 4491, -2020), Rotation(0, 0, 0), Smoke_bomb_dozer_van),
	Eclipse.mission_elements.gen_smokegrenade(400091, "smoke_grenade_dozer_5", Vector3(5953, 4468, -2020), Rotation(0, 0, 0), Smoke_bomb_dozer_van),
	Eclipse.mission_elements.gen_so(400031, "dozer_hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDozerHunt),
	Eclipse.mission_elements.gen_missionscript(400032, "spawn_bulldozers", optsSpawnVanDozers),

	-- SWAT choppers
	Eclipse.mission_elements.gen_object_editor(400040, "swat_heli_sequence_startup", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_hide_startup),
	-- chopper 1
	Eclipse.mission_elements.gen_dummy(400041, "swat_heli_1", Vector3(5644.503, -1639.059, -2020), Rotation(29, 0, 0), optsBesiegeDummy_Heli_1),
	Eclipse.mission_elements.gen_dummy(400042, "swat_heli_2", Vector3(5647.503, -1748.731, -2020), Rotation(29, 0, 0), optsBesiegeDummy_Heli_1),
	Eclipse.mission_elements.gen_dummy(400043, "swat_heli_3", Vector3(5250.301, -1880.321, -2020), Rotation(-128, 0, 0), optsBesiegeDummy_Heli_1),
	Eclipse.mission_elements.gen_dummy(400044, "swat_heli_4", Vector3(5253.875, -1770.170, -2020), Rotation(-128, 0, 0), optsBesiegeDummy_Heli_1),
	Eclipse.mission_elements.gen_object_editor(400045, "swat_heli_sequence_intro_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_intro_1),
	Eclipse.mission_elements.gen_object_editor(400046, "swat_heli_sequence_deploy_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_deploy_1),
	Eclipse.mission_elements.gen_object_editor(400047, "swat_heli_sequence_leave_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_leave_1),
	Eclipse.mission_elements.gen_object_editor(400048, "swat_heli_sequence_hide_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_hide_1),
	Eclipse.mission_elements.gen_missionscript(400049, "swat_heli_event_1", optsspawnswatchopper_1),
	Eclipse.mission_elements.gen_spawngroup(400050, "swat_group_1", { 400041, 400042, 400043, 400044 }, 0, opts_swat_group),
	-- chopper 2
	Eclipse.mission_elements.gen_dummy(400051, "swat_heli_5", Vector3(5260.504, 3075.309, -2020), Rotation(-90, 0, 0), optsBesiegeDummy_Heli_4),
	Eclipse.mission_elements.gen_dummy(400052, "swat_heli_6", Vector3(5256.214, 3157.197, -2020), Rotation(-90, 0, 0), optsBesiegeDummy_Heli_4),
	Eclipse.mission_elements.gen_dummy(400053, "swat_heli_7", Vector3(5607.504, 3025.909, -2020), Rotation(90, 0, 0), optsBesiegeDummy_Heli_4),
	Eclipse.mission_elements.gen_dummy(400054, "swat_heli_8", Vector3(5607.504, 3115.309, -2020), Rotation(90, 0, 0), optsBesiegeDummy_Heli_4),
	Eclipse.mission_elements.gen_object_editor(400055, "swat_heli_sequence_intro_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_intro_2),
	Eclipse.mission_elements.gen_object_editor(400056, "swat_heli_sequence_deploy_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_deploy_2),
	Eclipse.mission_elements.gen_object_editor(400057, "swat_heli_sequence_leave_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_leave_2),
	Eclipse.mission_elements.gen_object_editor(400058, "swat_heli_sequence_hide_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_hide_2),
	Eclipse.mission_elements.gen_missionscript(400059, "swat_heli_event_2", optsspawnswatchopper_2),
	Eclipse.mission_elements.gen_spawngroup(400060, "swat_group_4", { 400051, 400052, 400053, 400054 }, 0, opts_swat_group),
	-- chopper 3
	Eclipse.mission_elements.gen_dummy(400061, "swat_heli_9", Vector3(729, 3407, -2020), Rotation(90, 0, 0), optsBesiegeDummy_Heli_2),
	Eclipse.mission_elements.gen_dummy(400062, "swat_heli_10", Vector3(729, 3488, -2020), Rotation(90, 0, 0), optsBesiegeDummy_Heli_2),
	Eclipse.mission_elements.gen_dummy(400063, "swat_heli_11", Vector3(478, 3452, -2020), Rotation(-90, 0, 0), optsBesiegeDummy_Heli_2),
	Eclipse.mission_elements.gen_dummy(400064, "swat_heli_12", Vector3(478, 3525, -2020), Rotation(-90, 0, 0), optsBesiegeDummy_Heli_2),
	Eclipse.mission_elements.gen_object_editor(400065, "swat_heli_sequence_intro_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_intro_3),
	Eclipse.mission_elements.gen_object_editor(400066, "swat_heli_sequence_deploy_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_deploy_3),
	Eclipse.mission_elements.gen_object_editor(400067, "swat_heli_sequence_leave_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_leave_3),
	Eclipse.mission_elements.gen_object_editor(400068, "swat_heli_sequence_hide_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_hide_3),
	Eclipse.mission_elements.gen_missionscript(400069, "swat_heli_event_3", optsspawnswatchopper_3),
	Eclipse.mission_elements.gen_spawngroup(400070, "swat_group_3", { 400061, 400062, 400063, 400064 }, 0, opts_swat_group),
	-- chopper 4
	Eclipse.mission_elements.gen_dummy(400071, "swat_heli_13", Vector3(-4337.613, -1439.170, -2020), Rotation(-90, 0, 0), optsBesiegeDummy_Heli_3),
	Eclipse.mission_elements.gen_dummy(400072, "swat_heli_14", Vector3(-4337.613, -1364.170, -2020), Rotation(-90, 0, 0), optsBesiegeDummy_Heli_3),
	Eclipse.mission_elements.gen_dummy(400073, "swat_heli_15", Vector3(-4045.541, -1423.082, -2020), Rotation(90, 0, 0), optsBesiegeDummy_Heli_3),
	Eclipse.mission_elements.gen_dummy(400074, "swat_heli_16", Vector3(-4046.658, -1359.061, -2020), Rotation(90, 0, 0), optsBesiegeDummy_Heli_3),
	Eclipse.mission_elements.gen_object_editor(400075, "swat_heli_sequence_intro_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_intro_4),
	Eclipse.mission_elements.gen_object_editor(400076, "swat_heli_sequence_deploy_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_deploy_4),
	Eclipse.mission_elements.gen_object_editor(400077, "swat_heli_sequence_leave_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_leave_4),
	Eclipse.mission_elements.gen_object_editor(400078, "swat_heli_sequence_hide_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_hide_4),
	Eclipse.mission_elements.gen_missionscript(400079, "swat_heli_event_4", optsspawnswatchopper_4),
	Eclipse.mission_elements.gen_spawngroup(400080, "swat_group_4", { 400071, 400072, 400073, 400074 }, 0, opts_swat_group),

	Eclipse.mission_elements.gen_dialogue(400081, "chopper_inbound", Bain_chopperinbound),

	Eclipse.mission_elements.gen_smokegrenade(400082, "smoke_grenade_heli_1", Vector3(5440, -1750, -2020), Rotation(0, 0, 0), Smoke_bomb_heli),
	Eclipse.mission_elements.gen_smokegrenade(400083, "smoke_grenade_heli_2", Vector3(5455, 3098, -2020), Rotation(0, 0, 0), Smoke_bomb_heli),
	Eclipse.mission_elements.gen_smokegrenade(400084, "smoke_grenade_heli_3", Vector3(-4200, -1396, -2020), Rotation(0, 0, 0), Smoke_bomb_heli),
	Eclipse.mission_elements.gen_smokegrenade(400085, "smoke_grenade_heli_4", Vector3(543, 3475, -2020), Rotation(0, 0, 0), Smoke_bomb_heli),
}
return M
