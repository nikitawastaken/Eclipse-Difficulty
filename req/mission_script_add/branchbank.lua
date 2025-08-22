---@module Bank Heist
local M = {}

local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy

local elite_bulldozer_skull = scripted_enemy.elite_bulldozer_2

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

M.elements = {
	-- skulldozer nearby the van on Eclipse (based on DW Trailer)
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
}

return M
