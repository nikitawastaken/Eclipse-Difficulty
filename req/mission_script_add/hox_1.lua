---@module Hoxton Breakout Day 1
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local is_pro_job = Eclipse.utils.is_pro_job()
local cloaker_garage_amount = 3
local cloaker_garage_amount_random = overkill_and_above and 1 or 0
local cloaker_convoy_amount = is_eclipse and 2 or 1
local cloaker_convoy_amount_random = diff_i <= 5 and 1 or 0

local light_harasser = { scripted_enemy.swat_1 }
local heavy_harasser = diff_i > 5 and { [scripted_enemy.heavy_swat_1] = 3, [scripted_enemy.elite_sniper] = 1 } or { scripted_enemy.heavy_swat_1 }

local harasser = diff_i >= 5 and heavy_harasser or light_harasser

local swats_blockade = {
	[scripted_enemy.heavy_swat_1] = get_difficulty_group_specific_value({ 3, 5, 7 }),
	[scripted_enemy.heavy_swat_2] = get_difficulty_group_specific_value({ 2, 3, 4 }),
	[scripted_enemy.swat_1] = 5,
	[scripted_enemy.swat_2] = 3,
}

local cloakers_in_the_garage_chance = is_eclipse and math.random() <= 1 or math.random() <= 0.4 + (is_pro_job and 0.2 or 0)
local ambush_cloaker_chance = math.random() <= 0.5
local dozer_van_chance = math.random() <= 0.8
local sniper_at_the_start_chance = math.random() <= 0.4
local garage_dozer_chance = math.random() <= 0.2 + (is_pro_job and 0.2 or 0)

local hiding_convoy_cloakers_near_car_shop = is_eclipse and math.random() <= 0.75 or math.random() <= 0.45
local hiding_cloaker_in_a_car_shop = is_eclipse and math.random() <= 0.75 or math.random() <= 0.45
local hiding_convoy_cloakers_near_parking_garage_left_side = is_eclipse and math.random() <= 0.75 or math.random() <= 0.45
local hiding_convoy_cloakers_near_parking_garage_right_side = is_eclipse and math.random() <= 0.75 or math.random() <= 0.45
local hiding_convoy_cloakers_near_crossroad = is_eclipse and math.random() <= 0.75 or math.random() <= 0.45

-- BEGINNING OF THE HEIST
local optsPrison_Guard_1 = {
	enemy = scripted_enemy.prison_security_1,
	spawn_action = "e_sp_crh_to_std_rifle",
	on_executed = {
		{ id = 400106, delay = 0 },
	},
	enabled = true,
}
local optsPrison_Guard_2 = {
	enemy = scripted_enemy.prison_security_1,
	spawn_action = "e_sp_crh_to_std_rifle",
	on_executed = {
		{ id = 400107, delay = 0 },
	},
	enabled = true,
}
local optsPrison_Guard_3 = {
	enemy = scripted_enemy.prison_security_1,
	on_executed = {
		{ id = 400108, delay = 0 },
	},
	enabled = true,
}
local optsPrison_Guard_4 = {
	enemy = scripted_enemy.prison_security_2,
	on_executed = {
		{ id = 400109, delay = 0 },
	},
	enabled = true,
}
local optsPrison_Guard_5 = {
	enemy = scripted_enemy.prison_security_1,
	on_executed = {
		{ id = 400110, delay = 0 },
	},
	enabled = true,
}
local optsPrison_Guard_6 = {
	enemy = scripted_enemy.prison_security_1,
	on_executed = {
		{ id = 400111, delay = 0 },
	},
	enabled = true,
}
local optsCloaker_Ambush = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400039, delay = 0 } },
	enabled = normal_and_above and ambush_cloaker_chance,
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
local optsDefendGuard_SO = {
	SO_access = "32",
	scan = true,
	align_position = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_defend",
}

-- BULLDOZER AMBUSH
local optsDozerVan = {
	enemy = is_eclipse_pro and scripted_enemy.elite_bulldozer_1 or scripted_enemy.bulldozer_1,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400031, delay = 0 } },
	enabled = true,
}
local optsDozerHunt = {
	SO_access = "4096",
	path_style = "none",
	scan = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_hunt",
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

-- HIDING CLOAKERS (Garage)
local optsCloaker_1 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400006, delay = 0 } },
	enabled = true,
}
local optsCloaker_2 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400007, delay = 0 } },
	enabled = true,
}
local optsCloaker_3 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400008, delay = 0 } },
	enabled = true,
}
local optsCloaker_4 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400009, delay = 0 } },
	enabled = true,
}
local optsCloaker_5 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400010, delay = 0 } },
	enabled = true,
}
local optsCloaker_6 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400011, delay = 0 } },
	enabled = true,
}
local optsSpawnGarageCloakers = {
	on_executed = {
		{ id = 400012, delay = 0 },
	},
	enabled = normal_and_above and cloakers_in_the_garage_chance,
}
local spawn_random_cloakers = {
	amount = cloaker_garage_amount,
	amount_random = cloaker_garage_amount_random,
	on_executed = {
		{ id = 400000, delay = 0 },
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
		{ id = 400003, delay = 0 },
		{ id = 400004, delay = 0 },
		{ id = 400005, delay = 0 },
	},
}

-- HIDING CLOAKERS (Convoy)
-- Near Car Shop
local optsCloaker_Convoy_1 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400124, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_2 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400125, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_3 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400126, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_4 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400127, delay = 0 } },
	enabled = true,
}
local optsAreaTriggerPoint_1 = {
	enabled = true,
	width = 2700,
	depth = 100,
	height = 500,
	on_executed = {
		{ id = 400129, delay = 0 },
		{ id = 400170, delay = 0 },
	},
}
local optsSpawnConvoyCloakersCarShop = {
	on_executed = {
		{ id = 400130, delay = 0 },
	},
	enabled = normal_and_above and hiding_convoy_cloakers_near_car_shop,
}
local spawn_random_convoy_cloakers_car_shop = {
	amount = cloaker_convoy_amount,
	amount_random = cloaker_convoy_amount_random,
	on_executed = {
		{ id = 400120, delay = 0 },
		{ id = 400121, delay = 0 },
		{ id = 400122, delay = 0 },
		{ id = 400123, delay = 0 },
	},
}

local optsCloaker_Car_Shop_Ambush_1 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400171, delay = 0 } },
	enabled = true,
}
local optsSpawnAmbushCloakerinCarShop = {
	on_executed = {
		{ id = 400164, delay = 0 },
	},
	enabled = normal_and_above and hiding_cloaker_in_a_car_shop,
}
local choose_random_hiding_spot = {
	amount = 1,
	on_executed = {
		{ id = 400165, delay = 0 },
		{ id = 400166, delay = 0 },
		{ id = 400167, delay = 0 },
		{ id = 400168, delay = 0 },
		{ id = 400169, delay = 0 },
	},
}

-- Near Crossroad (Cross the Roads)
local optsCloaker_Convoy_5 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400135, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_6 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400136, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_7 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400137, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_8 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400138, delay = 0 } },
	enabled = true,
}
local optsAreaTriggerPoint_2 = {
	enabled = true,
	width = 100,
	depth = 1700,
	height = 500,
	on_executed = {
		{ id = 400140, delay = 0 },
	},
}
local optsSpawnConvoyCloakersCrossroad = {
	on_executed = {
		{ id = 400141, delay = 0 },
	},
	enabled = normal_and_above and hiding_convoy_cloakers_near_crossroad,
}
local spawn_random_convoy_cloakers_crossroad = {
	amount = cloaker_convoy_amount,
	amount_random = cloaker_convoy_amount_random,
	on_executed = {
		{ id = 400131, delay = 0 },
		{ id = 400132, delay = 0 },
		{ id = 400133, delay = 0 },
		{ id = 400134, delay = 0 },
	},
}

-- Near Parking Garage (Left side)
local optsCloaker_Convoy_9 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400146, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_10 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400147, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_11 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400148, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_12 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400149, delay = 0 } },
	enabled = true,
}
local optsAreaTriggerPoint_3 = {
	enabled = true,
	width = 100,
	depth = 2000,
	height = 500,
	on_executed = {
		{ id = 400151, delay = 0 },
	},
}
local optsSpawnConvoyCloakersParkingGarageLeft = {
	on_executed = {
		{ id = 400152, delay = 0 },
	},
	enabled = normal_and_above and hiding_convoy_cloakers_near_parking_garage_left_side,
}
local spawn_random_convoy_cloakers_parking_garage_left = {
	amount = cloaker_convoy_amount,
	amount_random = cloaker_convoy_amount_random,
	on_executed = {
		{ id = 400142, delay = 0 },
		{ id = 400143, delay = 0 },
		{ id = 400144, delay = 0 },
		{ id = 400145, delay = 0 },
	},
}

-- Near Parking Garage (right side)
local optsCloaker_Convoy_13 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400157, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_14 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400158, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_15 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400159, delay = 0 } },
	enabled = true,
}
local optsCloaker_Convoy_16 = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400160, delay = 0 } },
	enabled = true,
}
local optsAreaTriggerPoint_4 = {
	enabled = true,
	width = 100,
	depth = 2400,
	height = 500,
	on_executed = {
		{ id = 400162, delay = 0 },
	},
}
local optsSpawnConvoyCloakersParkingGarageRight = {
	on_executed = {
		{ id = 400163, delay = 0 },
	},
	enabled = normal_and_above and hiding_convoy_cloakers_near_parking_garage_right_side,
}
local spawn_random_convoy_cloakers_parking_garage_right = {
	amount = cloaker_convoy_amount,
	amount_random = cloaker_convoy_amount_random,
	on_executed = {
		{ id = 400153, delay = 0 },
		{ id = 400154, delay = 0 },
		{ id = 400155, delay = 0 },
		{ id = 400156, delay = 0 },
	},
}

-- HIDING CLOAKER SOs (For both garage and conovy)
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

-- HARASSERS
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

-- POLICE HELICOPTERS
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
local optsBesiegeDummy_Heli_1 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_down_17m_var2",
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

-- SWAT GARAGE BLOCKADE
local optsSWATB_Garage_1 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400194, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_2 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400195, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_3 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400196, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_4 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400197, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_5 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400198, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_6 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400199, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_7 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400200, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_8 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400201, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_9 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400202, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_10 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400203, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_11 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400204, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_12 = {
	enemy_table = swats_blockade,
	on_executed = {
		{ id = 400205, delay = 0 },
	},
	enabled = true,
}
local optsSWATB_Garage_13 = {
	enemy = scripted_enemy.bulldozer_1,
	enabled = is_eclipse and garage_dozer_chance,
}
local optsSWATB_Garage_14 = {
	enemy = scripted_enemy.cop_2,
	on_executed = {
		{ id = 400206, delay = 0 },
	},
	enabled = true,
}

local optsDefendSWAT_SO = {
	SO_access = "128",
	scan = true,
	align_position = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_defend",
}
local optsCoverCop_SO = {
	SO_access = "32",
	scan = true,
	align_position = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	interrupt_dis = 7,
	interrupt_dmg = 0,
	so_action = "e_so_enter_cover_r",
}
local optsSpawnSWATBlockade = {
	on_executed = {
		{ id = 400180, delay = 0 },
		{ id = 400181, delay = 0 },
		{ id = 400182, delay = 0 },
		{ id = 400183, delay = 0 },
		{ id = 400184, delay = 0 },
		{ id = 400185, delay = 0 },
		{ id = 400186, delay = 0 },
		{ id = 400187, delay = 0 },
		{ id = 400188, delay = 0 },
		{ id = 400189, delay = 0 },
		{ id = 400190, delay = 0 },
		{ id = 400191, delay = 0 },
		{ id = 400192, delay = 0 },
		{ id = 400193, delay = 0 },
	},
	enabled = true,
}

-- SNIPERS
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
local optsSniper_3 = {
	enemy = scripted_enemy.sniper,
	spawn_action = "e_sp_down_8m",
	on_executed = {
		{ id = 400113, delay = 0 },
	},
	trigger_times = 1,
	enabled = overkill_and_above,
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

-- MISC
local optsOpenSwatSpawnVanDoors = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102580, notify_unit_sequence = "door_open_left_back", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 102580, notify_unit_sequence = "door_open_right_back", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 102581, notify_unit_sequence = "door_open_left_back", time = 0 },
		{ id = 4, name = "run_sequence", notify_unit_id = 102581, notify_unit_sequence = "door_open_right_back", time = 0 },
		{ id = 5, name = "run_sequence", notify_unit_id = 102582, notify_unit_sequence = "door_open_left_back", time = 0 },
		{ id = 6, name = "run_sequence", notify_unit_id = 102582, notify_unit_sequence = "door_open_right_back", time = 0 },
		{ id = 7, name = "run_sequence", notify_unit_id = 102583, notify_unit_sequence = "door_open_left_back", time = 0 },
		{ id = 8, name = "run_sequence", notify_unit_id = 102583, notify_unit_sequence = "door_open_right_back", time = 0 },
		{ id = 9, name = "run_sequence", notify_unit_id = 102584, notify_unit_sequence = "door_open_left_back", time = 0 },
		{ id = 10, name = "run_sequence", notify_unit_id = 102584, notify_unit_sequence = "door_open_right_back", time = 0 },
		{ id = 11, name = "run_sequence", notify_unit_id = 102585, notify_unit_sequence = "door_open_left_back", time = 0 },
		{ id = 12, name = "run_sequence", notify_unit_id = 102585, notify_unit_sequence = "door_open_right_back", time = 0 },
		{ id = 13, name = "run_sequence", notify_unit_id = 102586, notify_unit_sequence = "door_open_left_back", time = 0 },
		{ id = 14, name = "run_sequence", notify_unit_id = 102586, notify_unit_sequence = "door_open_right_back", time = 0 },
		{ id = 15, name = "run_sequence", notify_unit_id = 102587, notify_unit_sequence = "door_open_left_back", time = 0 },
		{ id = 16, name = "run_sequence", notify_unit_id = 102587, notify_unit_sequence = "door_open_right_back", time = 0 },
	},
}

local optsAssaultEnd = {
	global_event = "end_assault",
}
local optsEnableAssaultEnd = {
	enabled = true,
	elements = {
		400210,
	},
}

M.elements = {
	-- Cloakers in the garage
	Eclipse.mission_elements.gen_dummy(400000, "garage_cloaker_1", Vector3(8400, 5939, -2400), Rotation(-90, 0, 0), optsCloaker_1),
	Eclipse.mission_elements.gen_dummy(400001, "garage_cloaker_2", Vector3(11876, 6918, -1992.450), Rotation(0, 0, 0), optsCloaker_2),
	Eclipse.mission_elements.gen_dummy(400002, "garage_cloaker_3", Vector3(11544, 5074, -2800), Rotation(-90, 0, 0), optsCloaker_3),
	Eclipse.mission_elements.gen_dummy(400003, "garage_cloaker_4", Vector3(12247, 5204, -2400), Rotation(-68, 0, 0), optsCloaker_4),
	Eclipse.mission_elements.gen_dummy(400004, "garage_cloaker_5", Vector3(10769, 7915, -2578.823), Rotation(-90, 0, 0), optsCloaker_5),
	Eclipse.mission_elements.gen_dummy(400005, "garage_cloaker_6", Vector3(9069, 6929, -2800), Rotation(0, 0, 0), optsCloaker_6),

	Eclipse.mission_elements.gen_so(400006, "garage_cloaker_hide_so_1", Vector3(8494, 5938, -2400), Rotation(-90, 0, 0), optsCloaker_Hide_SO_1),
	Eclipse.mission_elements.gen_so(400007, "garage_cloaker_hide_so_2", Vector3(11874, 6997, -2000.458), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400008, "garage_cloaker_hide_so_3", Vector3(11602, 5075, -2800), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400009, "garage_cloaker_hide_so_4", Vector3(12201, 5165, -2400), Rotation(-52, 0, 0), optsCloaker_Hide_SO_3),
	Eclipse.mission_elements.gen_so(400010, "garage_cloaker_hide_so_5", Vector3(10851.183, 7925.074, -2563.219), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400011, "garage_cloaker_hide_so_6", Vector3(9075, 7099, -2800), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),

	Eclipse.mission_elements.gen_element_random(400012, "random_garage_cloakers", spawn_random_cloakers),
	Eclipse.mission_elements.gen_missionscript(400209, "spawn_garage_cloakers", optsSpawnGarageCloakers),

	-- suprise cloaker at the start of the heist (so evil)
	Eclipse.mission_elements.gen_dummy(400038, "cloaker_ambush_1", Vector3(-7290, -8797, -2000), Rotation(-85, 0, 0), optsCloaker_Ambush),
	Eclipse.mission_elements.gen_so(400039, "cloaker_ambush_hide_so_1", Vector3(-7229.177, -8819.247, -2000), Rotation(-66, 0, 0), optsCloaker_Hide_SO_Ambush),

	-- Snipers and Harassers
	Eclipse.mission_elements.gen_dummy(400013, "sniper_1", Vector3(1858, -7442, -1598.273), Rotation(0, 0, 0), optsSniper_1),
	Eclipse.mission_elements.gen_dummy(400014, "sniper_2", Vector3(-3496, -5789, -1999.987), Rotation(133, 0, 0), optsSniper_2),
	Eclipse.mission_elements.gen_dummy(400112, "sniper_3", Vector3(7300, -549, -1500), Rotation(-90, 0, 0), optsSniper_3),
	Eclipse.mission_elements.gen_so(400015, "sniper_so_1", Vector3(1697, -6645, -1598.273), Rotation(90, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400016, "sniper_so_2", Vector3(-3536, -5825, -1999.965), Rotation(122, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400113, "sniper_so_3", Vector3(7089, -845, -1505), Rotation(90, 0, 0), optsSniper_SO),
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
	Eclipse.mission_elements.gen_smokegrenade(400091, "smoke_grenade_dozer_6", Vector3(5953, 4468, -2020), Rotation(0, 0, 0), Smoke_bomb_dozer_van),
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

	-- More prison guards (more accurate to live action trailer)
	Eclipse.mission_elements.gen_dummy(400100, "prison_guard_1", Vector3(-8805.185, -12079.866, -2400), Rotation(-90, 0, 0), optsPrison_Guard_1),
	Eclipse.mission_elements.gen_dummy(400101, "prison_guard_2", Vector3(-7294.185, -12079.866, -2400), Rotation(90, 0, 0), optsPrison_Guard_2),
	Eclipse.mission_elements.gen_dummy(400102, "prison_guard_3", Vector3(-7113, -9815, -2400), Rotation(110, 0, 0), optsPrison_Guard_3),
	Eclipse.mission_elements.gen_dummy(400103, "prison_guard_4", Vector3(-7007, -9911, -2400), Rotation(90, 0, 0), optsPrison_Guard_4),
	Eclipse.mission_elements.gen_dummy(400104, "prison_guard_5", Vector3(-6980, -10022, -2400), Rotation(90, 0, 0), optsPrison_Guard_5),
	Eclipse.mission_elements.gen_dummy(400105, "prison_guard_6", Vector3(-7125, -10116, -2400), Rotation(70, 0, 0), optsPrison_Guard_6),

	Eclipse.mission_elements.gen_so(400106, "guard_defend_so_1", Vector3(-8673.288, -12056.150, -2400), Rotation(-95, 0, 0), optsDefendGuard_SO),
	Eclipse.mission_elements.gen_so(400107, "guard_defend_so_2", Vector3(-7528.275, -12083.048, -2400), Rotation(95, 0, 0), optsDefendGuard_SO),
	Eclipse.mission_elements.gen_so(400108, "guard_defend_so_3", Vector3(-7113, -9815, -2400), Rotation(110, 0, 0), optsDefendGuard_SO),
	Eclipse.mission_elements.gen_so(400109, "guard_defend_so_4", Vector3(-7007, -9911, -2400), Rotation(90, 0, 0), optsDefendGuard_SO),
	Eclipse.mission_elements.gen_so(400110, "guard_defend_so_5", Vector3(-6980, -10022, -2400), Rotation(90, 0, 0), optsDefendGuard_SO),
	Eclipse.mission_elements.gen_so(400111, "guard_defend_so_6", Vector3(-7125, -10116, -2400), Rotation(70, 0, 0), optsDefendGuard_SO),

	-- Scripted hiding cloakers for the convoy part
	-- near car shop
	Eclipse.mission_elements.gen_dummy(400120, "cloaker_conovy_1", Vector3(-1716, -1703, -2020), Rotation(-180, 0, 0), optsCloaker_Convoy_1),
	Eclipse.mission_elements.gen_dummy(400121, "cloaker_conovy_2", Vector3(-1628, -1703, -2020), Rotation(-180, 0, 0), optsCloaker_Convoy_2),
	Eclipse.mission_elements.gen_dummy(400122, "cloaker_conovy_3", Vector3(-1548, -1703, -2020), Rotation(-180, 0, 0), optsCloaker_Convoy_3),
	Eclipse.mission_elements.gen_dummy(400123, "cloaker_conovy_4", Vector3(-1449, -1703, -2020), Rotation(-180, 0, 0), optsCloaker_Convoy_4),

	Eclipse.mission_elements.gen_so(400124, "cloaker_convoy_so_1", Vector3(-1264, -1950, -2020), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400125, "cloaker_convoy_so_2", Vector3(-651, -1950, -2020), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400126, "cloaker_convoy_so_3", Vector3(-651, -1451, -2020), Rotation(90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400127, "cloaker_convoy_so_4", Vector3(-3057, -1961, -2020), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),

	Eclipse.mission_elements.gen_areatrigger(400128, "area_trigger_spooc_point_1", Vector3(-4023, -4583, -2020), Rotation(0, 0, 0), optsAreaTriggerPoint_1),
	Eclipse.mission_elements.gen_missionscript(400129, "spawn_hiding_cloakers_near_car_shop", optsSpawnConvoyCloakersCarShop),
	Eclipse.mission_elements.gen_element_random(400130, "random_convoy_cloakers_car_shop", spawn_random_convoy_cloakers_car_shop),

	Eclipse.mission_elements.gen_dummy(400164, "cloaker_car_shop_1", Vector3(-1816, 1095, -1996), Rotation(-90, 0, 0), optsCloaker_Car_Shop_Ambush_1),

	Eclipse.mission_elements.gen_so(400165, "cloaker_car_shop_so_1", Vector3(-1253, 64, -1998.406), Rotation(-180, 0, 0), optsCloaker_Hide_SO_1),
	Eclipse.mission_elements.gen_so(400166, "cloaker_car_shop_so_2", Vector3(-1737, -346, -1998.406), Rotation(0, 0, 0), optsCloaker_Hide_SO_3),
	Eclipse.mission_elements.gen_so(400167, "cloaker_car_shop_so_3", Vector3(-589.621, -324.240, -1998.406), Rotation(39, 0, 0), optsCloaker_Hide_SO_3),
	Eclipse.mission_elements.gen_so(400168, "cloaker_car_shop_so_4", Vector3(-1737.788, 158.081, -1998.406), Rotation(-90, 0, 0), optsCloaker_Hide_SO_1),
	Eclipse.mission_elements.gen_so(400169, "cloaker_car_shop_so_5", Vector3(-791.788, 318.081, -1998.406), Rotation(90, 0, 0), optsCloaker_Hide_SO_1),

	Eclipse.mission_elements.gen_missionscript(400170, "spawn_ambush_cloaker_in_car_shop", optsSpawnAmbushCloakerinCarShop),
	Eclipse.mission_elements.gen_element_random(400171, "choose_random_hiding_spot", choose_random_hiding_spot),

	-- near crossroad
	Eclipse.mission_elements.gen_dummy(400131, "cloaker_conovy_5", Vector3(603, -3735, -2020), Rotation(90, 0, 0), optsCloaker_Convoy_5),
	Eclipse.mission_elements.gen_dummy(400132, "cloaker_conovy_6", Vector3(603, -3793, -2020), Rotation(90, 0, 0), optsCloaker_Convoy_6),
	Eclipse.mission_elements.gen_dummy(400133, "cloaker_conovy_7", Vector3(603, -3853, -2020), Rotation(90, 0, 0), optsCloaker_Convoy_7),
	Eclipse.mission_elements.gen_dummy(400134, "cloaker_conovy_8", Vector3(603, -3914, -2020), Rotation(90, 0, 0), optsCloaker_Convoy_8),

	Eclipse.mission_elements.gen_so(400135, "cloaker_convoy_so_5", Vector3(861, -5553, -2020), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400136, "cloaker_convoy_so_6", Vector3(861, -2883, -2020), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400137, "cloaker_convoy_so_7", Vector3(340, -2650, -2020), Rotation(-180, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400138, "cloaker_convoy_so_8", Vector3(346, -3392, -2020), Rotation(-180, 0, 0), optsCloaker_Hide_SO_2),

	Eclipse.mission_elements.gen_areatrigger(400139, "area_trigger_spooc_point_2", Vector3(-2950, -6543, -2020), Rotation(0, 0, 0), optsAreaTriggerPoint_2),
	Eclipse.mission_elements.gen_missionscript(400140, "spawn_hiding_cloakers_near_crossroad", optsSpawnConvoyCloakersCrossroad),
	Eclipse.mission_elements.gen_element_random(400141, "random_convoy_cloakers_crossroad", spawn_random_convoy_cloakers_crossroad),

	-- near garage entrance (left side)
	Eclipse.mission_elements.gen_dummy(400142, "cloaker_conovy_9", Vector3(3155, 3098, -2020), Rotation(0, 0, 0), optsCloaker_Convoy_9),
	Eclipse.mission_elements.gen_dummy(400143, "cloaker_conovy_10", Vector3(3093, 3098, -2020), Rotation(0, 0, 0), optsCloaker_Convoy_10),
	Eclipse.mission_elements.gen_dummy(400144, "cloaker_conovy_11", Vector3(3024, 3098, -2020), Rotation(0, 0, 0), optsCloaker_Convoy_11),
	Eclipse.mission_elements.gen_dummy(400145, "cloaker_conovy_12", Vector3(2958, 3098, -2020), Rotation(0, 0, 0), optsCloaker_Convoy_12),

	Eclipse.mission_elements.gen_so(400146, "cloaker_convoy_so_9", Vector3(4109, 3356, -2020), Rotation(90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400147, "cloaker_convoy_so_10", Vector3(4211, 2846, -2020), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400148, "cloaker_convoy_so_11", Vector3(3385, 2846, -2020), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400149, "cloaker_convoy_so_12", Vector3(1800, 2846, -2020), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),

	Eclipse.mission_elements.gen_areatrigger(400150, "area_trigger_spooc_point_3", Vector3(572, 557, -2020), Rotation(90, 0, 0), optsAreaTriggerPoint_3),
	Eclipse.mission_elements.gen_missionscript(400151, "spawn_hiding_cloakers_near_parking_garage_left", optsSpawnConvoyCloakersParkingGarageLeft),
	Eclipse.mission_elements.gen_element_random(400152, "random_convoy_cloakers_parking_garage_left", spawn_random_convoy_cloakers_parking_garage_left),

	-- near garage entrance (right side)
	Eclipse.mission_elements.gen_dummy(400153, "cloaker_conovy_13", Vector3(5402, 649, -2020), Rotation(90, 0, 0), optsCloaker_Convoy_13),
	Eclipse.mission_elements.gen_dummy(400154, "cloaker_conovy_14", Vector3(5402, 709, -2020), Rotation(90, 0, 0), optsCloaker_Convoy_14),
	Eclipse.mission_elements.gen_dummy(400155, "cloaker_conovy_15", Vector3(5402, 774, -2020), Rotation(90, 0, 0), optsCloaker_Convoy_15),
	Eclipse.mission_elements.gen_dummy(400156, "cloaker_conovy_16", Vector3(5402, 843, -2020), Rotation(90, 0, 0), optsCloaker_Convoy_16),

	Eclipse.mission_elements.gen_so(400157, "cloaker_convoy_so_13", Vector3(5148, 1440, -2020), Rotation(-180, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400158, "cloaker_convoy_so_14", Vector3(5596, 1715, -2020), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400159, "cloaker_convoy_so_15", Vector3(5649, 5, -2020), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400160, "cloaker_convoy_so_16", Vector3(5646, -642, -2020), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),

	Eclipse.mission_elements.gen_areatrigger(400161, "area_trigger_spooc_point_4", Vector3(2577, -2098, -2020), Rotation(90, 0, 0), optsAreaTriggerPoint_4),
	Eclipse.mission_elements.gen_missionscript(400162, "spawn_hiding_cloakers_near_parking_garage_right", optsSpawnConvoyCloakersParkingGarageRight),
	Eclipse.mission_elements.gen_element_random(400163, "random_convoy_cloakers_parking_garage_right", spawn_random_convoy_cloakers_parking_garage_right),

	-- Swat Garage Blockade
	Eclipse.mission_elements.gen_dummy(400180, "swat_garage_1", Vector3(8671.368, 6053.832, -2400), Rotation(-178, 0, 0), optsSWATB_Garage_1),
	Eclipse.mission_elements.gen_dummy(400181, "swat_garage_2", Vector3(8832.157, 5997.328, -2400), Rotation(-175, 0, 0), optsSWATB_Garage_2),
	Eclipse.mission_elements.gen_dummy(400182, "swat_garage_3", Vector3(8910.221, 6010.651, -2400), Rotation(-171, 0, 0), optsSWATB_Garage_3),
	Eclipse.mission_elements.gen_dummy(400183, "swat_garage_4", Vector3(9095.689, 5995.170, -2400), Rotation(175, 0, 0), optsSWATB_Garage_4),
	Eclipse.mission_elements.gen_dummy(400184, "swat_garage_5", Vector3(9223.760, 6136.719, -2400), Rotation(169, 0, 0), optsSWATB_Garage_5),
	Eclipse.mission_elements.gen_dummy(400185, "swat_garage_6", Vector3(9405, 6052, -2400), Rotation(160, 0, 0), optsSWATB_Garage_6),
	Eclipse.mission_elements.gen_dummy(400186, "swat_garage_7", Vector3(9529, 5986, -2400), Rotation(156, 0, 0), optsSWATB_Garage_7),
	Eclipse.mission_elements.gen_dummy(400187, "swat_garage_8", Vector3(9643, 6033, -2400), Rotation(145, 0, 0), optsSWATB_Garage_8),
	Eclipse.mission_elements.gen_dummy(400188, "swat_garage_9", Vector3(9778.501, 5974.364, -2400), Rotation(159, 0, 0), optsSWATB_Garage_9),
	Eclipse.mission_elements.gen_dummy(400189, "swat_garage_10", Vector3(9545, 4957, -2400), Rotation(154, 0, 0), optsSWATB_Garage_10),
	Eclipse.mission_elements.gen_dummy(400190, "swat_garage_11", Vector3(9530, 4738, -2400), Rotation(149, 0, 0), optsSWATB_Garage_11),
	Eclipse.mission_elements.gen_dummy(400191, "swat_garage_12", Vector3(9508, 4553, -2400), Rotation(147, 0, 0), optsSWATB_Garage_12),
	Eclipse.mission_elements.gen_dummy(400192, "swat_garage_13", Vector3(9958, 4378, -2400), Rotation(90, 0, 0), optsSWATB_Garage_13),
	Eclipse.mission_elements.gen_dummy(400193, "swat_garage_14", Vector3(8845.293, 6406.062, -2400), Rotation(-104, 0, 0), optsSWATB_Garage_14),

	Eclipse.mission_elements.gen_so(400194, "swat_garage_defend_so_1", Vector3(8718.022, 5826.465, -2400), Rotation(-176, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400195, "swat_garage_defend_so_2", Vector3(8852.694, 5835.882, -2400), Rotation(-176, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400196, "swat_garage_defend_so_3", Vector3(9003.327, 5846.415, -2400), Rotation(-176, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400197, "swat_garage_defend_so_4", Vector3(9098.430, 5790.914, -2400), Rotation(-180, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400198, "swat_garage_defend_so_5", Vector3(9193.198, 5797.541, -2400), Rotation(-180, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400199, "swat_garage_defend_so_6", Vector3(9296.610, 5866.923, -2400), Rotation(175, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400200, "swat_garage_defend_so_7", Vector3(9397.225, 5858.121, -2400), Rotation(175, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400201, "swat_garage_defend_so_8", Vector3(9507.802, 5848.446, -2400), Rotation(175, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400202, "swat_garage_defend_so_9", Vector3(9638.304, 5837.029, -2400), Rotation(154, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400203, "swat_garage_defend_so_10", Vector3(9488.883, 4886.822, -2400), Rotation(142, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400204, "swat_garage_defend_so_11", Vector3(9465.558, 4668.043, -2400), Rotation(142, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400205, "swat_garage_defend_so_12", Vector3(9456, 4508, -2400), Rotation(142, 0, 0), optsDefendSWAT_SO),
	Eclipse.mission_elements.gen_so(400206, "swat_garage_defend_so_13", Vector3(8942, 6272, -2400), Rotation(-90, 0, 0), optsCoverCop_SO),

	Eclipse.mission_elements.gen_missionscript(400207, "spawn_swat_garage_blockade", optsSpawnSWATBlockade),

	-- misc
	-- open swat doors for spawns
	Eclipse.mission_elements.gen_object_editor(400208, "open_swat_spawn_doors", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatSpawnVanDoors),

	-- assault_end trigger
	Eclipse.mission_elements.gen_global_event(400210, "assault_end", Vector3(0, 0, 0), Rotation(0, 0, 0), optsAssaultEnd),
	Eclipse.mission_elements.gen_toggleelement(400211, "enable_assault_end", optsEnableAssaultEnd),
}
return M
