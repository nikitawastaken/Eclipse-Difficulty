---@module Breakfast in Tijuana
local M = {}

local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102206, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101645, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102207, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102208, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_5 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102209, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400006, delay = 0 },
		{ id = 400007, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400013, delay = 0 },
		{ id = 400014, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_3 = {
	on_executed = {
		{ id = 400020, delay = 0 },
		{ id = 400021, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_4 = {
	on_executed = {
		{ id = 400027, delay = 0 },
		{ id = 400028, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_5 = {
	on_executed = {
		{ id = 400034, delay = 0 },
		{ id = 400036, delay = 0 },
	},
	enabled = true,
}
local optsOpenSwatVanDoors_Trigger_1 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_car_anim", unit_id = 102209 },
	},
	on_executed = {
		{ id = 400033, delay = 0, delay_rand = 5 },
	},
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

local optsAddCloakerHideGroup = {
	enabled = true,
	on_executed = {
		{ id = 400048, delay = 0 },
	},
}
local optsCloakerHideGroup_Station = {
	followup_elements = {
		400040,
		400041,
		400042,
		400043,
		400044,
		400045,
		400046,
		400047,
	},
}
local optsCloakerHideGroup_Parking = {
	followup_elements = {
		101191,
		101192,
		101193,
		104064,
		104065,
		104128,
		104129,
		104139,
	},
}

-- Hiding Cloaker SOs are funny
local hide_so_search_pos = Vector3(-2436, 4351, 0.002)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_hide_behind_door_enter", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_sit_student_var5", hide_so_search_pos) -- funny spot
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var3", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_4 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh", hide_so_search_pos)

M.elements = {
	-- Arrive 1
	Eclipse.mission_elements.gen_dummy(400001, "swat_van_spawn_01", Vector3(4100, -1800, 0), Rotation(5, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_van_spawn_02", Vector3(4025, -1800, 0), Rotation(5, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_03", Vector3(4025, -1750, 0), Rotation(5, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_04", Vector3(4100, -1750, 0), Rotation(5, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_van_swats_01", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400006, "open_van_doors_01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_spawngroup(400007, "swat_van_group_01", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),

	-- Arrive 2
	Eclipse.mission_elements.gen_dummy(400008, "swat_van_spawn_05", Vector3(2925, -50, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400009, "swat_van_spawn_06", Vector3(2850, -75, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400010, "swat_van_spawn_07", Vector3(2825, 0, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400011, "swat_van_spawn_08", Vector3(2900, 25, 0), Rotation(20, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400012, "spawn_van_swats_02", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400013, "open_van_doors_02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_2),
	Eclipse.mission_elements.gen_spawngroup(400014, "swat_van_group_02", { 400008, 400009, 400010, 400011 }, 0, opts_swat_group),

	-- Arrive 3
	Eclipse.mission_elements.gen_dummy(400015, "swat_van_spawn_09", Vector3(3450, -3700, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400016, "swat_van_spawn_10", Vector3(3400, -3750, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400017, "swat_van_spawn_11", Vector3(3350, -3700, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400018, "swat_van_spawn_12", Vector3(3400, -3650, 0), Rotation(-135, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400019, "spawn_van_swats_03", optsspawnvanSWATs_3),
	Eclipse.mission_elements.gen_object_editor(400020, "open_van_doors_03", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_3),
	Eclipse.mission_elements.gen_spawngroup(400021, "swat_van_group_03", { 400015, 400016, 400017, 400018 }, 0, opts_swat_group),

	-- Arrive 4
	Eclipse.mission_elements.gen_dummy(400022, "swat_van_spawn_13", Vector3(-3416.319, -2584.237, -24.871), Rotation(136, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400023, "swat_van_spawn_14", Vector3(-3364.526, -2634.252, -24.871), Rotation(136, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400024, "swat_van_spawn_15", Vector3(-3455.914, -2625.239, -24.871), Rotation(136, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400025, "swat_van_spawn_16", Vector3(-3403.402, -2675.949, -24.871), Rotation(136, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400026, "spawn_van_swats_04", optsspawnvanSWATs_4),
	Eclipse.mission_elements.gen_object_editor(400027, "open_van_doors_04", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_4),
	Eclipse.mission_elements.gen_spawngroup(400028, "swat_van_group_04", { 400022, 400023, 400024, 400025 }, 0, opts_swat_group),

	-- Arrive 5
	Eclipse.mission_elements.gen_dummy(400029, "swat_van_spawn_17", Vector3(-4324, -3326, -24.871), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400030, "swat_van_spawn_18", Vector3(-4388, -3324, -24.871), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400031, "swat_van_spawn_19", Vector3(-4327, -3258, -24.871), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400032, "swat_van_spawn_20", Vector3(-4388, -3258, -24.871), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400033, "spawn_van_swats_05", optsspawnvanSWATs_5),
	Eclipse.mission_elements.gen_object_editor(400034, "open_van_doors_05", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenSwatVanDoors_5),
	Eclipse.mission_elements.gen_object_editor_trigger(400035, "swat_van_doors_trigger_01", optsOpenSwatVanDoors_Trigger_1),
	Eclipse.mission_elements.gen_spawngroup(400036, "swat_van_group_05", { 400029, 400030, 400031, 400032 }, 0, opts_swat_group),

	-- New Cloakers hiding spots
	-- hiding spots
	Eclipse.mission_elements.gen_so(400040, "cloaker_hide_so_1", Vector3(-1950.951, 2997.741, 100), Rotation(104, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400041, "cloaker_hide_so_2", Vector3(449, 1829, 100), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400042, "cloaker_hide_so_3", Vector3(-131, 2575, 100), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400043, "cloaker_hide_so_4", Vector3(-2724, 2171, 100), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400044, "cloaker_hide_so_5", Vector3(-2493, 788, 100), Rotation(-132, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400045, "cloaker_hide_so_6", Vector3(-319, 1782, 106), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400046, "cloaker_hide_so_7", Vector3(-1801, 1524, 503.201), Rotation(178, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400047, "cloaker_hide_so_8", Vector3(-1902, 2705, 503.201), Rotation(-177, 0, 0), optsCloaker_Hide_SpotSO_3),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_sogroup(400048, "pex_cloaker_hide_group_station", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup_Station),
	Eclipse.mission_elements.gen_sogroup(400049, "pex_cloaker_hide_group_parking", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup_Parking),
	Eclipse.mission_elements.gen_missionscript(400050, "pex_cloaker_spawn_global", optsAddCloakerHideGroup),
}

return M
