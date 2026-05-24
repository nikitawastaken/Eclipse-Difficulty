---@module Bank Heist
local M = {}

local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local scripted_enemy = Eclipse.scripted_enemy

local ambush_event_chance = math.random() <= 0.5

local cloaker = scripted_enemy.cloaker
local taser = scripted_enemy.taser_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_bulldozer_skull = scripted_enemy.elite_bulldozer_2
local elite_bulldozer_neil = scripted_enemy.elite_bulldozer_1

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
	use_instigator = true,
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
local optsBesiegeDummy_Van = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsBesiegeDummy_Heli = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_down_16m_right",
}
local optsDozerChopper_1 = {
	enemy = elite_bulldozer_neil,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400028, delay = 0 }, { id = 400023, delay = 0 }, { id = 400022, delay = 3 }, { id = 400022, delay = 3.5 } },
	enabled = true,
}
local optsDozerChopper_2 = {
	enemy = elite_bulldozer_skull,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400028, delay = 0 } },
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
local optsChopper_trigger_overkill_below = {
	on_executed = {
		{ id = 400043, delay = 0 },
	},
	enabled = true,
	player_1 = true,
	player_2 = true,
	player_3 = true,
	player_4 = true,
	difficulty_normal = true,
	difficulty_hard = true,
	difficulty_overkill = true,
	difficulty_overkill_145 = true,
}
local optsChopper_trigger_death_wish = {
	on_executed = {
		{ id = 400044, delay = 0 },
	},
	enabled = true,
	player_1 = true,
	player_2 = true,
	player_3 = true,
	player_4 = true,
	difficulty_easy_wish = true,
}
local chopper_amount_dw = {
	amount = 2,
	on_executed = {
		{ id = 400025, delay = 0, delay_rand = 10 },
		{ id = 400034, delay = 0, delay_rand = 10 },
		{ id = 400041, delay = 0, delay_rand = 10 },
	},
}
local chopper_amount_ovk_below = {
	amount = 1,
	on_executed = {
		{ id = 400034, delay = 0, delay_rand = 10 },
		{ id = 400041, delay = 0, delay_rand = 10 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400011, delay = 0 },
		{ id = 400012, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400018, delay = 0 },
		{ id = 400019, delay = 0 },
	},
	enabled = true,
}
local optsspawndozerchopper = {
	on_executed = { { id = 400020, delay = 26 }, { id = 400021, delay = 26 }, { id = 400024, delay = 0 } },
	enabled = is_eclipse,
}
local optsspawnswatchopper_1 = {
	on_executed = { { id = 400035, delay = 26 }, { id = 400033, delay = 0 } },
	enabled = true,
}
local optsspawnswatchopper_2 = {
	on_executed = { { id = 400042, delay = 26 }, { id = 400040, delay = 0 } },
	enabled = true,
}
local optsHuntSO = {
	SO_access = "4096",
	path_style = "none",
	scan = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_hunt",
}

local Smoke_bomb = {
	duration = 12,
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

local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

local ambush_event_global = {
	enabled = (ambush_event_chance and is_eclipse) and true or false,
	on_executed = { { id = 400076, delay = 0 }, { id = 400078, delay = 0 } },
}
local optsEnable_ambush = {
	enabled = true,
	elements = {
		400077,
	},
}
local optsEnable_ambush_alarm = {
	elements = {
		400064,
		400065,
	},
}
local optsdisable_locked_vault_door = {
	enabled = true,
	toggle = "off",
	elements = {
		100197,
		100198,
		102716,
		102717,
	},
}

local optsDozerAmbush = {
	enemy_table = is_eclipse_pro and random_elite_dozers or random_dozers,
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

local Smoke_bomb_ambush = {
	duration = 7,
}
local begin_ambush_event_left = {
	on_executed = { { id = 400066, delay = 2 }, { id = 400079, delay = 2 } },
}
local begin_ambush_event_right = {
	on_executed = { { id = 400067, delay = 2 }, { id = 400080, delay = 2 } },
}
local left_ambush_amount = {
	amount = 1,
	on_executed = {
		{ id = 400068, delay = 0 },
		{ id = 400069, delay = 0 },
		{ id = 400070, delay = 0 },
		{ id = 400071, delay = 0 },
	},
}
local right_ambush_amount = {
	amount = 1,
	on_executed = {
		{ id = 400072, delay = 0 },
		{ id = 400073, delay = 0 },
		{ id = 400074, delay = 0 },
		{ id = 400075, delay = 0 },
	},
}
local three_cloakers_left = {
	on_executed = { { id = 400054, delay = 0 }, { id = 400055, delay = 0 }, { id = 400056, delay = 0 } },
	enabled = true,
}
local two_dozers_left = {
	on_executed = { { id = 400050, delay = 0 }, { id = 400051, delay = 0 } },
	enabled = true,
}
local taser_dozer_left = {
	on_executed = { { id = 400052, delay = 0 }, { id = 400051, delay = 0 } },
	enabled = true,
}
local cloaker_dozer_left = {
	on_executed = { { id = 400053, delay = 0 }, { id = 400051, delay = 0 } },
	enabled = true,
}
local three_cloakers_right = {
	on_executed = { { id = 400061, delay = 0 }, { id = 400062, delay = 0 }, { id = 400063, delay = 0 } },
	enabled = true,
}
local two_dozers_right = {
	on_executed = { { id = 400057, delay = 0 }, { id = 400058, delay = 0 } },
	enabled = true,
}
local taser_dozer_right = {
	on_executed = { { id = 400058, delay = 0 }, { id = 400059, delay = 0 } },
	enabled = true,
}
local cloaker_dozer_right = {
	on_executed = { { id = 400058, delay = 0 }, { id = 400060, delay = 0 } },
	enabled = true,
}

M.elements = {
	-- skulldozer nearby the van on Death Wish (based on DW Trailer)
	Eclipse.mission_elements.gen_dummy(400001, "van_dozer", Vector3(-8305, -3511, 0), Rotation(-90, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_so(400002, "dozer_defend_so", Vector3(-7273, -2895, -19.999), Rotation(0, 0, -0), optsDefend_SO),
	Eclipse.mission_elements.gen_toggleelement(400003, "enable_dozervan", optsEnable_DWDozer),
	Eclipse.mission_elements.gen_toggleelement(400004, "disable_dozervan", optsDisable_DWDozer),

	-- swat van 1
	Eclipse.mission_elements.gen_dummy(400005, "swat_van_spawn_1", Vector3(-91.468, -1007.981, -19.999), Rotation(-84, 0, 0), optsBesiegeDummy_Van),
	Eclipse.mission_elements.gen_dummy(400006, "swat_van_spawn_2", Vector3(-97.531, -950.298, -19.999), Rotation(-84, 0, 0), optsBesiegeDummy_Van),
	Eclipse.mission_elements.gen_dummy(400007, "swat_van_spawn_3", Vector3(-21.538, -1003.647, -19.999), Rotation(-84, 0, 0), optsBesiegeDummy_Van),
	Eclipse.mission_elements.gen_dummy(400008, "swat_van_spawn_4", Vector3(-32.310, -939.421, -19.999), Rotation(-84, 0, 0), optsBesiegeDummy_Van),
	Eclipse.mission_elements.gen_missionscript(400010, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400011, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_spawngroup(400012, "swat_group_1", { 400005, 400006, 400007, 400008 }, 0, opts_swat_group),

	-- swat van 2
	Eclipse.mission_elements.gen_dummy(400013, "swat_van_spawn_5", Vector3(752.310, 2584.795, -19.850), Rotation(16, 0, 0), optsBesiegeDummy_Van),
	Eclipse.mission_elements.gen_dummy(400014, "swat_van_spawn_6", Vector3(694.634, 2568.257, -19.850), Rotation(16, 0, 0), optsBesiegeDummy_Van),
	Eclipse.mission_elements.gen_dummy(400015, "swat_van_spawn_7", Vector3(668.759, 2622.214, -19.850), Rotation(16, 0, 0), optsBesiegeDummy_Van),
	Eclipse.mission_elements.gen_dummy(400016, "swat_van_spawn_8", Vector3(732.061, 2644.528, -19.850), Rotation(16, 0, 0), optsBesiegeDummy_Van),
	Eclipse.mission_elements.gen_missionscript(400017, "spawn_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400018, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_2),
	Eclipse.mission_elements.gen_spawngroup(400019, "swat_group_2", { 400013, 400014, 400015, 400016 }, 0, opts_swat_group),

	-- chopper 1
	Eclipse.mission_elements.gen_dummy(400020, "dozer_heli_1", Vector3(-1769, 655, 0), Rotation(-90, 0, 0), optsDozerChopper_1),
	Eclipse.mission_elements.gen_dummy(400021, "dozer_heli_2", Vector3(-1489, 655, 0), Rotation(90, 0, 0), optsDozerChopper_2),
	Eclipse.mission_elements.gen_smokegrenade(400022, "smoke_grenade_heli", Vector3(-1625, 755, 0), Rotation(0, 0, 0), Smoke_bomb),
	Eclipse.mission_elements.gen_object_editor(400023, "shatter_glass", Vector3(0, 0, 0), Rotation(0, 0, 0), optsBreak_The_Glass),
	Eclipse.mission_elements.gen_object_editor(400024, "dozer_heli_sequence", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDozerChopper),
	Eclipse.mission_elements.gen_missionscript(400025, "dozer_heli_event", optsspawndozerchopper),
	Eclipse.mission_elements.gen_toggleelement(400026, "enable_dozer_chopper", optsenable_dozer_chopper),
	Eclipse.mission_elements.gen_toggleelement(400027, "disable_dozer_chopper", optsdisable_dozer_chopper),
	Eclipse.mission_elements.gen_so(400028, "hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsHuntSO),
	-- chopper 2
	Eclipse.mission_elements.gen_dummy(400029, "swat_heli_1", Vector3(-607, 4091.155, 0), Rotation(137, 0, 0), optsBesiegeDummy_Heli),
	Eclipse.mission_elements.gen_dummy(400030, "swat_heli_2", Vector3(-534.196, 4022.955, 0), Rotation(137, 0, 0), optsBesiegeDummy_Heli),
	Eclipse.mission_elements.gen_dummy(400031, "swat_heli_3", Vector3(-793.310, 3894.095, 0), Rotation(-46, 0, 0), optsBesiegeDummy_Heli),
	Eclipse.mission_elements.gen_dummy(400032, "swat_heli_4", Vector3(-716.203, 3814.249, 0), Rotation(-46, 0, 0), optsBesiegeDummy_Heli),
	Eclipse.mission_elements.gen_object_editor(400033, "swat_heli_sequence_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_1),
	Eclipse.mission_elements.gen_missionscript(400034, "swat_heli_event_1", optsspawnswatchopper_1),
	Eclipse.mission_elements.gen_spawngroup(400035, "swat_group_3", { 400029, 400030, 400031, 400032 }, 0, opts_swat_group),
	-- chopper 3
	Eclipse.mission_elements.gen_dummy(400036, "swat_heli_5", Vector3(1061, -934, -19.814), Rotation(0, 0, 0), optsBesiegeDummy_Heli),
	Eclipse.mission_elements.gen_dummy(400037, "swat_heli_6", Vector3(906, -934, -19.814), Rotation(0, 0, 0), optsBesiegeDummy_Heli),
	Eclipse.mission_elements.gen_dummy(400038, "swat_heli_7", Vector3(1061, -663, -19.814), Rotation(-180, 0, 0), optsBesiegeDummy_Heli),
	Eclipse.mission_elements.gen_dummy(400039, "swat_heli_8", Vector3(903, -663, -19.814), Rotation(-180, 0, 0), optsBesiegeDummy_Heli),
	Eclipse.mission_elements.gen_object_editor(400040, "swat_heli_sequence_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_2),
	Eclipse.mission_elements.gen_missionscript(400041, "swat_heli_event_2", optsspawnswatchopper_2),
	Eclipse.mission_elements.gen_spawngroup(400042, "swat_group_4", { 400036, 400037, 400038, 400039 }, 0, opts_swat_group),
	-- chopper spawner
	Eclipse.mission_elements.gen_element_random(400043, "random_chopper_spawner_ovk_below", chopper_amount_ovk_below),
	Eclipse.mission_elements.gen_element_random(400044, "random_chopper_spawner_dw", chopper_amount_dw),
	Eclipse.mission_elements.gen_element_filter(400045, "chopper_event_ovk_below_trigger", Vector3(0, 0, 0), Rotation(0, 0, 0), optsChopper_trigger_overkill_below),
	Eclipse.mission_elements.gen_element_filter(400046, "chopper_event_dw_trigger", Vector3(0, 0, 0), Rotation(0, 0, 0), optsChopper_trigger_death_wish),

	-- vault ambush
	-- left
	Eclipse.mission_elements.gen_dummy(400050, "dozer_ambush_left_1", Vector3(-2168, 1941, 0), Rotation(180, 0, 0), optsDozerAmbush),
	Eclipse.mission_elements.gen_dummy(400051, "dozer_ambush_left_2", Vector3(-2245, 1941, 0), Rotation(180, 0, 0), optsDozerAmbush),
	Eclipse.mission_elements.gen_dummy(400052, "taser_ambush_left_1", Vector3(-2168, 1941, 0), Rotation(180, 0, 0), optsTaserAmbush),
	Eclipse.mission_elements.gen_dummy(400053, "cloaker_ambush_left_1", Vector3(-2168, 1941, 0), Rotation(180, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400054, "cloaker_ambush_left_2", Vector3(-2254, 2032, 0), Rotation(180, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400055, "cloaker_ambush_left_3", Vector3(-2195, 2032, 0), Rotation(180, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400056, "cloaker_ambush_left_4", Vector3(-2138, 2032, 0), Rotation(180, 0, 0), optsCloakerAmbush),
	-- right
	Eclipse.mission_elements.gen_dummy(400057, "dozer_ambush_right_1", Vector3(-1930.721, 2145.005, 0), Rotation(-90, 0, 0), optsDozerAmbush),
	Eclipse.mission_elements.gen_dummy(400058, "dozer_ambush_right_2", Vector3(-1933.652, 2228.954, 0), Rotation(-90, 0, 0), optsDozerAmbush),
	Eclipse.mission_elements.gen_dummy(400059, "taser_ambush_right_1", Vector3(-1930.721, 2145.005, 0), Rotation(-90, 0, 0), optsTaserAmbush),
	Eclipse.mission_elements.gen_dummy(400060, "cloaker_ambush_right_1", Vector3(-1930.721, 2145.005, 0), Rotation(-90, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400061, "cloaker_ambush_right_2", Vector3(-2008.708, 2143.282, 0), Rotation(-90, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400062, "cloaker_ambush_right_3", Vector3(-2011.151, 2213.240, 0), Rotation(-90, 0, 0), optsCloakerAmbush),
	Eclipse.mission_elements.gen_dummy(400063, "cloaker_ambush_right_4", Vector3(-2014.641, 2273.215, 0), Rotation(-90, 0, 0), optsCloakerAmbush),
	-- random elements
	Eclipse.mission_elements.gen_missionscript(400064, "begin_ambush_left", begin_ambush_event_left),
	Eclipse.mission_elements.gen_missionscript(400065, "begin_ambush_right", begin_ambush_event_right),
	Eclipse.mission_elements.gen_element_random(400066, "left_ambush_select", left_ambush_amount),
	Eclipse.mission_elements.gen_element_random(400067, "right_ambush_select", right_ambush_amount),
	-- left
	Eclipse.mission_elements.gen_missionscript(400068, "three_cloakers", three_cloakers_left),
	Eclipse.mission_elements.gen_missionscript(400069, "two_dozers", two_dozers_left),
	Eclipse.mission_elements.gen_missionscript(400070, "taser_dozer", taser_dozer_left),
	Eclipse.mission_elements.gen_missionscript(400071, "cloaker_dozer", cloaker_dozer_left),
	-- right
	Eclipse.mission_elements.gen_missionscript(400072, "three_cloakers", three_cloakers_right),
	Eclipse.mission_elements.gen_missionscript(400073, "two_dozers", two_dozers_right),
	Eclipse.mission_elements.gen_missionscript(400074, "taser_dozer", taser_dozer_right),
	Eclipse.mission_elements.gen_missionscript(400075, "cloaker_dozer", cloaker_dozer_right),
	-- toggle element
	Eclipse.mission_elements.gen_toggleelement(400076, "enable_ambushes", optsEnable_ambush),
	Eclipse.mission_elements.gen_toggleelement(400077, "enable_ambush_on_alarm", optsEnable_ambush_alarm),
	Eclipse.mission_elements.gen_toggleelement(400078, "disable_locked_vault_door", optsdisable_locked_vault_door),
	-- smoke bombs
	Eclipse.mission_elements.gen_smokegrenade(400079, "smoke_grenade_left", Vector3(-2208, 1742, 0), Rotation(0, 0, 0), Smoke_bomb_ambush),
	Eclipse.mission_elements.gen_smokegrenade(400080, "smoke_grenade_right", Vector3(-1760.265, 2207.041, 0), Rotation(0, 0, 0), Smoke_bomb_ambush),
	-- chance
	Eclipse.mission_elements.gen_missionscript(400081, "ambush_event", ambush_event_global),
}

return M
