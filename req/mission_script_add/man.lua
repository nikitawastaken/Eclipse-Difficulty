---@module Undercover
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local dozer_random_amount = overkill_and_above and 2 or 1
local dozers_respawn = (is_eclipse and 240 or 300) - (is_eclipse_pro and 60 or is_pro_job and 30 or 0)
local dozer_event = not normal or (is_pro_job and normal) and true or false


local cloaker = scripted_enemy.cloaker
local taser = scripted_enemy.taser_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2

local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_normal_and_elite_dozers = {
	green_bulldozer,
	black_bulldozer,
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local bulldozer = is_eclipse_pro and random_elite_dozers or is_eclipse and random_normal_and_elite_dozers or random_dozers

local optsBesiegeDummyCloaker = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_clk_exit_vent_1_5m",
	enabled = true,
}
local optsPreferedCloakerAdd1 = {
	spawn_groups = { 400019, 400020, 400021, 400022, 400023, 400024, 400025, 400026, 400027 },
	enabled = normal_and_above,
}
local optsTaser = {
	enemy = taser,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400012, delay = 0 } },
	enabled = true,
}
local optsBulldozer = {
	enemy_table = bulldozer,
	on_executed = {
		{ id = 400032, delay = 2 },
	},
	enabled = true,
}
local optsDozerHunt_SO = {
	SO_access = "4096",
	scan = true,
	interval = 2,
	so_action = "AI_hunt",
}
local optsHuntSO = {
	SO_access = "8192",
	path_style = "none",
	scan = true,
	so_action = "AI_hunt",
}
local optsTaserChopper = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100008, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100008, notify_unit_sequence = "flyin_fwd_hover", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100008, notify_unit_sequence = "open_door_left", time = 24 },
		{ id = 4, name = "run_sequence", notify_unit_id = 100008, notify_unit_sequence = "open_door_right", time = 24 },
		{ id = 5, name = "run_sequence", notify_unit_id = 100008, notify_unit_sequence = "close_door_left", time = 36 },
		{ id = 6, name = "run_sequence", notify_unit_id = 100008, notify_unit_sequence = "close_door_right", time = 36 },
		{ id = 7, name = "run_sequence", notify_unit_id = 100008, notify_unit_sequence = "hover_flyout_right", time = 39 },
		{ id = 8, name = "run_sequence", notify_unit_id = 100008, notify_unit_sequence = "hidden", time = 65 },
	},
}
local optsspawntaserchopper = {
	on_executed = { { id = 400006, delay = 26 }, { id = 400007, delay = 26 }, { id = 400008, delay = 26 }, { id = 400011, delay = 0 } },
	enabled = normal_and_above,
}
local optslowerNewComputerHack_1 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101877, notify_unit_sequence = "start_1", time = 0 },
	},
	on_executed = {
		{ id = 102832, delay = 0 },
	},
}
local optslowerNewComputerHack_2 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101877, notify_unit_sequence = "start_2", time = 0 },
	},
	on_executed = {
		{ id = 102832, delay = 0 },
	},
}
local optslowerNewComputerHack_3 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101877, notify_unit_sequence = "start_3", time = 0 },
	},
	on_executed = {
		{ id = 102832, delay = 0 },
	},
}
local optshigherNewComputerHack_1 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101880, notify_unit_sequence = "start_1", time = 0 },
	},
	on_executed = {
		{ id = 102829, delay = 0 },
	},
}
local optshigherNewComputerHack_2 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101880, notify_unit_sequence = "start_2", time = 0 },
	},
	on_executed = {
		{ id = 102829, delay = 0 },
	},
}
local optshigherNewComputerHack_3 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 101880, notify_unit_sequence = "start_3", time = 0 },
	},
	on_executed = {
		{ id = 102829, delay = 0 },
	},
}

local choose_dozer_spawnpoint = {
	amount = 1,
	trigger_times = 1,
	on_executed = {
		{ id = 400034, delay = 0 },
		{ id = 400035, delay = 0 },
	},
}
local dozer_amount_1 = {
	amount = dozer_random_amount,
	on_executed = {
		{ id = 400028, delay = 0 },
		{ id = 400029, delay = 0 },
	},
}
local dozer_amount_2 = {
	amount = dozer_random_amount,
	on_executed = {
		{ id = 400030, delay = 0 },
		{ id = 400031, delay = 0 },
	},
}
local optsdisable_random_dozers = {
	enabled = true,
	toggle = "off",
	elements = {
		400033,
	},
}
local optsenable_random_dozers = {
	enabled = true,
	set_trigger_times = 1,
	elements = {
		400033,
	},
}
local spawn_dozer_global = {
	enabled = dozer_event,
	on_executed = {
		{ id = 400033, delay = 0 },
		{ id = 400047, delay = 0 },
	},
}

local optsdozerdied_1 = {
	on_executed = {
		{ id = 400045, delay = 0 },
		{ id = 400033, delay = dozers_respawn },
	},
	elements = {
		400028,
	},
	event = "death",
}
local optsdozerdied_2 = {
	on_executed = {
		{ id = 400045, delay = 0 },
		{ id = 400033, delay = dozers_respawn },
	},
	elements = {
		400029,
	},
	event = "death",
}
local optsdozerdied_3 = {
	on_executed = {
		{ id = 400045, delay = 0 },
		{ id = 400033, delay = dozers_respawn },
	},
	elements = {
		400030,
	},
	event = "death",
}
local optsdozerdied_4 = {
	on_executed = {
		{ id = 400045, delay = 0 },
		{ id = 400033, delay = dozers_respawn },
	},
	elements = {
		400031,
	},
	event = "death",
}
local optsdozerspawned_1 = {
	on_executed = {
		{ id = 400044, delay = 0 },
	},
	elements = {
		400028,
	},
}
local optsdozerspawned_2 = {
	on_executed = {
		{ id = 400044, delay = 0 },
	},
	elements = {
		400029,
	},
}
local optsdozerspawned_3 = {
	on_executed = {
		{ id = 400044, delay = 0 },
	},
	elements = {
		400030,
	},
}
local optsdozerspawned_4 = {
	on_executed = {
		{ id = 400044, delay = 0 },
	},
	elements = {
		400031,
	},
}

local Bain_senddozers = {
	dialogue = "play_pln_gen_pol_03",
}

M.elements = {
	-- restore cloaker vent spawns and add missing spawns
	Eclipse.mission_elements.gen_dummy(400000, "new_cloaker_1", Vector3(-1260, -2808, 299.986), Rotation(0, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400001, "new_cloaker_2", Vector3(-1440, -2129, 475.001), Rotation(180, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400002, "new_cloaker_3", Vector3(-1326.516, 541.548, 821), Rotation(-90, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400003, "new_cloaker_4", Vector3(-863.956, 485.679, 821), Rotation(90, 0, 0), optsBesiegeDummyCloaker),

	Eclipse.mission_elements.gen_preferedadd(400005, "new_cloaker_spawns", optsPreferedCloakerAdd1),

	-- taser chopper spawn from PDTH
	Eclipse.mission_elements.gen_dummy(400006, "taser_chopper_1", Vector3(-1804.570, -2569.821, 1961.254), Rotation(83, 0, 0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400007, "taser_chopper_2", Vector3(-1803.140, -2656.642, 1961.254), Rotation(83, 0, 0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400008, "taser_chopper_3", Vector3(-2091.744, -2537.606, 1961.254), Rotation(-90, 0, 0), optsTaser),

	Eclipse.mission_elements.gen_missionscript(400010, "spawn_tasers", optsspawntaserchopper),
	Eclipse.mission_elements.gen_object_editor(400011, "chopper_sequence", Vector3(0, 0, 0), Rotation(0, 0, -0), optsTaserChopper),

	Eclipse.mission_elements.gen_so(400012, "hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsHuntSO),

	-- buff the hack timer (use PDTH values)
	-- lower PC
	Eclipse.mission_elements.gen_object_editor(400013, "new_hack_lower_floor_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optslowerNewComputerHack_1),
	Eclipse.mission_elements.gen_object_editor(400014, "new_hack_lower_floor_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optslowerNewComputerHack_2),
	Eclipse.mission_elements.gen_object_editor(400015, "new_hack_lower_floor_3", Vector3(0, 0, 0), Rotation(0, 0, -0), optslowerNewComputerHack_3),

	-- higher PC
	Eclipse.mission_elements.gen_object_editor(400016, "new_hack_higher_floor_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optshigherNewComputerHack_1),
	Eclipse.mission_elements.gen_object_editor(400017, "new_hack_higher_floor_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optshigherNewComputerHack_2),
	Eclipse.mission_elements.gen_object_editor(400018, "new_hack_higher_floor_3", Vector3(0, 0, 0), Rotation(0, 0, -0), optshigherNewComputerHack_3),

	Eclipse.mission_elements.gen_spawngroup(400019, "new_cloaker_spawngroup_01", { 400000 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400020, "new_cloaker_spawngroup_02", { 400001 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400021, "new_cloaker_spawngroup_03", { 400002 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400022, "new_cloaker_spawngroup_04", { 400003 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400023, "new_cloaker_spawngroup_05", { 103794 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400024, "new_cloaker_spawngroup_06", { 103796 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400025, "new_cloaker_spawngroup_07", { 103797 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400026, "new_cloaker_spawngroup_08", { 103800 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400027, "new_cloaker_spawngroup_09", { 103801 }, 0),
	
	-- scripted dozers
	Eclipse.mission_elements.gen_dummy(400028, "bulldozer_1", Vector3(-770, -4037, -45.121), Rotation(90, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400029, "bulldozer_2", Vector3(-840, -4037, -45.121), Rotation(90, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400030, "bulldozer_3", Vector3(-3069, 542, -50.370), Rotation(0, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400031, "bulldozer_4", Vector3(-3069, 480, -50.370), Rotation(0, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_so(400032, "dozer_hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDozerHunt_SO),

	-- scripted dozers stuff
	Eclipse.mission_elements.gen_element_random(400033, "dozer_spawnpoint_select", choose_dozer_spawnpoint),
	Eclipse.mission_elements.gen_element_random(400034, "left_staircase", dozer_amount_1),
	Eclipse.mission_elements.gen_element_random(400035, "right_staircase", dozer_amount_2),
	Eclipse.mission_elements.gen_dummytrigger(400036, "dozer_spawned_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_1),
	Eclipse.mission_elements.gen_dummytrigger(400037, "dozer_spawned_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_2),
	Eclipse.mission_elements.gen_dummytrigger(400038, "dozer_spawned_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_3),
	Eclipse.mission_elements.gen_dummytrigger(400039, "dozer_spawned_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_4),
	Eclipse.mission_elements.gen_dummytrigger(400040, "dozer_died_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_1),
	Eclipse.mission_elements.gen_dummytrigger(400041, "dozer_died_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_2),
	Eclipse.mission_elements.gen_dummytrigger(400042, "dozer_died_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_3),
	Eclipse.mission_elements.gen_dummytrigger(400043, "dozer_died_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_4),
	Eclipse.mission_elements.gen_toggleelement(400044, "disable_random_dozers", optsdisable_random_dozers),
	Eclipse.mission_elements.gen_toggleelement(400045, "enable_random_dozers", optsenable_random_dozers),
	Eclipse.mission_elements.gen_missionscript(400046, "hello_its_me_the_angry_man", spawn_dozer_global),
	Eclipse.mission_elements.gen_dialogue(400047, "they_sending_dozers", Bain_senddozers),
}
return M
