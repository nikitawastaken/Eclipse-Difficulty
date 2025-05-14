---@module Bank Heist
local M = {}

local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy

local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local shield = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield
local taser = scripted_enemy.taser_1
local elite_sniper = scripted_enemy.elite_sniper
local medic = diff_i < 4 and scripted_enemy.taser_1 or scripted_enemy.medic_1
local elite_bulldozer_skull = scripted_enemy.elite_bulldozer_2
local elite_bulldozer_neil = scripted_enemy.elite_bulldozer_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_1
local cloaker = scripted_enemy.cloaker

local swats = { [swat_1] = 2, [swat_2] = 1 }

local specials_list_eclipse = { [taser] = 2, [medic] = 2, [cloaker] = 2, [elite_bulldozer_neil] = 1, [elite_bulldozer_skull] = 1 }
local specials_list_hard_ovk = { [taser] = 4, [medic] = 3, [cloaker] = 2, [green_bulldozer] = 1, [black_bulldozer] = 1 }
local specials_list_easy_normal = { [taser] = 6, [cloaker] = 1 }
local specials = {
	enemy = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse,
}

local optsBulldozer = {
	enemy = elite_bulldozer_skull,
	on_executed = {
		{ id = 400002, delay = 0 },
	},
	enabled = is_eclipse,
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
	enabled = true,
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
local optsSWAT_heli_1 = {
	enemy = is_eclipse and elite_sniper or swat_1,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400019, delay = 0 } },
	enabled = true,
}
local optsSWAT_heli_2 = {
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
	on_executed = { { id = 400005, delay = 0 }, { id = 400006, delay = 0 }, { id = 400007, delay = 0 }, { id = 400008, delay = 0 }, { id = 400009, delay = 0 }, { id = 400011, delay = 0 } },
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = { { id = 400012, delay = 0 }, { id = 400013, delay = 0 }, { id = 400014, delay = 0 }, { id = 400015, delay = 0 }, { id = 400016, delay = 0 }, { id = 400018, delay = 0 } },
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
	-- chopper 2
	Eclipse.mission_elements.gen_dummy(400026, "swat_heli_1", Vector3(-607, 4091.155, 0), Rotation(137, 0, 0), optsSWAT_heli_1),
	Eclipse.mission_elements.gen_dummy(400027, "swat_heli_2", Vector3(-534.196, 4022.955, 0), Rotation(137, 0, 0), optsSWAT_heli_1),
	Eclipse.mission_elements.gen_dummy(400028, "swat_heli_3", Vector3(-793.310, 3894.095, 0), Rotation(-46, 0, 0), optsSWAT_heli_1),
	Eclipse.mission_elements.gen_dummy(400029, "swat_heli_4", Vector3(-716.203, 3814.249, 0), Rotation(-46, 0, 0), optsTaser_heli),
	Eclipse.mission_elements.gen_object_editor(400030, "swat_heli_sequence_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_1),
	Eclipse.mission_elements.gen_missionscript(400031, "swat_heli_event_1", optsspawnswatchopper_1),
	-- chopper 3
	Eclipse.mission_elements.gen_dummy(400032, "swat_heli_5", Vector3(1061, -934, -19.814), Rotation(0, 0, 0), optsSWAT_heli_2),
	Eclipse.mission_elements.gen_dummy(400033, "swat_heli_6", Vector3(906, -934, -19.814), Rotation(0, 0, 0), optsSWAT_heli_2),
	Eclipse.mission_elements.gen_dummy(400034, "swat_heli_7", Vector3(1061, -663, -19.814), Rotation(-180, 0, 0), optsSpecial_heli),
	Eclipse.mission_elements.gen_dummy(400035, "swat_heli_8", Vector3(903, -663, -19.814), Rotation(-180, 0, 0), optsSpecial_heli),
	Eclipse.mission_elements.gen_object_editor(400036, "swat_heli_sequence_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsSWATChopper_2),
	Eclipse.mission_elements.gen_missionscript(400037, "swat_heli_event_2", optsspawnswatchopper_2),
}

return M
