---@module Big Oil Day 1
local M = {}
local scripted_enemy = Eclipse.scripted_enemy

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsBesiegeDummyCloaker_1 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_over_3m_fwd_2m_roll",
	enabled = true,
}
local optsBesiegeDummyCloaker_2 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_clk_up_water",
	enabled = true,
}
local optsBesiegeDummyCloaker_3 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	enabled = true,
}

local optsOpenSwatVanDoors = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101379, notify_unit_sequence = "anim_door_right_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 101379, notify_unit_sequence = "anim_door_left_open", time = 0 },
	},
}
local optsspawnvanSWATs = {
	on_executed = {
		{ id = 400007, delay = 0 },
		{ id = 400006, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}
local optsenable_birds_area_1 = {
	enabled = true,
	elements = {
		103353,
	},
}
local optsenable_birds_area_2 = {
	enabled = true,
	elements = {
		103358,
	},
}
local optsenable_birds_area_3 = {
	enabled = true,
	elements = {
		103383,
	},
}
local optsenable_birds_area_4 = {
	enabled = true,
	elements = {
		103387,
	},
}
local optsenable_birds_area_5 = {
	enabled = true,
	elements = {
		103391,
	},
}
local optsenable_birds_area_6 = {
	enabled = true,
	elements = {
		103395,
	},
}
local optsenable_birds_area_7 = {
	enabled = true,
	elements = {
		103399,
	},
}
local optsenable_birds_area_8 = {
	enabled = true,
	elements = {
		103403,
	},
}
local optsenable_birds_area_9 = {
	enabled = true,
	elements = {
		103407,
	},
}
local optsenable_birds_area_10 = {
	enabled = true,
	elements = {
		103411,
	},
}
local optsenable_birds_area_11 = {
	enabled = true,
	elements = {
		103415,
	},
}
local spawn_random_birds = {
	amount = 4,
	trigger_times = 1,
	on_executed = {
		{ id = 400010, delay = 0 },
		{ id = 400011, delay = 0 },
		{ id = 400012, delay = 0 },
		{ id = 400013, delay = 0 },
		{ id = 400014, delay = 0 },
		{ id = 400015, delay = 0 },
		{ id = 400016, delay = 0 },
		{ id = 400017, delay = 0 },
		{ id = 400018, delay = 0 },
		{ id = 400019, delay = 0 },
		{ id = 400020, delay = 0 },
	},
}
local optsPreferedCloakerAdd1 = {
	spawn_groups = { 500044, 500045, 500046, 500047, 500048, 500049, 500050, 500051 },
	on_executed = {
		{ id = 100051, delay = 0 },
		{ id = 100077, delay = 0 },
		{ id = 100193, delay = 0 },
		{ id = 100194, delay = 0 },
	},
	enabled = true,
}
local optsAddCloakerHideGroup = {
	enabled = true,
	on_executed = {
		{ id = 500017, delay = 0 },
	},
}
local optsAssaultStarted = {
	enabled = true,
	global_event = "start_assault",
	trigger_times = 1,
	on_executed = {
		{ id = 500018, delay = 0 },
	},
}

M.elements = {
	-- swat van
	Eclipse.mission_elements.gen_dummy(400001, "swat_van_spawn_1", Vector3(7602, -9027, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_van_spawn_2", Vector3(7615.272, -8970.512, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_3", Vector3(7675.528, -9042.923, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_4", Vector3(7688.350, -8987.384, -21.578), Rotation(-103, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_swats", optsspawnvanSWATs),
	Eclipse.mission_elements.gen_object_editor(400006, "open_swat_doors", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors),
	Eclipse.mission_elements.gen_spawngroup(400007, "swat_group", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),

	-- restore birds event
	Eclipse.mission_elements.gen_toggleelement(400010, "enable_birds_1", optsenable_birds_area_1),
	Eclipse.mission_elements.gen_toggleelement(400011, "enable_birds_2", optsenable_birds_area_2),
	Eclipse.mission_elements.gen_toggleelement(400012, "enable_birds_3", optsenable_birds_area_3),
	Eclipse.mission_elements.gen_toggleelement(400013, "enable_birds_4", optsenable_birds_area_4),
	Eclipse.mission_elements.gen_toggleelement(400014, "enable_birds_5", optsenable_birds_area_5),
	Eclipse.mission_elements.gen_toggleelement(400015, "enable_birds_6", optsenable_birds_area_6),
	Eclipse.mission_elements.gen_toggleelement(400016, "enable_birds_7", optsenable_birds_area_7),
	Eclipse.mission_elements.gen_toggleelement(400017, "enable_birds_8", optsenable_birds_area_8),
	Eclipse.mission_elements.gen_toggleelement(400018, "enable_birds_9", optsenable_birds_area_9),
	Eclipse.mission_elements.gen_toggleelement(400019, "enable_birds_10", optsenable_birds_area_10),
	Eclipse.mission_elements.gen_toggleelement(400020, "enable_birds_11", optsenable_birds_area_11),

	Eclipse.mission_elements.gen_element_random(400021, "enable_random_birds_location", spawn_random_birds),

	-- New Cloakers and their hiding spots (actually there are enough hiding spots so we skip that)
	-- cloakers
	Eclipse.mission_elements.gen_dummy(500001, "cloaker_spawn_1", Vector3(707, -6752, 5.764), Rotation(0, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500002, "cloaker_spawn_2", Vector3(305, -3668, 5.764), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500003, "cloaker_spawn_3", Vector3(7559, -1524, 3.465), Rotation(-140, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(500004, "cloaker_spawn_4", Vector3(8602, -5795, -0.201), Rotation(0, 0, 0), optsBesiegeDummyCloaker_3),
	Eclipse.mission_elements.gen_dummy(500005, "cloaker_spawn_5", Vector3(-1259.059, -1588.383, 24.465), Rotation(-180, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(500006, "cloaker_spawn_6", Vector3(4729, -10370, -11.961), Rotation(90, 0, 0), optsBesiegeDummyCloaker_3),
	Eclipse.mission_elements.gen_dummy(500007, "cloaker_spawn_7", Vector3(6468, -8661, -1.659), Rotation(0, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(500008, "cloaker_spawn_8", Vector3(9142, -3135, -0.13), Rotation(0, 0, 0), optsBesiegeDummyCloaker_3),
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(500009, "wttj_cloaker_spawngroup_01", { 500001 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500010, "wttj_cloaker_spawngroup_02", { 500002 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500011, "wttj_cloaker_spawngroup_03", { 500003 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500012, "wttj_cloaker_spawngroup_04", { 500004 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500013, "wttj_cloaker_spawngroup_05", { 500005 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500014, "wttj_cloaker_spawngroup_06", { 500006 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500015, "wttj_cloaker_spawngroup_07", { 500007 }, 0),
	Eclipse.mission_elements.gen_spawngroup(500016, "wttj_cloaker_spawngroup_08", { 500008 }, 0),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(500017, "wttj_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_missionscript(500018, "wttj_cloaker_spawn_global", optsAddCloakerHideGroup),
	Eclipse.mission_elements.gen_global_event(500019, "wttj_assault_start", Vector3(0, 0, 0), Rotation(0, 0, 0), optsAssaultStarted),
}

return M
