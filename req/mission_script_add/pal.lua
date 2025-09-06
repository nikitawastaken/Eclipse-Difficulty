---@module Counterfeit
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local enabled_chance_elite_shield_blockade = math.random() <= 0.2 + (is_pro_job and 0.2 or 0)

local sniper = scripted_enemy.sniper
local taser = scripted_enemy.taser_1
local elite_shield = scripted_enemy.elite_shield

local overkill_above = diff_i >= 5

local optsSniper_1 = {
	enemy = sniper,
	on_executed = {
		{ id = 100675, delay = 0 },
		{ id = 100675, delay = 30 },
		{ id = 100675, delay = 60 },
	},
	enabled = true,
}
local optsSniper_2 = {
	enemy = sniper,
	on_executed = {
		{ id = 400006, delay = 0 },
		{ id = 400006, delay = 30 },
		{ id = 400006, delay = 60 },
	},
	enabled = true,
}
local optsSniper_3 = {
	enemy = sniper,
	on_executed = {
		{ id = 400007, delay = 0 },
		{ id = 400007, delay = 30 },
		{ id = 400007, delay = 60 },
	},
	enabled = overkill_above,
}
local optsSniper_4 = {
	enemy = sniper,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = {
		{ id = 400008, delay = 0 },
		{ id = 400008, delay = 30 },
		{ id = 400008, delay = 60 },
	},
	enabled = overkill_above,
}
local optsSniper_5 = {
	enemy = sniper,
	spawn_action = "e_sp_up_2_75_down_1_25m",
	on_executed = {
		{ id = 400009, delay = 0 },
	},
	enabled = is_eclipse,
}
local optsTaserDefend_1 = {
	enemy = taser,
	on_executed = {
		{ id = 400021, delay = 0 },
	},
	enabled = is_eclipse,
}
local optsTaserDefend_2 = {
	enemy = taser,
	on_executed = {
		{ id = 400022, delay = 0 },
	},
	enabled = is_eclipse,
}
local optsTaserDefend_3 = {
	enemy = taser,
	on_executed = {
		{ id = 400023, delay = 0 },
	},
	enabled = is_eclipse,
}
local optsTaserDefend_4 = {
	enemy = taser,
	on_executed = {
		{ id = 400024, delay = 0 },
	},
	enabled = is_eclipse,
}
local optsShieldDefend_1 = {
	enemy = elite_shield,
	spawn_action = "e_sp_repel_into_window",
	on_executed = {
		{ id = 400033, delay = 0 },
	},
	enabled = is_eclipse and enabled_chance_elite_shield_blockade,
}
local optsShieldDefend_2 = {
	enemy = elite_shield,
	spawn_action = "e_sp_repel_into_window",
	on_executed = {
		{ id = 400034, delay = 0 },
	},
	enabled = is_eclipse and enabled_chance_elite_shield_blockade,
}
local optsShieldDefend_3 = {
	enemy = elite_shield,
	spawn_action = "e_sp_repel_into_window",
	on_executed = {
		{ id = 400035, delay = 0 },
	},
	enabled = is_eclipse and enabled_chance_elite_shield_blockade,
}
local optsReachedNearLeftPipeTrigger = {
	enabled = true,
	on_executed = {
		{ id = 400027, delay = 0 },
		{ id = 400028, delay = 0.5 },
		{ id = 400029, delay = 1 },
	},
}

local optsrespawn_sniper_1 = {
	on_executed = {
		{ id = 400001, delay = is_eclipse and 60 or 90, delay_rand = 30 },
	},
	elements = {
		400001,
	},
	event = "death",
}
local optsrespawn_sniper_2 = {
	on_executed = {
		{ id = 400002, delay = is_eclipse and 60 or 90, delay_rand = 30 },
	},
	elements = {
		400002,
	},
	event = "death",
}
local optsrespawn_sniper_3 = {
	on_executed = {
		{ id = 400003, delay = is_eclipse and 60 or 90, delay_rand = 30 },
	},
	elements = {
		400003,
	},
	event = "death",
}
local optsrespawn_sniper_4 = {
	on_executed = {
		{ id = 400004, delay = is_eclipse and 60 or 90, delay_rand = 30 },
	},
	elements = {
		400004,
	},
	event = "death",
}
local optsrespawn_sniper_5 = {
	on_executed = {
		{ id = 400005, delay = is_eclipse and 60 or 90, delay_rand = 30 },
	},
	elements = {
		400005,
	},
	event = "death",
}
local optsSniper_SO = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsShield_SO = {
	SO_access = "2048",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsTaser_SO = {
	SO_access = "8192",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local disable_2nd_police_cruiser = {
	enabled = true,
	toggle = "off",
	elements = {
		100704,
	},
}
local Bain_sendsnipers = {
	dialogue = "play_pln_gen_snip_01",
}
local Bain_swats_from_keel_street = {
	dialogue = "Play_pln_pal_45",
}
local Bain_swats_from_beach = {
	dialogue = "Play_pln_pal_46",
}
local Bain_swats_from_hills = {
	dialogue = "Play_pln_pal_47",
}
local Bain_swats_from_pacific_drive = {
	dialogue = "Play_pln_pal_48",
}

local optsChopperMitchell_fix = {
	enabled = true,
	trigger_times = 1,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "heli_street_seventh_flyin", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "open_door_left", time = 13 },
		{ id = 4, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "open_door_right", time = 13 },
		{ id = 5, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "close_door_left", time = 22 },
		{ id = 6, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "close_door_right", time = 22 },
		{ id = 7, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "heli_street_seventh_flyout", time = 26 },
		{ id = 8, name = "run_sequence", notify_unit_id = 100000, notify_unit_sequence = "hidden", time = 40 },
	},
	on_executed = {
		{ id = 101713, delay = 13 },
	},
}
local optsChopperWilson_fix = {
	enabled = true,
	trigger_times = 1,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102724, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 102724, notify_unit_sequence = "heli_suburbia_flyin", time = 0 },
	},
	on_executed = {
		{ id = 101712, delay = 11.5 },
		{ id = 101758, delay = 0 },
		{ id = 102363, delay = 8 },
		{ id = 101715, delay = 0 },
	},
}
local optsChopperWilson_stop_sound_fix = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102724, notify_unit_sequence = "hidden", time = 0 },
	},
}
local optsChopperPool_fix = {
	enabled = true,
	trigger_times = 1,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100719, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100719, notify_unit_sequence = "heli_street_fourth_flyin", time = 0 },
	},
	on_executed = {
		{ id = 101714, delay = 13 },
		{ id = 101760, delay = 0 },
		{ id = 100792, delay = 8 },
		{ id = 101715, delay = 0 },
	},
}
local optsChopperPool_stop_sound_fix = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100719, notify_unit_sequence = "hidden", time = 0 },
	},
}
local disable_the_pool_chopper = {
	enabled = true,
	toggle = "off",
	elements = {
		400041,
	},
}
local enable_the_pool_chopper = {
	enabled = true,
	elements = {
		400041,
	},
}

local pick_a_swat_van = {
	amount = 1,
	on_executed = {
		{ id = 400051, delay = 0 },
		{ id = 400052, delay = 0 },
		{ id = 400053, delay = 0 },
		{ id = 400054, delay = 0 },
	},
}
local swat_van_response_variant_1 = {
	on_executed = { { id = 100714, delay = 0 }, { id = 100713, delay = 180, delay_rand = 30 }, { id = 100715, delay = 300, delay_rand = 30 }, { id = 100720, delay = 420, delay_rand = 30 } },
	enabled = true,
}
local swat_van_response_variant_2 = {
	on_executed = { { id = 100720, delay = 0 }, { id = 100715, delay = 180, delay_rand = 30 }, { id = 100713, delay = 300, delay_rand = 30 }, { id = 100714, delay = 420, delay_rand = 30 } },
	enabled = true,
}
local swat_van_response_variant_3 = {
	on_executed = { { id = 100715, delay = 0 }, { id = 100720, delay = 180, delay_rand = 30 }, { id = 100714, delay = 300, delay_rand = 30 }, { id = 100713, delay = 420, delay_rand = 30 } },
	enabled = true,
}
local swat_van_response_variant_4 = {
	on_executed = { { id = 100713, delay = 0 }, { id = 100714, delay = 180, delay_rand = 30 }, { id = 100720, delay = 300, delay_rand = 30 }, { id = 100715, delay = 420, delay_rand = 30 } },
	enabled = true,
}
local optsPreferedAdd1 = {
	spawn_groups = { 100441, 100473 },
	enabled = true,
}
local optsPreferedRemove1 = {
	elements = { 400055 },
	enabled = true,
}

M.elements = {
	--Snipers
	Eclipse.mission_elements.gen_dummy(400001, "sniper_1", Vector3(4082, 2186, 120.142), Rotation(-180, 0, -0), optsSniper_1),
	Eclipse.mission_elements.gen_dummy(400002, "sniper_2", Vector3(2978, -744, 126.059), Rotation(180, 0, -0), optsSniper_2),
	Eclipse.mission_elements.gen_dummy(400003, "sniper_3", Vector3(-3153, 8429, 26.021), Rotation(90, -0, -0), optsSniper_3),
	Eclipse.mission_elements.gen_dummy(400004, "sniper_4", Vector3(502, -3577, 29.736), Rotation(-167, 0, -0), optsSniper_4),
	Eclipse.mission_elements.gen_dummy(400005, "sniper_5", Vector3(-8202, 1491, 25.860), Rotation(-90, 0, -0), optsSniper_5),
	Eclipse.mission_elements.gen_so(400006, "sniper_spot_so_1", Vector3(-3192, 1184, 517.520), Rotation(0, 0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400007, "sniper_spot_so_2", Vector3(-3328, 3703, 445.786), Rotation(161, 0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400008, "sniper_spot_so_3", Vector3(-1797.890, 1042.875, 415.609), Rotation(46, -0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400009, "sniper_spot_so_4", Vector3(-4513, 384, 500.223), Rotation(0, 0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_dummytrigger(400010, "respawn_sniper_1", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsrespawn_sniper_1),
	Eclipse.mission_elements.gen_dummytrigger(400011, "respawn_sniper_2", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsrespawn_sniper_2),
	Eclipse.mission_elements.gen_dummytrigger(400012, "respawn_sniper_3", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsrespawn_sniper_3),
	Eclipse.mission_elements.gen_dummytrigger(400013, "respawn_sniper_4", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsrespawn_sniper_4),
	Eclipse.mission_elements.gen_dummytrigger(400014, "respawn_sniper_5", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsrespawn_sniper_5),
	Eclipse.mission_elements.gen_dialogue(400016, "they_sending_snipers", Bain_sendsnipers),
	-- Tasers near manhole
	Eclipse.mission_elements.gen_dummy(400017, "taser_defend_1", Vector3(-5536, -3189, 30.090), Rotation(90, -0, -0), optsTaserDefend_1),
	Eclipse.mission_elements.gen_dummy(400018, "taser_defend_2", Vector3(-5536, -3129, 30.090), Rotation(90, -0, -0), optsTaserDefend_2),
	Eclipse.mission_elements.gen_dummy(400019, "taser_defend_3", Vector3(3052, -685, 130.921), Rotation(-180, 0, -0), optsTaserDefend_3),
	Eclipse.mission_elements.gen_dummy(400020, "taser_defend_4", Vector3(3121, -685, 130.921), Rotation(-180, -0, -0), optsTaserDefend_4),
	Eclipse.mission_elements.gen_so(400021, "taser_spot_so_1", Vector3(-5995, -349, 26.200), Rotation(-90, 0, -0), optsTaser_SO),
	Eclipse.mission_elements.gen_so(400022, "taser_spot_so_2", Vector3(-5995, -455, 26.200), Rotation(-90, 0, -0), optsTaser_SO),
	Eclipse.mission_elements.gen_so(400023, "taser_spot_so_3", Vector3(-796.150, 12.669, 31.663), Rotation(50, -0, -0), optsTaser_SO),
	Eclipse.mission_elements.gen_so(400024, "taser_spot_so_4", Vector3(-863, -67, 31.663), Rotation(50, 0, -0), optsTaser_SO),
	-- Elite shields in the sewers event
	Eclipse.mission_elements.gen_areatrigger(400025, "area_trigger_near_left_pipe", Vector3(-4195, -3345, -417.586), Rotation(0, 0, -0), optsReachedNearLeftPipeTrigger),
	Eclipse.mission_elements.gen_dummy(400027, "shield_defend_1", Vector3(-6080, -4164, -376.695), Rotation(0, 0, -0), optsShieldDefend_1),
	Eclipse.mission_elements.gen_dummy(400028, "shield_defend_2", Vector3(-6080, -4164, -376.695), Rotation(0, 0, -0), optsShieldDefend_2),
	Eclipse.mission_elements.gen_dummy(400029, "shield_defend_3", Vector3(-6080, -4164, -376.695), Rotation(0, 0, -0), optsShieldDefend_3),
	Eclipse.mission_elements.gen_so(400033, "shield_spot_so_1", Vector3(-5865, -4211, -370.985), Rotation(-90, 0, -0), optsShield_SO),
	Eclipse.mission_elements.gen_so(400034, "shield_spot_so_2", Vector3(-5865, -4076, -386.985), Rotation(-90, 0, -0), optsShield_SO),
	Eclipse.mission_elements.gen_so(400035, "shield_spot_so_3", Vector3(-5865, -3949, -366.985), Rotation(-90, 0, -0), optsShield_SO),
	-- misc
	Eclipse.mission_elements.gen_toggleelement(400015, "disable_the_cruiser", disable_2nd_police_cruiser),
	Eclipse.mission_elements.gen_object_editor(400039, "mitchell_chopper_fix", Vector3(-803, -1370, 3449.999), Rotation(-90, 0, -0), optsChopperMitchell_fix),
	Eclipse.mission_elements.gen_object_editor(400040, "wilson_chopper_fix", Vector3(-803, -1370, 3449.999), Rotation(-90, 0, -0), optsChopperWilson_fix),
	Eclipse.mission_elements.gen_object_editor(400041, "pool_chopper_fix", Vector3(-803, -1370, 3449.999), Rotation(-90, 0, -0), optsChopperPool_fix),
	Eclipse.mission_elements.gen_object_editor(400042, "wilson_chopper_sound_fix", Vector3(-803, -1370, 3449.999), Rotation(-90, 0, -0), optsChopperWilson_stop_sound_fix),
	Eclipse.mission_elements.gen_object_editor(400043, "pool_chopper_sound_fix", Vector3(-803, -1370, 3449.999), Rotation(-90, 0, -0), optsChopperPool_stop_sound_fix),
	Eclipse.mission_elements.gen_toggleelement(400044, "disable_the_pool_chopper", disable_the_pool_chopper),
	Eclipse.mission_elements.gen_toggleelement(400045, "enable_the_pool_chopper", enable_the_pool_chopper),
	Eclipse.mission_elements.gen_dialogue(400046, "swats_keel_street", Bain_swats_from_keel_street),
	Eclipse.mission_elements.gen_dialogue(400047, "swats_beach", Bain_swats_from_beach),
	Eclipse.mission_elements.gen_dialogue(400048, "swats_hills", Bain_swats_from_hills),
	Eclipse.mission_elements.gen_dialogue(400049, "swats_pacific_drive", Bain_swats_from_pacific_drive),
	Eclipse.mission_elements.gen_element_random(400050, "begin_swat_vans", pick_a_swat_van),
	Eclipse.mission_elements.gen_missionscript(400051, "swat_van_response_1", swat_van_response_variant_1),
	Eclipse.mission_elements.gen_missionscript(400052, "swat_van_response_2", swat_van_response_variant_2),
	Eclipse.mission_elements.gen_missionscript(400053, "swat_van_response_3", swat_van_response_variant_3),
	Eclipse.mission_elements.gen_missionscript(400054, "swat_van_response_4", swat_van_response_variant_4),
	Eclipse.mission_elements.gen_preferedadd(400055, "beach_preferredadd", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedremove(400056, "beach_preferedremove", optsPreferedRemove1),
}

return M
