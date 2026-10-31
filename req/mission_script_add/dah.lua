---@module Diamond Heist
local M = {}

local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()

local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts

local random_dozers = {
	scripted_enemy.bulldozer_1,
	scripted_enemy.bulldozer_2,
}
local random_elite_dozers = {
	scripted_enemy.elite_bulldozer_1,
	scripted_enemy.elite_bulldozer_2,
}

local gensec_security = scripted_enemy.gensec_2
local swat_ambush_table = {
	[scripted_enemy.heavy_swat_1] = get_difficulty_group_specific_value({ 4, 6, 8 }),
	[scripted_enemy.heavy_swat_2] = get_difficulty_group_specific_value({ 2, 4, 6 }),
	[scripted_enemy.swat_1] = 5,
	[scripted_enemy.swat_2] = 3,
}

local bags_required = 4 + (is_pro_job and 2 or 0)

local enabled_chance_extra_elevator_spawns = math.random() <= 0.6
local enabled_chance_helipad_shields = math.random() <= 0.4
local enabled_chance_helipad_dozer = math.random() <= 0.4

local optsCloaker = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_climb_up_3m_down_1m",
	on_executed = {
		{ id = 400078, delay = 0 },
	},
	enabled = true,
}
local optsSniperAmbush_1 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400014, delay = 0 },
	},
	enabled = is_eclipse_pro,
}
local optsSniperAmbush_2 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400017, delay = 0 },
	},
	enabled = is_eclipse_pro,
}
local optsSniperAmbush_3 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400016, delay = 0 },
	},
	enabled = is_eclipse_pro,
}
local optsSniperAmbush_4 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400015, delay = 0 },
	},
	enabled = is_eclipse_pro,
}
local optsSniper_escape = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400060, delay = 0 },
	},
	spawn_action = "e_sp_climb_up_3m_down_1m",
	enabled = true,
}
local optsSniper_1 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400074, delay = 0 },
	},
	spawn_action = "e_sp_clk_up_manhole", --I like using cloaker specific spawn anims for other units
	enabled = overkill_and_above,
}
local optsSniper_2 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400075, delay = 0 },
	},
	spawn_action = "e_sp_clk_up_manhole",
	enabled = overkill_and_above,
}
local optsShield_roofblockade_1 = {
	enemy = scripted_enemy.elite_shield,
	on_executed = {
		{ id = 400051, delay = 0 },
	},
	spawn_action = "e_sp_clk_3_5m_dwn_vent_var2",
	enabled = is_eclipse,
}
local optsShield_roofblockade_2 = {
	enemy = scripted_enemy.elite_shield,
	on_executed = {
		{ id = 400052, delay = 0 },
	},
	spawn_action = "e_sp_clk_3_5m_dwn_vent_var2",
	enabled = is_eclipse,
}
local optsShield_roofblockade_3 = {
	enemy = scripted_enemy.elite_shield,
	on_executed = {
		{ id = 400057, delay = 0 },
	},
	spawn_action = "e_sp_climb_up_3m_down_1m",
	enabled = is_eclipse,
}
local optsShield_roofblockade_4 = {
	enemy = scripted_enemy.elite_shield,
	on_executed = {
		{ id = 400058, delay = 0 },
	},
	spawn_action = "e_sp_climb_up_3m_down_1m",
	enabled = is_eclipse,
}
local optsTaser_roofblockade_1 = {
	enemy = scripted_enemy.taser_1,
	on_executed = {
		{ id = 400050, delay = 0 },
	},
	spawn_action = "e_sp_clk_3_5m_dwn_vent_var2",
	enabled = is_eclipse,
}
local optsTaser_roofblockade_2 = {
	enemy = scripted_enemy.taser_1,
	on_executed = {
		{ id = 400056, delay = 0 },
	},
	spawn_action = "e_sp_climb_up_3m_down_1m",
	enabled = is_eclipse,
}
local optsBulldozer = {
	enemy_table = random_dozers,
	participate_to_group_ai = true,
	enabled = overkill_and_above and enabled_chance_extra_elevator_spawns,
}
local optsBulldozer_helipad = {
	enemy_table = random_dozers,
	participate_to_group_ai = true,
	on_executed = {
		{ id = 400069, delay = 0 },
	},
	enabled = overkill_and_above and enabled_chance_helipad_dozer,
}
local optsShield_helipad_1 = {
	enemy = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield,
	on_executed = {
		{ id = 400070, delay = 0 },
	},
	enabled = overkill_and_above and enabled_chance_helipad_shields,
}
local optsShield_helipad_2 = {
	enemy = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield,
	on_executed = {
		{ id = 400071, delay = 0 },
	},
	enabled = overkill_and_above and enabled_chance_helipad_shields,
}
local optsTaser = {
	enemy = scripted_enemy.taser_1,
	participate_to_group_ai = true,
	enabled = overkill_and_above and enabled_chance_extra_elevator_spawns,
}
local optsBulldozer_Ambush = {
	enemy_table = random_dozers,
	participate_to_group_ai = true,
	enabled = is_eclipse,
}
local optsCloaker_Ambush = {
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	enabled = normal_and_above,
}
local optsTaser_Ambush = {
	enemy = scripted_enemy.taser_1,
	participate_to_group_ai = true,
	enabled = normal_and_above,
}
local optsSWAT_Ambush = {
	enemy_table = swat_ambush_table,
	participate_to_group_ai = true,
	enabled = true,
}
local optsSecret_Service_1 = {
	enemy = gensec_security,
	on_executed = {
		{ id = 400088, delay = 0 },
	},
	enabled = true,
}
local optsSecret_Service_2 = {
	enemy = gensec_security,
	on_executed = {
		{ id = 400089, delay = 0 },
	},
	enabled = true,
}
local optsSecret_Service_3 = {
	enemy = gensec_security,
	on_executed = {
		{ id = 400092, delay = 0 },
	},
	enabled = true,
}
local optsSecret_Service_4 = {
	enemy = gensec_security,
	on_executed = {
		{ id = 400093, delay = 0 },
	},
	enabled = true,
}
local optsSecret_Service_5 = {
	enemy = gensec_security,
	enabled = true,
}
local optsSecret_Service_9 = {
	enemy = gensec_security,
	on_executed = {
		{ id = 410004, delay = 0 },
	},
	enabled = true,
}
local optsSecret_Service_10 = {
	enemy = gensec_security,
	on_executed = {
		{ id = 410005, delay = 0 },
	},
	enabled = true,
}
local optsDefend_and_Sniper_SO = {
	SO_access = tostring(128 + 512 + 2048 + 8192),
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsDefendDozer_SO = {
	SO_access = "4096",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsCloaker_SO = {
	SO_access = "1024",
	path_style = "none",
	scan = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_hunt",
}
local optsSecret_Service_Defend = {
	SO_access = "8",
	scan = true,
	needs_pos_rsrv = true,
	align_position = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsrespawn_taser_1 = {
	on_executed = {
		{ id = 400047, delay = 45, delay_rand = is_pro_job and 45 or 75 },
	},
	elements = {
		400047,
	},
	event = "death",
}
local optsrespawn_shield_1 = {
	on_executed = {
		{ id = 400048, delay = 45, delay_rand = is_pro_job and 45 or 75 },
	},
	elements = {
		400048,
	},
	event = "death",
}
local optsrespawn_shield_2 = {
	on_executed = {
		{ id = 400049, delay = 45, delay_rand = is_pro_job and 45 or 75 },
	},
	elements = {
		400049,
	},
	event = "death",
}
local optsrespawn_taser_2 = {
	on_executed = {
		{ id = 400053, delay = 45, delay_rand = is_pro_job and 45 or 75 },
	},
	elements = {
		400053,
	},
	event = "death",
}
local optsrespawn_shield_3 = {
	on_executed = {
		{ id = 400054, delay = 45, delay_rand = is_pro_job and 45 or 75 },
	},
	elements = {
		400054,
	},
	event = "death",
}
local optsrespawn_shield_4 = {
	on_executed = {
		{ id = 400055, delay = 45, delay_rand = is_pro_job and 45 or 75 },
	},
	elements = {
		400055,
	},
	event = "death",
}
local enable_snipers = {
	enabled = true,
	elements = {
		400072,
		400073,
	},
}
local disable_snipers = {
	enabled = true,
	toggle = "off",
	elements = {
		400072,
		400073,
	},
}
local Smoke_bomb = {
	duration = 8,
}
local optsinstance_bag_requirment = {
	instance = "obj_link_009",
	params = {
		var_amount_death_wish = bags_required,
		var_amount_hard = bags_required,
		var_amount_normal = bags_required,
		var_amount_overkill = bags_required,
		var_amount_very_hard = bags_required,
		var_objective = "dah_11",
	},
}
local optsDifficultyAddend01 = {
	trigger_times = 1,
	difficulty_addends = {
		{
			amount = 0.25,
			delay = 0,
			time = 60,
			time_balance_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	enabled = true,
}

local optsBesiegeDummyCloaker_1 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_dah_up_climb_to_roof",
	enabled = true,
}
local optsBesiegeDummyCloaker_2 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_climb_up_6m_down_1m",
	enabled = true,
}
local optsBesiegeDummyCloaker_3 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_up_ledge",
	enabled = true,
}
local optsBesiegeDummyCloaker_4 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_dwn_11m",
	enabled = true,
}
local optsBesiegeDummyCloaker_5 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_dah_up_climb_one_window",
	enabled = true,
}

local optsPreferedCloakerAdd1 = {
	spawn_groups = { 500043, 500044, 500045, 500046, 500047, 500048, 500049, 500050, 500051, 500052, 500053 },
	on_executed = {
		{ id = 500060, delay = 0 },
	},
	enabled = true,
}
local optsAddCloakerHideGroup = {
	enabled = true,
	on_executed = {
		{ id = 500059, delay = 0 },
	},
}
local optsCloakerHideGroup = {
	followup_elements = {
		500000,
		500001,
		500002,
		500003,
		500004,
		500005,
		500006,
		500007,
		500008,
		500009,
		500010,
		500011,
		500012,
		500013,
		500014,
		500015,
		500016,
		500017,
		500018,
		500019,
		500020,
		500021,
		500022,
		500023,
		500024,
		500025,
		500026,
		500027,
		500028,
		500029,
		500030,
		500031,
	},
}

local optsspooc_spawned_1 = {
	on_executed = {
		{ id = 500057, delay = 0 },
	},
	elements = {
		500039,
	},
}
local optsspooc_spawned_2 = {
	on_executed = {
		{ id = 104245, delay = 0 },
	},
	elements = {
		500040,
	},
}
local optsspooc_spawned_3 = {
	on_executed = {
		{ id = 104257, delay = 0 },
	},
	elements = {
		500041,
	},
}
local optsspooc_spawned_4 = {
	on_executed = {
		{ id = 500058, delay = 0 },
	},
	elements = {
		500042,
	},
}
local optsDestroyTheGlass_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102765, notify_unit_sequence = "destroy_01", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 102765, notify_unit_sequence = "destroy_02", time = 0 },
		{ id = 1, name = "run_sequence", notify_unit_id = 102764, notify_unit_sequence = "destroy_01", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 102764, notify_unit_sequence = "destroy_02", time = 0 },
		{ id = 1, name = "run_sequence", notify_unit_id = 102762, notify_unit_sequence = "destroy_01", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 102762, notify_unit_sequence = "destroy_02", time = 0 },
		{ id = 1, name = "run_sequence", notify_unit_id = 102763, notify_unit_sequence = "destroy_01", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 102763, notify_unit_sequence = "destroy_02", time = 0 },
	},
}
local optsDestroyTheGlass_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102760, notify_unit_sequence = "destroy_01", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 102760, notify_unit_sequence = "destroy_02", time = 0 },
	},
}
local optsAssaultStarted = {
	enabled = true,
	global_event = "start_assault",
	trigger_times = 1,
	on_executed = {
		{ id = 500061, delay = 0 },
	},
}

-- Hiding Cloaker SOs are funny
local hide_so_search_pos = Vector3(-90, 0, 375)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_sneak_wait_stand", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var3", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_4 = get_hiding_cloaker_so_opts("e_so_hide_under_car_enter", hide_so_search_pos)

M.elements = {
	--Cloakers
	Eclipse.mission_elements.gen_dummy(400001, "cloaker_1", Vector3(-100, -1834, 1175), Rotation(90, 0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400002, "cloaker_2", Vector3(-100, -1967, 1175), Rotation(90, -0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400003, "cloaker_3", Vector3(-100, -1903, 1175), Rotation(90, -0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400004, "cloaker_4", Vector3(-6175, -5325, 1175), Rotation(0, -0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400005, "cloaker_5", Vector3(-6275, -5325, 1175), Rotation(0, -0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400006, "cloaker_6", Vector3(-6375, -5325, 1175), Rotation(0, -0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400007, "cloaker_7", Vector3(-6531, -291, 1175.010), Rotation(-90, 0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400008, "cloaker_8", Vector3(-6531, -196, 1175.010), Rotation(-90, 0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400009, "cloaker_9", Vector3(-6531, -116, 1175.010), Rotation(-90, 0, -0), optsCloaker),

	--Ambush Units
	--Snipers
	Eclipse.mission_elements.gen_dummy(400010, "sniper_ambush_1", Vector3(-5217, -4047, 50), Rotation(0, 0, -0), optsSniperAmbush_1),
	Eclipse.mission_elements.gen_dummy(400011, "sniper_ambush_2", Vector3(-5217, -5138, 50), Rotation(-180, 0, -0), optsSniperAmbush_2),
	Eclipse.mission_elements.gen_dummy(400012, "sniper_ambush_3", Vector3(-1377, -5145, 50), Rotation(180, 0, -0), optsSniperAmbush_3),
	Eclipse.mission_elements.gen_dummy(400013, "sniper_ambush_4", Vector3(-1383, -4046, 50), Rotation(0, 0, -0), optsSniperAmbush_4),
	Eclipse.mission_elements.gen_so(400014, "sniper_ambush_so_1", Vector3(-4545, -4146, 50), Rotation(-135, 0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400015, "sniper_ambush_so_2", Vector3(-2837, -4052, 50), Rotation(90, -0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400016, "sniper_ambush_so_3", Vector3(-2633.425, -5111.369, 51), Rotation(35, -0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400017, "sniper_ambush_so_4", Vector3(-3976, -5087, 50), Rotation(-25, 0, -0), optsDefend_and_Sniper_SO),

	--Cloakers
	Eclipse.mission_elements.gen_dummy(400018, "kiryu_kazuma", Vector3(-1424, -4215, 50), Rotation(0, 0, -0), optsCloaker_Ambush),
	Eclipse.mission_elements.gen_dummy(400019, "majima_goro", Vector3(-1424, -4988, 50), Rotation(-180, 0, -0), optsCloaker_Ambush),

	--Tasers
	Eclipse.mission_elements.gen_dummy(400020, "taser_ambush_1", Vector3(-5175, -4990, 50), Rotation(180, 0, -0), optsTaser_Ambush),
	Eclipse.mission_elements.gen_dummy(400021, "taser_ambush_2", Vector3(-5171, -4210, 50), Rotation(0, 0, -0), optsTaser_Ambush),

	--Dozer
	Eclipse.mission_elements.gen_dummy(400022, "dozer_ambush_1", Vector3(-1425, -5148, 50), Rotation(180, 0, -0), optsBulldozer_Ambush),

	--SWAT
	Eclipse.mission_elements.gen_dummy(400023, "swat_ambush_1", Vector3(-1368, -4156, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400024, "swat_ambush_2", Vector3(-1428, -4156, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400025, "swat_ambush_3", Vector3(-1499, -4156, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400026, "swat_ambush_4", Vector3(-1368, -4082, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400027, "swat_ambush_5", Vector3(-1428, -4082, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400028, "swat_ambush_6", Vector3(-1499, -4082, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400029, "swat_ambush_7", Vector3(-1481, -5029, 50), Rotation(-180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400030, "swat_ambush_8", Vector3(-1428, -5029, 50), Rotation(-180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400031, "swat_ambush_9", Vector3(-1369, -5029, 50), Rotation(-180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400032, "swat_ambush_10", Vector3(-1477, -5102, 50), Rotation(-180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400033, "swat_ambush_11", Vector3(-1425, -5102, 50), Rotation(-180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400034, "swat_ambush_12", Vector3(-1370, -5102, 50), Rotation(-180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400035, "swat_ambush_13", Vector3(-5119, -5102, 50), Rotation(180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400036, "swat_ambush_14", Vector3(-5170, -5102, 50), Rotation(180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400037, "swat_ambush_15", Vector3(-5229, -5102, 50), Rotation(180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400038, "swat_ambush_16", Vector3(-5229, -5027, 50), Rotation(180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400039, "swat_ambush_17", Vector3(-5170, -5027, 50), Rotation(180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400040, "swat_ambush_18", Vector3(-5117, -5027, 50), Rotation(180, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400041, "swat_ambush_19", Vector3(-5117, -4157, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400042, "swat_ambush_20", Vector3(-5173, -4157, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400043, "swat_ambush_21", Vector3(-5230, -4157, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400044, "swat_ambush_22", Vector3(-5230, -4083, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400045, "swat_ambush_23", Vector3(-5175, -4083, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	Eclipse.mission_elements.gen_dummy(400046, "swat_ambush_24", Vector3(-5118, -4083, 50), Rotation(0, 0, -0), optsSWAT_Ambush),
	--Roof Acesss blockades
	Eclipse.mission_elements.gen_dummy(400047, "taser_roof_access_blockade_1", Vector3(-1205, -3532, 1175), Rotation(87, -0, -0), optsTaser_roofblockade_1),
	Eclipse.mission_elements.gen_dummy(400048, "shield_roof_access_blockade_1", Vector3(-1205, -3532, 1175), Rotation(87, -0, -0), optsShield_roofblockade_1),
	Eclipse.mission_elements.gen_dummy(400049, "shield_roof_access_blockade_2", Vector3(-1205, -3532, 1175), Rotation(87, -0, -0), optsShield_roofblockade_2),
	Eclipse.mission_elements.gen_so(400050, "taser_blockade_so_1", Vector3(-1306, -3507, 1175), Rotation(-180, 0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400051, "shield_blockade_so_1", Vector3(-1340, -3998, 975), Rotation(0, 0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400052, "shield_blockade_so_2", Vector3(-1457, -4001, 975), Rotation(0, 0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_dummy(400053, "taser_roof_access_blockade_2", Vector3(-6505, -3849, 1175), Rotation(-90, -0, -0), optsTaser_roofblockade_2),
	Eclipse.mission_elements.gen_dummy(400054, "shield_roof_access_blockade_3", Vector3(-6505, -3849, 1175), Rotation(-90, -0, -0), optsShield_roofblockade_3),
	Eclipse.mission_elements.gen_dummy(400055, "shield_roof_access_blockade_4", Vector3(-6505, -3849, 1175), Rotation(-90, -0, -0), optsShield_roofblockade_4),
	Eclipse.mission_elements.gen_so(400056, "taser_blockade_so_2", Vector3(-5886, -4567, 954.429), Rotation(180, 0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400057, "shield_blockade_so_3", Vector3(-5913, -4815, 828.259), Rotation(180, 0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400058, "shield_blockade_so_4", Vector3(-5828, -4812, 829.808), Rotation(180, 0, -0), optsDefend_and_Sniper_SO),

	--Escape Sniper
	Eclipse.mission_elements.gen_dummy(400059, "sniper_escape", Vector3(-6505, -3991, 1175), Rotation(-90, 0, -0), optsSniper_escape),
	Eclipse.mission_elements.gen_so(400060, "sniper_escape_so", Vector3(-5656, -2866, 1384.381), Rotation(-90, 0, -0), optsDefend_and_Sniper_SO),

	--Elevator spawns
	Eclipse.mission_elements.gen_dummy(400061, "dozer_elevator_1", Vector3(-2350, -3627, 375), Rotation(90, -0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400062, "taser_elevator_1", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400063, "taser_elevator_2", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsTaser),

	--Respawns
	Eclipse.mission_elements.gen_dummytrigger(400064, "respawn_taser_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsrespawn_taser_1),
	Eclipse.mission_elements.gen_dummytrigger(400065, "respawn_taser_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsrespawn_taser_2),
	Eclipse.mission_elements.gen_dummytrigger(400082, "respawn_shield_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsrespawn_shield_1),
	Eclipse.mission_elements.gen_dummytrigger(400083, "respawn_shield_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsrespawn_shield_2),
	Eclipse.mission_elements.gen_dummytrigger(400084, "respawn_shield_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsrespawn_shield_3),
	Eclipse.mission_elements.gen_dummytrigger(400085, "respawn_shield_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsrespawn_shield_4),

	--Helipad blockade
	Eclipse.mission_elements.gen_dummy(400066, "dozer_helipad_1", Vector3(-6327, -1493, 1175), Rotation(0, 0, -0), optsBulldozer_helipad),
	Eclipse.mission_elements.gen_dummy(400067, "shield_helipad_1", Vector3(-6333, -1457, 1175), Rotation(0, 0, -0), optsShield_helipad_1),
	Eclipse.mission_elements.gen_dummy(400068, "shield_helipad_2", Vector3(-6333, -1521, 1175), Rotation(0, 0, -0), optsShield_helipad_2),
	Eclipse.mission_elements.gen_so(400069, "dozer_helipad_so", Vector3(-5122, -1505, 1174.972), Rotation(-90, 0, -0), optsDefendDozer_SO),
	Eclipse.mission_elements.gen_so(400070, "shield_helipad_so_1", Vector3(-6095, -1565, 1382.926), Rotation(-90, 0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400071, "shield_helipad_so_2", Vector3(-6095, -1484, 1380.926), Rotation(-90, 0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_dummy(400072, "sniper_atrium_1", Vector3(-4164, -3636, 376.151), Rotation(-90, 0, -0), optsSniper_1),
	Eclipse.mission_elements.gen_dummy(400073, "sniper_atrium_2", Vector3(-4164, -3636, 376.151), Rotation(-90, 0, -0), optsSniper_2),
	Eclipse.mission_elements.gen_so(400074, "sniper_atrium_so_1", Vector3(-3478, -2413, 379.754), Rotation(0, 0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_so(400075, "sniper_atrium_so_2", Vector3(-2964, -2366, 379.754), Rotation(0, 0, -0), optsDefend_and_Sniper_SO),
	Eclipse.mission_elements.gen_toggleelement(400076, "enable_snipers", enable_snipers),
	Eclipse.mission_elements.gen_toggleelement(400077, "disable_snipers", disable_snipers),
	Eclipse.mission_elements.gen_so(400078, "cloaker_hunt_so", Vector3(-100, -1903, 1175), Rotation(90, -0, -0), optsCloaker_SO),
	Eclipse.mission_elements.gen_smokegrenade(400079, "smoke_grenade_1", Vector3(-2358, -4657, 21.226), Rotation(0, 0, -0), Smoke_bomb),
	Eclipse.mission_elements.gen_smokegrenade(400080, "smoke_grenade_2", Vector3(-3291, -4657, 21.226), Rotation(0, 0, -0), Smoke_bomb),
	Eclipse.mission_elements.gen_smokegrenade(400081, "smoke_grenade_3", Vector3(-4283, -4657, 21.226), Rotation(0, 0, -0), Smoke_bomb),

	-- GenSec Security that tries to defend the CFO
	-- left spawn
	Eclipse.mission_elements.gen_dummy(400086, "gensec_1", Vector3(-596.422, -3435.197, 775.001), Rotation(-90, 0, 0), optsSecret_Service_1),
	Eclipse.mission_elements.gen_dummy(400087, "gensec_2", Vector3(-682.057, -3433.874, 775.001), Rotation(-90, 0, 0), optsSecret_Service_2),
	Eclipse.mission_elements.gen_so(400088, "gensec_so_1", Vector3(-429, -3406, 775.001), Rotation(15, 0, 0), optsSecret_Service_Defend),
	Eclipse.mission_elements.gen_so(400089, "gensec_so_2", Vector3(-498.168, -3425.772, 775.001), Rotation(-15, 0, 0), optsSecret_Service_Defend),

	-- middle spawn
	Eclipse.mission_elements.gen_dummy(400090, "gensec_3", Vector3(-5191, -1548, 375), Rotation(180, 0, 0), optsSecret_Service_3),
	Eclipse.mission_elements.gen_dummy(400091, "gensec_4", Vector3(-5191, -1622, 375), Rotation(180, 0, 0), optsSecret_Service_4),
	Eclipse.mission_elements.gen_so(400092, "gensec_so_3", Vector3(-5192.193, -2000.666, 375), Rotation(-103, 0, 0), optsSecret_Service_Defend),
	Eclipse.mission_elements.gen_so(400093, "gensec_so_4", Vector3(-5190.011, -2071.920, 375), Rotation(-83, 0, 0), optsSecret_Service_Defend),

	-- right spawn
	Eclipse.mission_elements.gen_dummy(400094, "gensec_5", Vector3(-4948, 950, 375), Rotation(0, 0, 0), optsSecret_Service_5),

	-- upper middle spawn
	Eclipse.mission_elements.gen_dummy(410002, "gensec_6", Vector3(-5397, -2171, 775.001), Rotation(-90, 0, 0), optsSecret_Service_9),
	Eclipse.mission_elements.gen_dummy(410003, "gensec_7", Vector3(-5397, -2055, 775.001), Rotation(-90, 0, 0), optsSecret_Service_10),
	Eclipse.mission_elements.gen_so(410004, "gensec_so_6", Vector3(-5116, -2186, 775.001), Rotation(-90, 0, 0), optsSecret_Service_Defend),
	Eclipse.mission_elements.gen_so(410005, "gensec_so_7", Vector3(-5116, -2125, 775.001), Rotation(-90, 0, 0), optsSecret_Service_Defend),
	
	-- change bag requirments
	Eclipse.mission_elements.gen_instance_params(410006, "new_bag_requirment", Vector3(0, 0, 0), Rotation(0, 0, 0), optsinstance_bag_requirment),

	-- Scripted difficulty steps
	Eclipse.mission_elements.gen_difficulty(410007, "dah_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(410008, "dah_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),

	-- New Cloakers and their hiding spots
	-- hiding spots
	Eclipse.mission_elements.gen_so(500000, "cloaker_hide_so_1", Vector3(-2776.723, -1203.596, 25), Rotation(150, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500001, "cloaker_hide_so_2", Vector3(-3749, -2069, 25), Rotation(-76, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500002, "cloaker_hide_so_3", Vector3(-1420, -3400, 375), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500003, "cloaker_hide_so_4", Vector3(-1600, -3636, 1175), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500004, "cloaker_hide_so_5", Vector3(-6063.537, 1050, 1175), Rotation(-69, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500005, "cloaker_hide_so_6", Vector3(-759, -1983, 1189.552), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500006, "cloaker_hide_so_7", Vector3(-5812, -946, 1175), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500007, "cloaker_hide_so_8", Vector3(-6417, -1059, 375), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500008, "cloaker_hide_so_9", Vector3(-5179, 981, 375), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500009, "cloaker_hide_so_10", Vector3(-1302, -2373, 375), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500010, "cloaker_hide_so_11", Vector3(-1258, -3400, 775), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500011, "cloaker_hide_so_12", Vector3(-3673.987, -4308.075, 375), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500012, "cloaker_hide_so_13", Vector3(-4623, -5183, 375), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500013, "cloaker_hide_so_14", Vector3(-3538.467, -5094.376, 775), Rotation(82, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500014, "cloaker_hide_so_15", Vector3(-375, -1107, 375), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500015, "cloaker_hide_so_16", Vector3(-1425, -3087, 375), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500016, "cloaker_hide_so_17", Vector3(-591, -2672, 375), Rotation(-159, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(500017, "cloaker_hide_so_18", Vector3(-2584.092, -2750.129, 375), Rotation(-159, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(500018, "cloaker_hide_so_19", Vector3(-4647, -2987, 375), Rotation(-53, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500019, "cloaker_hide_so_20", Vector3(-5912.033, -2100, 375), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500020, "cloaker_hide_so_21", Vector3(-4412.543, 830.748, 375), Rotation(71, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500021, "cloaker_hide_so_22", Vector3(-2024.121, -1842.879, 375), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500022, "cloaker_hide_so_23", Vector3(-106.016, -1844.907, 375), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500023, "cloaker_hide_so_24", Vector3(-2377, -4216, 375), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500024, "cloaker_hide_so_25", Vector3(-3438, -3679, 775), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500025, "cloaker_hide_so_26", Vector3(-4966, -1882, 775), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500026, "cloaker_hide_so_27", Vector3(-5829, -1350, 775), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(500027, "cloaker_hide_so_28", Vector3(-5366, -2954, 775), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500028, "cloaker_hide_so_29", Vector3(-2478.271, -2449.929, 777.027), Rotation(74, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500029, "cloaker_hide_so_30", Vector3(-2144.195, -1856.404, 777.027), Rotation(-12, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500030, "cloaker_hide_so_31", Vector3(-2811.575, -2682.705, 387.027), Rotation(154, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(500031, "cloaker_hide_so_32", Vector3(-4985, -1797, 775), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_2),
	-- cloakers
	Eclipse.mission_elements.gen_dummy(500032, "cloaker_spawn_1", Vector3(-6527.470, -5336.641, 1175), Rotation(-38, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500033, "cloaker_spawn_2", Vector3(-6311, 1444, 1175), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500034, "cloaker_spawn_3", Vector3(-4614, 1444, 1175), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500035, "cloaker_spawn_4", Vector3(-2005, 1444, 1175), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500036, "cloaker_spawn_5", Vector3(-331, 1444, 1175), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500037, "cloaker_spawn_6", Vector3(-91, -3286, 1175), Rotation(90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(500038, "cloaker_spawn_7", Vector3(-4164, -3636, 376.151), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_3),
	Eclipse.mission_elements.gen_dummy(500039, "cloaker_spawn_8", Vector3(-5398.913, -4430.995, 375), Rotation(85, 0, 0), optsBesiegeDummyCloaker_4),
	Eclipse.mission_elements.gen_dummy(500040, "cloaker_spawn_9", Vector3(-1490, 1471, 375), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_5),
	Eclipse.mission_elements.gen_dummy(500041, "cloaker_spawn_10", Vector3(-5111, 1487, 375), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_5),
	Eclipse.mission_elements.gen_dummy(500042, "cloaker_spawn_11", Vector3(-6559, -2547, 775), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_5),
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(500043, "dah_cloaker_spawngroup_01", { 500032 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500044, "dah_cloaker_spawngroup_02", { 500033 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500045, "dah_cloaker_spawngroup_03", { 500034 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500046, "dah_cloaker_spawngroup_04", { 500035 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500047, "dah_cloaker_spawngroup_05", { 500036 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500048, "dah_cloaker_spawngroup_06", { 500037 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500049, "dah_cloaker_spawngroup_07", { 500038 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500050, "dah_cloaker_spawngroup_08", { 500039 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500051, "dah_cloaker_spawngroup_09", { 500040 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500052, "dah_cloaker_spawngroup_10", { 500041 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500053, "dah_cloaker_spawngroup_11", { 500042 }, 0),
	-- spawn events for spoocs
	Eclipse.mission_elements.gen_dummytrigger(500054, "spooc_spawned_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_1),
	Eclipse.mission_elements.gen_dummytrigger(500055, "spooc_spawned_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_2),
	Eclipse.mission_elements.gen_dummytrigger(500055, "spooc_spawned_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_3),
	Eclipse.mission_elements.gen_dummytrigger(500056, "spooc_spawned_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsspooc_spawned_4),
	Eclipse.mission_elements.gen_object_editor(500057, "destroy_the_glass_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDestroyTheGlass_1),
	Eclipse.mission_elements.gen_object_editor(500058, "destroy_the_glass_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDestroyTheGlass_2),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(500059, "dah_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_sogroup(500060, "dah_cloaker_hide_group", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup),
	Eclipse.mission_elements.gen_missionscript(500061, "dah_cloaker_spawn_global", optsAddCloakerHideGroup),
	Eclipse.mission_elements.gen_global_event(500062, "dah_assault_start", Vector3(0, 0, 0), Rotation(0, 0, 0), optsAssaultStarted),
}

return M
