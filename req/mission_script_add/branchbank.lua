---@module Bank Heist
local M = {}

local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()
local level_id = Eclipse.utils.level_id()
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy

local ambush_event_chance = (is_eclipse and 40 or 20) + (is_pro_job and 10 or 0)

local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local shield = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield
local taser = scripted_enemy.taser_1
local medic = diff_i < 4 and scripted_enemy.taser_1 or scripted_enemy.medic_1
local elite_bulldozer_skull = scripted_enemy.elite_bulldozer_2
local elite_bulldozer_neil = scripted_enemy.elite_bulldozer_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local cloaker = scripted_enemy.cloaker

local swats = { [swat_1] = 2, [swat_2] = 1 }

local specials_list_eclipse = { [taser] = 5, [medic] = 5, [cloaker] = 4, [elite_bulldozer_neil] = 1, [elite_bulldozer_skull] = 1 }
local specials_list_hard_ovk = { [taser] = 5, [medic] = 5, [cloaker] = 4, [green_bulldozer] = 1, [black_bulldozer] = 1 }
local specials_list_easy_normal = { [taser] = 6, [cloaker] = 1 }
local specials = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse

local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_bulldozer_neil,
	elite_bulldozer_skull,
}
local optsBulldozer = {
	enemy = elite_bulldozer_skull,
	on_executed = {
		{ id = 400002, delay = 0 },
	},
}
local optsDefend_SO = {
	SO_access = "4096",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsDisable_DWDozer = {
	toggle = "off",
	enabled = true,
	elements = {
		400001,
	},
}
local optsEnable_DWDozer = {
	enabled = is_eclipse,
	elements = {
		400001,
	},
}
local optsSWAT = {
	enemy_table = swats,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsMedic = {
	enemy = medic,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsDozer = {
	enemy = is_eclipse and elite_bulldozer_neil or green_bulldozer,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsCloaker = {
	enemy = cloaker,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsTaser = {
	enemy = taser,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsShield = {
	enemy = shield,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsSWAT_heli = {
	enemy_table = swats,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsTaser_heli = {
	enemy = taser,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsSpecial_heli = {
	enemy_table = specials,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsDozerChopper_1 = {
	enemy = elite_bulldozer_neil,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400019, delay = 0 }, { id = 400023, delay = 0 }, { id = 400022, delay = 3 }, { id = 400022, delay = 3.5 } },
	enabled = true,
}
local optsDozerChopper_2 = {
	enemy = elite_bulldozer_skull,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsDozerAmbush = {
	enemy_table = is_eclipse and random_elite_dozers or random_dozers,
	enabled = true,
}
local optsCloakerAmbush = {
	enemy = cloaker,
	enabled = true,
}
local optsTaserAmbush = {
	enemy = taser,
	enabled = true,
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 105216, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 105081, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsBreak_The_Glass = {
	enabled = true,
	trigger_times = 1,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101795, notify_unit_sequence = "shatter", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		--	{ id = 400005, delay = 0 },
		{ id = 400006, delay = 0 },
		--	{ id = 400007, delay = 0 },
		{ id = 400008, delay = 0 },
		{ id = 400009, delay = 0 },
		{ id = 400011, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		--	{ id = 400012, delay = 0 },
		{ id = 400013, delay = 0 },
		--	{ id = 400014, delay = 0 },
		{ id = 400015, delay = 0 },
		{ id = 400016, delay = 0 },
		{ id = 400018, delay = 0 },
	},
	enabled = true,
}
local optsspawndozerchopper = {
	on_executed = { { id = 400020, delay = 26 }, { id = 400021, delay = 26 }, { id = 400024, delay = 0 } },
	enabled = is_eclipse,
}
local optsspawnswatchopper_1 = {
	on_executed = { { id = 400026, delay = 26 }, { id = 400027, delay = 26 }, { id = 400028, delay = 26 }, { id = 400029, delay = 26 }, { id = 400030, delay = 0 } },
	enabled = true,
}
local optsspawnswatchopper_2 = {
	on_executed = { { id = 400032, delay = 26 }, { id = 400033, delay = 26 }, { id = 400034, delay = 26 }, { id = 400035, delay = 26 }, { id = 400036, delay = 0 } },
	enabled = true,
}
local optsHuntSO = {
	SO_access = tostring(128 + 1024 + 2048 + 4096 + 8192),
	path_style = "none",
	scan = true,
	so_action = "AI_hunt",
}

local Smoke_bomb = {
	duration = 12,
}

local ambush_event_global = {
	enabled = (ambush_event_chance and hard_and_above and level_id == "firestarter_3") and true or false,
	on_executed = { { id = 400067, delay = 0 }, { id = 400069, delay = 0 } },
}
local optsEnable_ambush = {
	enabled = level_id == "firestarter_3" and true or false,
	elements = {
		400068,
	},
}
local optsEnable_ambush_alarm = {
	elements = {
		400055,
		400056,
	},
}
local optsdisable_locked_vault_door = {
	enabled = level_id == "firestarter_3" and true or false,
	toggle = "off",
	elements = {
		100197,
		100198,
		102716,
		102717,
	},
}
local optsdisable_dozer_chopper = {
	enabled = is_eclipse,
	elements = {
		400025,
	},
}
local optsenable_dozer_chopper = {
	enabled = is_eclipse,
	toggle = "off",
	elements = {
		400025,
	},
}
local Smoke_bomb_ambush = {
	duration = 7,
}
local begin_ambush_event_left = {
	on_executed = { { id = 400057, delay = 2 }, { id = 400070, delay = 2.5 } },
}
local begin_ambush_event_right = {
	on_executed = { { id = 400058, delay = 2 }, { id = 400071, delay = 2.5 } },
}
local left_ambush_amount = {
	amount = 1,
	on_executed = {
		{ id = 400059, delay = 0 },
		{ id = 400060, delay = 0 },
		{ id = 400061, delay = 0 },
		{ id = 400062, delay = 0 },
	},
}
local right_ambush_amount = {
	amount = 1,
	on_executed = {
		{ id = 400063, delay = 0 },
		{ id = 400064, delay = 0 },
		{ id = 400065, delay = 0 },
		{ id = 400066, delay = 0 },
	},
}
local three_cloakers_left = {
	on_executed = { { id = 400045, delay = 0 }, { id = 400046, delay = 0 }, { id = 400047, delay = 0 } },
	enabled = true,
}
local two_dozers_left = {
	on_executed = { { id = 400040, delay = 0 }, { id = 400041, delay = 0 } },
	enabled = true,
}
local taser_dozer_left = {
	on_executed = { { id = 400041, delay = 0 }, { id = 400042, delay = 0 } },
	enabled = true,
}
local cloaker_dozer_left = {
	on_executed = { { id = 400041, delay = 0 }, { id = 400044, delay = 0 } },
	enabled = true,
}
local three_cloakers_right = {
	on_executed = { { id = 400052, delay = 0 }, { id = 400053, delay = 0 }, { id = 400054, delay = 0 } },
	enabled = true,
}
local two_dozers_right = {
	on_executed = { { id = 400048, delay = 0 }, { id = 400049, delay = 0 } },
	enabled = true,
}
local taser_dozer_right = {
	on_executed = { { id = 400049, delay = 0 }, { id = 400050, delay = 0 } },
	enabled = true,
}
local cloaker_dozer_right = {
	on_executed = { { id = 400049, delay = 0 }, { id = 400051, delay = 0 } },
	enabled = true,
}

local optsDozerChopper = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100004, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100004, notify_unit_sequence = "redi_flyin_left", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100004, notify_unit_sequence = "open_door_left", time = 24 },
		{ id = 4, name = "run_sequence", notify_unit_id = 100004, notify_unit_sequence = "open_door_right", time = 24 },
		{ id = 5, name = "run_sequence", notify_unit_id = 100004, notify_unit_sequence = "close_door_left", time = 36 },
		{ id = 6, name = "run_sequence", notify_unit_id = 100004, notify_unit_sequence = "close_door_right", time = 36 },
		{ id = 7, name = "run_sequence", notify_unit_id = 100004, notify_unit_sequence = "redi_hover_flyout", time = 39 },
		{ id = 8, name = "run_sequence", notify_unit_id = 100004, notify_unit_sequence = "hidden", time = 65 },
	},
}

local optsSWATChopper_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100006, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100006, notify_unit_sequence = "flyin_fwd_hover", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100006, notify_unit_sequence = "open_door_left", time = 24 },
		{ id = 4, name = "run_sequence", notify_unit_id = 100006, notify_unit_sequence = "open_door_right", time = 24 },
		{ id = 5, name = "run_sequence", notify_unit_id = 100006, notify_unit_sequence = "close_door_left", time = 36 },
		{ id = 6, name = "run_sequence", notify_unit_id = 100006, notify_unit_sequence = "close_door_right", time = 36 },
		{ id = 7, name = "run_sequence", notify_unit_id = 100006, notify_unit_sequence = "hover_flyout_right", time = 39 },
		{ id = 8, name = "run_sequence", notify_unit_id = 100006, notify_unit_sequence = "hidden", time = 65 },
	},
}

local optsSWATChopper_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100021, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100021, notify_unit_sequence = "redi_flyin_left", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100021, notify_unit_sequence = "open_door_left", time = 24 },
		{ id = 4, name = "run_sequence", notify_unit_id = 100021, notify_unit_sequence = "open_door_right", time = 24 },
		{ id = 5, name = "run_sequence", notify_unit_id = 100021, notify_unit_sequence = "close_door_left", time = 36 },
		{ id = 6, name = "run_sequence", notify_unit_id = 100021, notify_unit_sequence = "close_door_right", time = 36 },
		{ id = 7, name = "run_sequence", notify_unit_id = 100021, notify_unit_sequence = "hover_flyout_right", time = 39 },
		{ id = 8, name = "run_sequence", notify_unit_id = 100021, notify_unit_sequence = "hidden", time = 65 },
	},
}
--[[
local optsCallSwatVans = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 104732, notify_unit_sequence = "anim_police_responce", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100214, notify_unit_sequence = "anim_police_responce", time = 10 },
	},
}
local optsSwatVans_trigger = {
	on_executed = { { id = 400038, delay = 0 } },
	enabled = level_id ~= "firestarter_3" and true or false,
}
]]
--

M.elements = {
	-- skulldozer nearby the van on Eclipse (based on DW Trailer)
	Eclipse.mission_elements.gen_dummy(400001, "van_dozer", Vector3(-8305, -3511, 0), Rotation(-90, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_so(400002, "dozer_defend_so", Vector3(-7273, -2895, -19.999), Rotation(0, 0, -0), optsDefend_SO),
	Eclipse.mission_elements.gen_toggleelement(400003, "enable_dozervan", optsEnable_DWDozer),
	Eclipse.mission_elements.gen_toggleelement(400004, "disable_dozervan", optsDisable_DWDozer),

	-- swat van 1
	Eclipse.mission_elements.gen_dummy(400005, "swat_van_spawn_1", Vector3(-110, -1023, -19.999), Rotation(-84, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400006, "swat_van_spawn_2", Vector3(-114.599, -979.241, -19.999), Rotation(-84, 0, 0), optsMedic),
	Eclipse.mission_elements.gen_dummy(400007, "swat_van_spawn_3", Vector3(-118.989, -937.471, -19.999), Rotation(-84, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400008, "swat_van_spawn_4", Vector3(-38.866, -1020.551, -19.999), Rotation(-84, 0, 0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400009, "swat_van_spawn_5", Vector3(-48.378, -930.050, -19.999), Rotation(-84, 0, 0), optsDozer),
	Eclipse.mission_elements.gen_missionscript(400010, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400011, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),

	-- swat van 2
	Eclipse.mission_elements.gen_dummy(400012, "swat_van_spawn_6", Vector3(760, 2587, -19.850), Rotation(16, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400013, "swat_van_spawn_7", Vector3(719.627, 2575.423, -19.850), Rotation(16, 0, 0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400014, "swat_van_spawn_8", Vector3(675.409, 2562.744, -19.850), Rotation(16, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400015, "swat_van_spawn_9", Vector3(748.826, 2636.852, -19.850), Rotation(16, 0, 0), optsShield),
	Eclipse.mission_elements.gen_dummy(400016, "swat_van_spawn_10", Vector3(661.351, 2611.769, -19.850), Rotation(16, 0, 0), optsShield),
	Eclipse.mission_elements.gen_missionscript(400017, "spawn_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400018, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_2),

	Eclipse.mission_elements.gen_so(400019, "hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsHuntSO),

	-- chopper 1
	Eclipse.mission_elements.gen_dummy(400020, "dozer_heli_1", Vector3(-1769, 655, 0), Rotation(-90, 0, 0), optsDozerChopper_1),
	Eclipse.mission_elements.gen_dummy(400021, "dozer_heli_2", Vector3(-1489, 655, 0), Rotation(90, 0, 0), optsDozerChopper_2),
	Eclipse.mission_elements.gen_smokegrenade(400022, "smoke_grenade_heli", Vector3(-1625, 755, 0), Rotation(0, 0, 0), Smoke_bomb),
	Eclipse.mission_elements.gen_object_editor(400023, "shatter_glass", Vector3(0, 0, 0), Rotation(0, 0, 0), optsBreak_The_Glass),
	Eclipse.mission_elements.gen_object_editor(400024, "dozer_heli_sequence", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDozerChopper),
	Eclipse.mission_elements.gen_missionscript(400025, "dozer_heli_event", optsspawndozerchopper),
	Eclipse.mission_elements.gen_toggleelement(400073, "enable_dozer_chopper", optsenable_dozer_chopper),
	Eclipse.mission_elements.gen_toggleelement(400074, "disable_dozer_chopper", optsdisable_dozer_chopper),
	-- chopper 2
	Eclipse.mission_elements.gen_dummy(400026, "swat_heli_1", Vector3(-607, 4091.155, 0), Rotation(137, 0, 0), optsSWAT_heli),
	Eclipse.mission_elements.gen_dummy(400027, "swat_heli_2", Vector3(-534.196, 4022.955, 0), Rotation(137, 0, 0), optsSWAT_heli),
	Eclipse.mission_elements.gen_dummy(400028, "swat_heli_3", Vector3(-793.310, 3894.095, 0), Rotation(-46, 0, 0), optsSWAT_heli),
	Eclipse.mission_elements.gen_dummy(400029, "swat_heli_4", Vector3(-716.203, 3814.249, 0), Rotation(-46, 0, 0), optsTaser_heli),
	Eclipse.mission_elements.gen_object_editor(400030, "swat_heli_sequence_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_1),
	Eclipse.mission_elements.gen_missionscript(400031, "swat_heli_event_1", optsspawnswatchopper_1),
	-- chopper 3
	Eclipse.mission_elements.gen_dummy(400032, "swat_heli_5", Vector3(1061, -934, -19.814), Rotation(0, 0, 0), optsSWAT_heli),
	Eclipse.mission_elements.gen_dummy(400033, "swat_heli_6", Vector3(906, -934, -19.814), Rotation(0, 0, 0), optsSWAT_heli),
	Eclipse.mission_elements.gen_dummy(400034, "swat_heli_7", Vector3(1061, -663, -19.814), Rotation(-180, 0, 0), optsSpecial_heli),
	Eclipse.mission_elements.gen_dummy(400035, "swat_heli_8", Vector3(903, -663, -19.814), Rotation(-180, 0, 0), optsSpecial_heli),
	Eclipse.mission_elements.gen_object_editor(400036, "swat_heli_sequence_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_2),
	Eclipse.mission_elements.gen_missionscript(400037, "swat_heli_event_2", optsspawnswatchopper_2),

	-- old swat vans restoration
	--Eclipse.mission_elements.gen_object_editor(400038, "branchbank_swatvans", Vector3(0, 0, 0), Rotation(0, 0, 0), optsCallSwatVans),
	--Eclipse.mission_elements.gen_missionscript(400039, "deploy_swat_vans", optsSwatVans_trigger),

	-- vault ambush
	-- left
	Eclipse.mission_elements.gen_dummy(400040, "dozer_ambush_left_1", Vector3(-2168, 1941, 0), Rotation(180, 0, 0), optsDozerAmbush),
	Eclipse.mission_elements.gen_dummy(400041, "dozer_ambush_left_2", Vector3(-2245, 1941, 0), Rotation(180, 0, 0), optsDozerAmbush),
	Eclipse.mission_elements.gen_dummy(400042, "taser_ambush_left_1", Vector3(-2168, 1941, 0), Rotation(180, 0, 0), optsTaserAmbush),
	Eclipse.mission_elements.gen_dummy(400044, "cloaker_ambush_left_1", Vector3(-2168, 1941, 0), Rotation(180, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400045, "cloaker_ambush_left_2", Vector3(-2254, 2032, 0), Rotation(180, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400046, "cloaker_ambush_left_3", Vector3(-2195, 2032, 0), Rotation(180, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400047, "cloaker_ambush_left_4", Vector3(-2138, 2032, 0), Rotation(180, 0, 0), optsCloakerAmbush),
	-- right
	Eclipse.mission_elements.gen_dummy(400048, "dozer_ambush_right_1", Vector3(-1930.721, 2145.005, 0), Rotation(-90, 0, 0), optsDozerAmbush),
	Eclipse.mission_elements.gen_dummy(400049, "dozer_ambush_right_2", Vector3(-1933.652, 2228.954, 0), Rotation(-90, 0, 0), optsDozerAmbush),
	Eclipse.mission_elements.gen_dummy(400050, "taser_ambush_right_1", Vector3(-1930.721, 2145.005, 0), Rotation(-90, 0, 0), optsTaserAmbush),
	Eclipse.mission_elements.gen_dummy(400051, "cloaker_ambush_right_1", Vector3(-1930.721, 2145.005, 0), Rotation(-90, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400052, "cloaker_ambush_right_2", Vector3(-2008.708, 2143.282, 0), Rotation(-90, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400053, "cloaker_ambush_right_3", Vector3(-2011.151, 2213.240, 0), Rotation(-90, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400054, "cloaker_ambush_right_4", Vector3(-2014.641, 2273.215, 0), Rotation(-90, 0, 0), optsCloakerAmbush),
	-- random elements
	Eclipse.mission_elements.gen_missionscript(400055, "begin_ambush_left", begin_ambush_event_left),
	Eclipse.mission_elements.gen_missionscript(400056, "begin_ambush_right", begin_ambush_event_right),
	Eclipse.mission_elements.gen_element_random(400057, "left_ambush_select", left_ambush_amount),
	Eclipse.mission_elements.gen_element_random(400058, "right_ambush_select", right_ambush_amount),
	-- left
	Eclipse.mission_elements.gen_missionscript(400059, "three_cloakers", three_cloakers_left),
	Eclipse.mission_elements.gen_missionscript(400060, "two_dozers", two_dozers_left),
	Eclipse.mission_elements.gen_missionscript(400061, "taser_dozer", taser_dozer_left),
	Eclipse.mission_elements.gen_missionscript(400062, "cloaker_dozer", cloaker_dozer_left),
	-- right
	Eclipse.mission_elements.gen_missionscript(400063, "three_cloakers", three_cloakers_right),
	Eclipse.mission_elements.gen_missionscript(400064, "two_dozers", two_dozers_right),
	Eclipse.mission_elements.gen_missionscript(400065, "taser_dozer", taser_dozer_right),
	Eclipse.mission_elements.gen_missionscript(400066, "cloaker_dozer", cloaker_dozer_right),
	-- toggle element
	Eclipse.mission_elements.gen_toggleelement(400067, "enable_ambushes", optsEnable_ambush),
	Eclipse.mission_elements.gen_toggleelement(400068, "enable_ambush_on_alarm", optsEnable_ambush_alarm),
	Eclipse.mission_elements.gen_toggleelement(400069, "disable_locked_vault_door", optsdisable_locked_vault_door),
	-- smoke bombs
	Eclipse.mission_elements.gen_smokegrenade(400070, "smoke_grenade_left", Vector3(-2208, 1742, 0), Rotation(0, 0, 0), Smoke_bomb),
	Eclipse.mission_elements.gen_smokegrenade(400071, "smoke_grenade_right", Vector3(-1760.265, 2207.041, 0), Rotation(0, 0, 0), Smoke_bomb),
	-- chance
	Eclipse.mission_elements.gen_missionscript(400072, "ambush_event", ambush_event_global),
}

return M
