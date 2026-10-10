---@module Firestarter Day 1
local M = {}
local scripted_enemy = Eclipse.scripted_enemy

local choose_sniper_spot_1 = {
	amount = 1,
	on_executed = {
		{ id = 100163, delay = 0 },
		{ id = 100168, delay = 0 },
		{ id = 101906, delay = 0 },
		{ id = 101908, delay = 0 },
	},
}
local choose_sniper_spot_2 = {
	amount = 1,
	on_executed = {
		{ id = 100160, delay = 0 },
		{ id = 100161, delay = 0 },
	},
}
local forest_group = {
	enabled = false,
}
local enable_forest_group = {
	enabled = true,
	trigger_times = 1,
	elements = {
		400006,
	},
}
local cloaker_dummy01 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	enabled = true,
}
local cloaker_dummy02 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_fwd_4m_jump_dwn_4_5m",
	enabled = true,
}
local cloaker_dummy03 = {
	trigger_times = 0,
	enemy = scripted_enemy.cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_over_3m",
	enabled = true,
}
local cloaker_group_preferred_add = {
	spawn_groups = { 400011, 400012, 400013, 400014, 400015, 400016 },
	on_executed = {
		{ id = 100429, delay = 0 },
	},
	enabled = true,
}
local cloaker_spawn_global = {
	on_executed = {
		{ id = 400017, delay = 0 },
	},
	enabled = true,
}

M.elements = {
	-- improve SO sniper spot select
	Eclipse.mission_elements.gen_element_random(400001, "choose_sniper_spot_1", choose_sniper_spot_1),
	Eclipse.mission_elements.gen_element_random(400002, "choose_sniper_spot_2", choose_sniper_spot_2),

	Eclipse.mission_elements.gen_spawngroup(400003, "firestarter_1_forest_group", { 102570 }, 0, forest_group),
	Eclipse.mission_elements.gen_toggleelement(400004, "enable_forest_group", enable_forest_group),

	-- Add recurring Cloaker spawns
	Eclipse.mission_elements.gen_dummy(400005, "firestarter_1_cloaker_spawn001", Vector3(2400, 5800, 0), Rotation(-180, 0, 0), cloaker_dummy02),
	Eclipse.mission_elements.gen_dummy(400006, "firestarter_1_cloaker_spawn002", Vector3(4500, 4550, 0), Rotation(90, 0, 0), cloaker_dummy03),
	Eclipse.mission_elements.gen_dummy(400007, "firestarter_1_cloaker_spawn003", Vector3(2500, -450, 0), Rotation(0, 0, 0), cloaker_dummy01),
	Eclipse.mission_elements.gen_dummy(400008, "firestarter_1_cloaker_spawn004", Vector3(4925, -150, 0), Rotation(90, 0, 0), cloaker_dummy01),
	Eclipse.mission_elements.gen_dummy(400009, "firestarter_1_cloaker_spawn005", Vector3(2875, 475, 400), Rotation(0, 0, 0), cloaker_dummy01),
	Eclipse.mission_elements.gen_dummy(400010, "firestarter_1_cloaker_spawn006", Vector3(-4225, 1750, 200), Rotation(-90, 0, 0), cloaker_dummy01),

	Eclipse.mission_elements.gen_spawngroup(400011, "firestarter_1_cloaker_group001", { 400005 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400012, "firestarter_1_cloaker_group002", { 400006 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400013, "firestarter_1_cloaker_group003", { 400007 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400014, "firestarter_1_cloaker_group004", { 400008 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400015, "firestarter_1_cloaker_group005", { 400009 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400016, "firestarter_1_cloaker_group006", { 400010 }, 0),

	Eclipse.mission_elements.gen_preferedadd(400017, "firestarter_1_cloaker_preferred_add", cloaker_group_preferred_add),
	Eclipse.mission_elements.gen_missionscript(400018, "firestarter_1_cloaker_spawn_global", cloaker_spawn_global),
}

return M
