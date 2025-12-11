---@module No Mercy

local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local sniper_amount = normal and 2 or hard and 3 or 4
local sniper_amount_random = normal and 3 or hard and 4 or 5
local dozer_random_amount = overkill_and_above and 2 or 1
local elite_snipers_respawn = (is_eclipse and 120 or 180) - (is_pro_job and 30 or 0)
local dozers_respawn = (is_eclipse and 240 or 300) - (is_eclipse_pro and 60 or is_pro_job and 30 or 0)
local dozer_event = not normal or (is_pro_job and normal) and true or false

local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local sniper = scripted_enemy.sniper
local cloaker = scripted_enemy.cloaker

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

local optsEliteSniper_1 = {
	enemy = sniper,
	on_executed = {
		{ id = 400009, delay = 0 },
		{ id = 400009, delay = 10 },
	},
	enabled = true,
}
local optsEliteSniper_2 = {
	enemy = sniper,
	on_executed = {
		{ id = 400006, delay = 0 },
		{ id = 400006, delay = 10 },
	},
	enabled = true,
}
local optsEliteSniper_3 = {
	enemy = sniper,
	on_executed = {
		{ id = 400007, delay = 0 },
		{ id = 400007, delay = 10 },
	},
	enabled = true,
}
local optsEliteSniper_4 = {
	enemy = sniper,
	on_executed = {
		{ id = 400008, delay = 0 },
		{ id = 400008, delay = 10 },
	},
	enabled = true,
}
local optsEliteSniper_5 = {
	enemy = sniper,
	on_executed = {
		{ id = 400005, delay = 0 },
		{ id = 400005, delay = 10 },
	},
	enabled = true,
}
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
	use_instigator = true,
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
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsDozerHunt_SO = {
	SO_access = "4096",
	scan = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_hunt",
}
local disable_sniper_mission_script = {
	enabled = true,
	toggle = "off",
	elements = {
		400010,
	},
}
local enable_sniper_mission_script = {
	enabled = true,
	set_trigger_times = 1,
	elements = {
		400010,
	},
}
local optsdisable_sniper_1 = {
	enabled = true,
	toggle = "off",
	elements = {
		400000,
	},
}
local optsdisable_sniper_2 = {
	enabled = true,
	toggle = "off",
	elements = {
		400001,
	},
}
local optsdisable_sniper_3 = {
	enabled = true,
	toggle = "off",
	elements = {
		400002,
	},
}
local optsdisable_sniper_4 = {
	enabled = true,
	toggle = "off",
	elements = {
		400003,
	},
}
local optsdisable_sniper_5 = {
	enabled = true,
	toggle = "off",
	elements = {
		400004,
	},
}
local optsenable_sniper_1 = {
	enabled = true,
	elements = {
		400000,
	},
}
local optsenable_sniper_2 = {
	enabled = true,
	elements = {
		400001,
	},
}
local optsenable_sniper_3 = {
	enabled = true,
	elements = {
		400002,
	},
}
local optsenable_sniper_4 = {
	enabled = true,
	elements = {
		400003,
	},
}
local otpsenable_sniper_5 = {
	enabled = true,
	elements = {
		400004,
	},
}

local optssniperdied_1 = {
	on_executed = {
		{ id = 400011, delay = 1 },
		{ id = 400010, delay = elite_snipers_respawn },
		{ id = 400032, delay = 0 },
	},
	elements = {
		400000,
	},
	event = "death",
}
local optssniperdied_2 = {
	on_executed = {
		{ id = 400012, delay = 1 },
		{ id = 400010, delay = elite_snipers_respawn },
		{ id = 400032, delay = 0 },
	},
	elements = {
		400001,
	},
	event = "death",
}
local optssniperdied_3 = {
	on_executed = {
		{ id = 400013, delay = 1 },
		{ id = 400010, delay = elite_snipers_respawn },
		{ id = 400032, delay = 0 },
	},
	elements = {
		400002,
	},
	event = "death",
}
local optssniperdied_4 = {
	on_executed = {
		{ id = 400014, delay = 1 },
		{ id = 400010, delay = elite_snipers_respawn },
		{ id = 400032, delay = 0 },
	},
	elements = {
		400003,
	},
	event = "death",
}
local optssniperdied_5 = {
	on_executed = {
		{ id = 400015, delay = 1 },
		{ id = 400010, delay = elite_snipers_respawn },
		{ id = 400032, delay = 0 },
	},
	elements = {
		400004,
	},
	event = "death",
}
local optssniperspawned_1 = {
	on_executed = {
		{ id = 400016, delay = 1 },
		{ id = 400031, delay = 0 },
	},
	elements = {
		400000,
	},
}
local optssniperspawned_2 = {
	on_executed = {
		{ id = 400017, delay = 1 },
		{ id = 400031, delay = 0 },
	},
	elements = {
		400001,
	},
}
local optssniperspawned_3 = {
	on_executed = {
		{ id = 400018, delay = 1 },
		{ id = 400031, delay = 0 },
	},
	elements = {
		400002,
	},
}
local optssniperspawned_4 = {
	on_executed = {
		{ id = 400019, delay = 1 },
		{ id = 400031, delay = 0 },
	},
	elements = {
		400003,
	},
}
local optssniperspawned_5 = {
	on_executed = {
		{ id = 400020, delay = 1 },
		{ id = 400031, delay = 0 },
	},
	elements = {
		400004,
	},
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
local spawn_random_snipers = {
	amount = sniper_amount,
	amount_random = sniper_amount_random,
	trigger_times = 1,
	on_executed = {
		{ id = 400000, delay = 0 },
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
		{ id = 400003, delay = 0 },
		{ id = 400004, delay = 0 },
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
	set_trigger_times = 1,
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
local spawn_snipers_global = {
	enabled = is_eclipse,
	trigger_times = 1,
	on_executed = {
		{ id = 400010, delay = 0 },
		{ id = 400033, delay = 0 },
	},
}
local optsOpenelevator = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102077, notify_unit_sequence = "anim_open_door", time = 0 },
	},
}
local optsCloseelevator = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102077, notify_unit_sequence = "anim_close_door", time = 0 },
	},
}
local Bain_sendsnipers = {
	dialogue = "play_pln_gen_snip_06",
}
local Bain_senddozers = {
	dialogue = "play_pln_gen_pol_03",
}
local optsdisable_custom_spawns = {
	enabled = true,
	toggle = "off",
	elements = {
		400000,
		400001,
		400002,
		400003,
		400004,
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

local optsdisable_elevator_corner_collisions = {
	unit_ids = {
		105419,
		105417,
		105418,
		105420,
	},
}

M.elements = {
	-- elite snipers in no mercy (Notoriety reference)
	Eclipse.mission_elements.gen_dummy(400000, "notoriety_sniper_1", Vector3(2295, 16, -318.756), Rotation(-90, 0, 0), optsEliteSniper_1),
	Eclipse.mission_elements.gen_dummy(400001, "notoriety_sniper_2", Vector3(-487, -1010, 0.382), Rotation(0, 0, 0), optsEliteSniper_2),
	Eclipse.mission_elements.gen_dummy(400002, "notoriety_sniper_3", Vector3(-2903, 1210, 0.382), Rotation(180, 0, 0), optsEliteSniper_3),
	Eclipse.mission_elements.gen_dummy(400003, "notoriety_sniper_4", Vector3(246, 392, 350.084), Rotation(180, 0, 0), optsEliteSniper_4),
	Eclipse.mission_elements.gen_dummy(400004, "notoriety_sniper_5", Vector3(-2080, 3747, 350.084), Rotation(180, 0, 0), optsEliteSniper_5),
	Eclipse.mission_elements.gen_so(400005, "sniper_spot_so_1", Vector3(-2171.321, 2713.038, 0.382), Rotation(-84, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400006, "sniper_spot_so_2", Vector3(-1131, -277, 0.382), Rotation(14, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400007, "sniper_spot_so_3", Vector3(-2164.963, 701.083, 0.382), Rotation(-95, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400008, "sniper_spot_so_4", Vector3(732.785, 1330.852, -0.118), Rotation(-178, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400009, "sniper_spot_so_5", Vector3(3618, -89, 0.382), Rotation(90, 0, 0), optsSniper_SO),

	-- elite sniper spawn stuff
	Eclipse.mission_elements.gen_element_random(400010, "notoriety_sniper_event", spawn_random_snipers),
	Eclipse.mission_elements.gen_toggleelement(400011, "enable_sniper_1", optsenable_sniper_1),
	Eclipse.mission_elements.gen_toggleelement(400012, "enable_sniper_2", optsenable_sniper_2),
	Eclipse.mission_elements.gen_toggleelement(400013, "enable_sniper_3", optsenable_sniper_3),
	Eclipse.mission_elements.gen_toggleelement(400014, "enable_sniper_4", optsenable_sniper_4),
	Eclipse.mission_elements.gen_toggleelement(400015, "enable_sniper_5", optsenable_sniper_5),
	Eclipse.mission_elements.gen_toggleelement(400016, "disable_sniper_1", optsdisable_sniper_1),
	Eclipse.mission_elements.gen_toggleelement(400017, "disable_sniper_2", optsdisable_sniper_2),
	Eclipse.mission_elements.gen_toggleelement(400018, "disable_sniper_3", optsdisable_sniper_3),
	Eclipse.mission_elements.gen_toggleelement(400019, "disable_sniper_4", optsdisable_sniper_4),
	Eclipse.mission_elements.gen_toggleelement(400020, "disable_sniper_5", optsdisable_sniper_5),
	Eclipse.mission_elements.gen_dummytrigger(400021, "sniper_spawned_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperspawned_1),
	Eclipse.mission_elements.gen_dummytrigger(400022, "sniper_spawned_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperspawned_2),
	Eclipse.mission_elements.gen_dummytrigger(400023, "sniper_spawned_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperspawned_3),
	Eclipse.mission_elements.gen_dummytrigger(400024, "sniper_spawned_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperspawned_4),
	Eclipse.mission_elements.gen_dummytrigger(400025, "sniper_spawned_5", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperspawned_5),
	Eclipse.mission_elements.gen_dummytrigger(400026, "sniper_died_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperdied_1),
	Eclipse.mission_elements.gen_dummytrigger(400027, "sniper_died_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperdied_2),
	Eclipse.mission_elements.gen_dummytrigger(400028, "sniper_died_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperdied_3),
	Eclipse.mission_elements.gen_dummytrigger(400029, "sniper_died_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperdied_4),
	Eclipse.mission_elements.gen_dummytrigger(400030, "sniper_died_5", Vector3(0, 0, 0), Rotation(0, 0, 0), optssniperdied_5),
	Eclipse.mission_elements.gen_toggleelement(400031, "disable_random_snipers", disable_sniper_mission_script),
	Eclipse.mission_elements.gen_toggleelement(400032, "enable_random_snipers", enable_sniper_mission_script),
	Eclipse.mission_elements.gen_dialogue(400033, "they_sending_snipers", Bain_sendsnipers),
	Eclipse.mission_elements.gen_missionscript(400034, "notoriety_snipers_event_global", spawn_snipers_global),

	-- scripted dozers
	Eclipse.mission_elements.gen_dummy(400040, "bulldozer_1", Vector3(2244, -79, -318.756), Rotation(-90, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400041, "bulldozer_2", Vector3(2244, -24, -318.756), Rotation(-90, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400042, "bulldozer_3", Vector3(-2989, 1439, 0.382), Rotation(-180, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400043, "bulldozer_4", Vector3(-2989, 1337, 0.382), Rotation(-180, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400044, "bulldozer_5", Vector3(-446, -1042, 0.382), Rotation(0, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400045, "bulldozer_6", Vector3(-446, -1098, 0.382), Rotation(0, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400067, "bulldozer_7", Vector3(1761, 276, 0.877), Rotation(0, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400068, "bulldozer_8", Vector3(1682, 276, 0.877), Rotation(0, 0, 0), optsBulldozer),
	Eclipse.mission_elements.gen_so(400046, "dozer_hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDozerHunt_SO),

	-- scripted dozers stuff
	Eclipse.mission_elements.gen_element_random(400035, "dozer_spawnpoint_select", choose_dozer_spawnpoint),
	Eclipse.mission_elements.gen_element_random(400036, "staircase", dozer_amount_1),
	Eclipse.mission_elements.gen_element_random(400037, "back_entrance_1", dozer_amount_2),
	Eclipse.mission_elements.gen_element_random(400038, "back_entrance_2", dozer_amount_3),
	Eclipse.mission_elements.gen_element_random(400039, "elevator", dozer_amount_4),
	Eclipse.mission_elements.gen_dummytrigger(400047, "dozer_spawned_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_1),
	Eclipse.mission_elements.gen_dummytrigger(400048, "dozer_spawned_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_2),
	Eclipse.mission_elements.gen_dummytrigger(400049, "dozer_spawned_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_3),
	Eclipse.mission_elements.gen_dummytrigger(400050, "dozer_spawned_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_4),
	Eclipse.mission_elements.gen_dummytrigger(400051, "dozer_spawned_5", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_5),
	Eclipse.mission_elements.gen_dummytrigger(400051, "dozer_spawned_6", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_6),
	Eclipse.mission_elements.gen_dummytrigger(400069, "dozer_spawned_7", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_7),
	Eclipse.mission_elements.gen_dummytrigger(400070, "dozer_spawned_8", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerspawned_8),
	Eclipse.mission_elements.gen_dummytrigger(400052, "dozer_died_1", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_1),
	Eclipse.mission_elements.gen_dummytrigger(400053, "dozer_died_2", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_2),
	Eclipse.mission_elements.gen_dummytrigger(400054, "dozer_died_3", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_3),
	Eclipse.mission_elements.gen_dummytrigger(400055, "dozer_died_4", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_4),
	Eclipse.mission_elements.gen_dummytrigger(400056, "dozer_died_5", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_5),
	Eclipse.mission_elements.gen_dummytrigger(400057, "dozer_died_6", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_6),
	Eclipse.mission_elements.gen_dummytrigger(400071, "dozer_died_7", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_7),
	Eclipse.mission_elements.gen_dummytrigger(400072, "dozer_died_8", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdozerdied_8),
	Eclipse.mission_elements.gen_toggleelement(400058, "disable_random_dozers", optsdisable_random_dozers),
	Eclipse.mission_elements.gen_toggleelement(400059, "enable_random_dozers", optsenable_random_dozers),
	Eclipse.mission_elements.gen_missionscript(400063, "hello_its_me_the_angry_man", spawn_dozer_global),
	Eclipse.mission_elements.gen_dialogue(400066, "they_sending_dozers", Bain_senddozers),
	Eclipse.mission_elements.gen_object_editor(400073, "open_elevator", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpenelevator),
	Eclipse.mission_elements.gen_object_editor(400074, "close_elevator", Vector3(0, 0, 0), Rotation(0, 0, 0), optsCloseelevator),

	-- misc
	Eclipse.mission_elements.gen_toggleelement(400076, "disable_custom_spawns", optsdisable_custom_spawns),
	Eclipse.mission_elements.gen_disable_unit(400077, "disable_elevator_right_corner_collisions", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdisable_elevator_corner_collisions),
}
return M
