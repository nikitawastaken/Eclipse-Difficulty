---@module No Mercy

local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job
local dozer_random_amount = is_eclipse and 2 or 1
local dozers_respawn = (is_eclipse and 210 or 240) - (is_pro_job and 30 or 0)
local dozer_event = not normal and true or false

local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local cloaker = scripted_enemy.cloaker

local greendozer_only = {
	green_bulldozer,
}
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
local bulldozer = is_eclipse_pro and random_normal_and_elite_dozers or diff_i > 3 and random_dozers or greendozer_only

local optsBulldozer = {
	enemy_table = bulldozer,
	on_executed = {
		{ id = 400046, delay = 2 },
	},
	enabled = true,
}
local optsCloaker_Hide_SO = {
	SO_access = "1024",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interrupt_dis = 5,
	interrupt_dmg = 0.3,
	interval = 2,
	so_action = "e_so_idle_by_container",
}
local optsSniper_SO = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsDozerHunt_SO = {
	SO_access = "4096",
	scan = true,
	interval = 2,
	so_action = "AI_hunt",
}
local optsdozerdied_1 = {
	on_executed = {
		{ id = 400059, delay = 0 },
		{ id = 400035, delay = dozers_respawn },
	},
	elements = {
		400040,
	},
	event = "death",
}
local optsdozerdied_2 = {
	on_executed = {
		{ id = 400059, delay = 0 },
		{ id = 400035, delay = dozers_respawn },
	},
	elements = {
		400041,
	},
	event = "death",
}
local optsdozerdied_3 = {
	on_executed = {
		{ id = 400059, delay = 0 },
		{ id = 400035, delay = dozers_respawn },
	},
	elements = {
		400042,
	},
	event = "death",
}
local optsdozerdied_4 = {
	on_executed = {
		{ id = 400059, delay = 0 },
		{ id = 400035, delay = dozers_respawn },
	},
	elements = {
		400043,
	},
	event = "death",
}
local optsdozerdied_5 = {
	on_executed = {
		{ id = 400059, delay = 0 },
		{ id = 400035, delay = dozers_respawn },
	},
	elements = {
		400044,
	},
	event = "death",
}
local optsdozerdied_6 = {
	on_executed = {
		{ id = 400059, delay = 0 },
		{ id = 400035, delay = dozers_respawn },
	},
	elements = {
		400045,
	},
	event = "death",
}
local optsdozerdied_7 = {
	on_executed = {
		{ id = 400059, delay = 0 },
		{ id = 400035, delay = dozers_respawn },
	},
	elements = {
		400067,
	},
	event = "death",
}
local optsdozerdied_8 = {
	on_executed = {
		{ id = 400059, delay = 0 },
		{ id = 400035, delay = dozers_respawn },
	},
	elements = {
		400068,
	},
	event = "death",
}
local optsdozerspawned_1 = {
	on_executed = {
		{ id = 400058, delay = 0 },
	},
	elements = {
		400040,
	},
}
local optsdozerspawned_2 = {
	on_executed = {
		{ id = 400058, delay = 0 },
	},
	elements = {
		400041,
	},
}
local optsdozerspawned_3 = {
	on_executed = {
		{ id = 400058, delay = 0 },
	},
	elements = {
		400042,
	},
}
local optsdozerspawned_4 = {
	on_executed = {
		{ id = 400058, delay = 0 },
	},
	elements = {
		400043,
	},
}
local optsdozerspawned_5 = {
	on_executed = {
		{ id = 400058, delay = 0 },
	},
	elements = {
		400044,
	},
}
local optsdozerspawned_6 = {
	on_executed = {
		{ id = 400058, delay = 0 },
	},
	elements = {
		400045,
	},
}
local optsdozerspawned_7 = {
	on_executed = {
		{ id = 400058, delay = 0 },
		{ id = 400073, delay = 0 },
		{ id = 400074, delay = 8 },
	},
	elements = {
		400067,
	},
}
local optsdozerspawned_8 = {
	on_executed = {
		{ id = 400058, delay = 0 },
		{ id = 400073, delay = 0 },
		{ id = 400074, delay = 8 },
	},
	elements = {
		400068,
	},
}
local choose_dozer_spawnpoint = {
	amount = 1,
	trigger_times = 1,
	on_executed = {
		{ id = 400036, delay = 0 },
		{ id = 400037, delay = 0 },
		{ id = 400038, delay = 0 },
		{ id = 400039, delay = 0 },
	},
}
local dozer_amount_1 = {
	amount = dozer_random_amount,
	on_executed = {
		{ id = 400040, delay = 0 },
		{ id = 400041, delay = 0 },
	},
}
local dozer_amount_2 = {
	amount = dozer_random_amount,
	on_executed = {
		{ id = 400042, delay = 0 },
		{ id = 400043, delay = 0 },
	},
}
local dozer_amount_3 = {
	amount = dozer_random_amount,
	on_executed = {
		{ id = 400044, delay = 0 },
		{ id = 400045, delay = 0 },
	},
}
local dozer_amount_4 = {
	amount = dozer_random_amount,
	on_executed = {
		{ id = 400067, delay = 0 },
		{ id = 400068, delay = 0 },
	},
}
local optsdisable_random_dozers = {
	enabled = true,
	toggle = "off",
	elements = {
		400035,
	},
}
local optsenable_random_dozers = {
	enabled = true,
	elements = {
		400035,
	},
}
local spawn_dozer_global = {
	enabled = dozer_event,
	on_executed = {
		{ id = 400035, delay = 30 },
		{ id = 400066, delay = 30 },
	},
}
local optsOpenelevator = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102077, notify_unit_sequence = "anim_open_door", time = 0 },
	},
}
local optsCloseelevator = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102077, notify_unit_sequence = "anim_close_door", time = 0 },
	},
}
local Bain_senddozers = {
	dialogue = "play_pln_gen_pol_03",
}
local optsdisable_custom_spawns = {
	enabled = true,
	toggle = "off",
	elements = {
		400040,
		400041,
		400042,
		400043,
		400044,
		400045,
		400067,
		400068,
	},
}

M.elements = {
	-- scripted dozers
	Eclipse.mission_elements.gen_dummy(400040, "bulldozer_1", Vector3(2244, -79, -318.756), Rotation(-90, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400041, "bulldozer_2", Vector3(2244, -24, -318.756), Rotation(-90, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400042, "bulldozer_3", Vector3(-2989, 1439, 0.382), Rotation(-180, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400043, "bulldozer_4", Vector3(-2989, 1337, 0.382), Rotation(-180, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400044, "bulldozer_5", Vector3(-446, -1042, 0.382), Rotation(0, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400045, "bulldozer_6", Vector3(-446, -1098, 0.382), Rotation(0, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400067, "bulldozer_7", Vector3(1761, 276, 0.877), Rotation(0, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400068, "bulldozer_8", Vector3(1682, 276, 0.877), Rotation(0, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_so(400046, "dozer_hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDozerHunt_SO),

	-- scripted dozers stuff
	Eclipse.mission_elements.gen_element_random(400035, "dozer_spawnpoint_select", choose_dozer_spawnpoint),
	Eclipse.mission_elements.gen_element_random(400036, "staircase", dozer_amount_1),
	Eclipse.mission_elements.gen_element_random(400037, "back_entrance_1", dozer_amount_2),
	Eclipse.mission_elements.gen_element_random(400038, "back_entrance_2", dozer_amount_3),
	Eclipse.mission_elements.gen_element_random(400039, "elevator", dozer_amount_4),
	Eclipse.mission_elements.gen_dummytrigger(400047, "dozer_spawned_1", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerspawned_1),
	Eclipse.mission_elements.gen_dummytrigger(400048, "dozer_spawned_2", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerspawned_2),
	Eclipse.mission_elements.gen_dummytrigger(400049, "dozer_spawned_3", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerspawned_3),
	Eclipse.mission_elements.gen_dummytrigger(400050, "dozer_spawned_4", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerspawned_4),
	Eclipse.mission_elements.gen_dummytrigger(400051, "dozer_spawned_5", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerspawned_5),
	Eclipse.mission_elements.gen_dummytrigger(400051, "dozer_spawned_6", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerspawned_6),
	Eclipse.mission_elements.gen_dummytrigger(400069, "dozer_spawned_7", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerspawned_7),
	Eclipse.mission_elements.gen_dummytrigger(400070, "dozer_spawned_8", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerspawned_8),
	Eclipse.mission_elements.gen_dummytrigger(400052, "dozer_died_1", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerdied_1),
	Eclipse.mission_elements.gen_dummytrigger(400053, "dozer_died_2", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerdied_2),
	Eclipse.mission_elements.gen_dummytrigger(400054, "dozer_died_3", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerdied_3),
	Eclipse.mission_elements.gen_dummytrigger(400055, "dozer_died_4", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerdied_4),
	Eclipse.mission_elements.gen_dummytrigger(400056, "dozer_died_5", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerdied_5),
	Eclipse.mission_elements.gen_dummytrigger(400057, "dozer_died_6", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerdied_6),
	Eclipse.mission_elements.gen_dummytrigger(400071, "dozer_died_7", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerdied_7),
	Eclipse.mission_elements.gen_dummytrigger(400072, "dozer_died_8", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsdozerdied_8),
	Eclipse.mission_elements.gen_toggleelement(400058, "disable_random_dozers", optsdisable_random_dozers),
	Eclipse.mission_elements.gen_toggleelement(400059, "enable_random_dozers", optsenable_random_dozers),
	Eclipse.mission_elements.gen_missionscript(400063, "hello_its_me_the_angry_man", spawn_dozer_global),
	Eclipse.mission_elements.gen_dialogue(400066, "they_sending_dozers", Bain_senddozers),
	Eclipse.mission_elements.gen_object_editor(400073, "open_elevator", Vector3(-803, -1370, 3449.999), Rotation(-90, 0, -0), optsOpenelevator),
	Eclipse.mission_elements.gen_object_editor(400074, "close_elevator", Vector3(-803, -1370, 3449.999), Rotation(-90, 0, -0), optsCloseelevator),

	-- misc
	Eclipse.mission_elements.gen_toggleelement(400076, "disable_custom_spawns", optsdisable_custom_spawns),
}
return M
