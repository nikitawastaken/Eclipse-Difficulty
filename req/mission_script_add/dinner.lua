---@module Slaughterhouse
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse = Eclipse.utils.is_eclipse()
local ambush_amount = 1 + (is_pro_job and 1 or 0)

local enabled_chance_snipers = math.random() <= 0.45

local shield = scripted_enemy.shield
local sniper = scripted_enemy.sniper
local taser = scripted_enemy.taser_1
local cloaker = scripted_enemy.cloaker
local elite_bulldozer_skull = scripted_enemy.elite_bulldozer_2
local elite_bulldozer_neil = scripted_enemy.elite_bulldozer_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2

local bags_required = (is_eclipse and 6 or 4) + (is_pro_job and 2 or 0)

local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_bulldozer_neil,
	elite_bulldozer_skull,
}

local spawn_cloakers = {
	enabled = normal_and_above,
	on_executed = {
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
		{ id = 400003, delay = 0 },
	},
}
local spawn_shields_and_taser_1 = {
	enabled = true,
	on_executed = {
		{ id = 400004, delay = 0 },
		{ id = 400005, delay = 0 },
		{ id = 400006, delay = 0 },
	},
}
local spawn_shields_and_taser_2 = {
	enabled = true,
	on_executed = {
		{ id = 400007, delay = 0 },
		{ id = 400008, delay = 0 },
		{ id = 400009, delay = 0 },
	},
}
local spawn_shields_and_dozer = {
	enabled = normal_and_above,
	on_executed = {
		{ id = 400010, delay = 0 },
		{ id = 400011, delay = 0 },
		{ id = 400012, delay = 0 },
	},
}
local spawn_random_ambush = {
	amount = ambush_amount,
	on_executed = {
		{ id = 400050, delay = 0 },
		{ id = 400051, delay = 0 },
		{ id = 400052, delay = 0 },
		{ id = 400053, delay = 0 },
	},
}
local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsCloaker = {
	enemy = cloaker,
	on_executed = {
		{ id = 400057, delay = 3 },
	},
	enabled = true,
}
local optsTaser = {
	enemy = taser,
	on_executed = {
		{ id = 400057, delay = 3 },
	},
	enabled = true,
}
local optsShield = {
	enemy = shield,
	on_executed = {
		{ id = 400057, delay = 3 },
	},
	enabled = true,
}
local optsBulldozer_Ambush = {
	enemy = green_bulldozer,
	on_executed = {
		{ id = 400057, delay = 3 },
	},
	enabled = true,
}
local optsSniper_1 = {
	enemy = sniper,
	spawn_action = "e_sp_up_ledge",
	on_executed = {
		{ id = 400029, delay = 0 },
	},
	enabled = true,
}
local optsSniper_2 = {
	enemy = sniper,
	spawn_action = "e_sp_up_ledge",
	on_executed = {
		{ id = 400030, delay = 0 },
	},
	enabled = true,
}
local spawn_dozer_1 = {
	enabled = true,
	trigger_times = 1,
	on_executed = {
		{ id = 400019, delay = 0 },
	},
}
local spawn_dozer_2 = {
	enabled = true,
	trigger_times = 1,
	on_executed = {
		{ id = 400020, delay = 0 },
	},
}
local optsBulldozer = {
	enemy = green_bulldozer,
	on_executed = {
		{ id = 400021, delay = 0 },
	},
	enabled = true,
}
local optsBulldozer_SO = {
	SO_access = "4096",
	path_style = "none",
	scan = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_hunt",
}
local optsHunt_SO = {
	SO_access = tostring(1024 + 2048 + 4096 + 8192),
	path_style = "none",
	scan = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_hunt",
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
local optsrespawn_dozer_1 = {
	on_executed = {
		{ id = 400019, delay = 180 },
	},
	elements = {
		400019,
	},
	event = "death",
}
local optsrespawn_dozer_2 = {
	on_executed = {
		{ id = 400020, delay = 180 },
	},
	elements = {
		400020,
	},
	event = "death",
}
local disable_dozer = {
	enabled = true,
	toggle = "off",
	elements = {
		400019,
	},
}
local spawn_snipers = {
	enabled = normal_and_above and enabled_chance_snipers,
	on_executed = {
		{ id = 400027, delay = 0 },
		{ id = 400028, delay = 0 },
	},
}
local optsSpecialChopper = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100007, notify_unit_sequence = "swat", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100007, notify_unit_sequence = "flyin_fwd_hover", time = 0 },
		{ id = 3, name = "run_sequence", notify_unit_id = 100007, notify_unit_sequence = "open_door_left", time = 24 },
		{ id = 4, name = "run_sequence", notify_unit_id = 100007, notify_unit_sequence = "open_door_right", time = 24 },
		{ id = 5, name = "run_sequence", notify_unit_id = 100007, notify_unit_sequence = "close_door_left", time = 36 },
		{ id = 6, name = "run_sequence", notify_unit_id = 100007, notify_unit_sequence = "close_door_right", time = 36 },
		{ id = 7, name = "run_sequence", notify_unit_id = 100007, notify_unit_sequence = "hover_flyout_right", time = 39 },
		{ id = 8, name = "run_sequence", notify_unit_id = 100007, notify_unit_sequence = "hidden", time = 65 },
	},
}
local optsTaser_heli = {
	enemy = taser,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400057, delay = 0 } },
	enabled = true,
}
local optsCloaker_heli = {
	enemy = cloaker,
	spawn_action = "e_sp_down_16m_left",
	on_executed = { { id = 400057, delay = 0 } },
	enabled = true,
}
local optsDozer_heli = {
	enemy_table = is_eclipse and random_elite_dozers or random_dozers,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400057, delay = 0 } },
	enabled = true,
}
local optsspawnspecial_chopper = {
	on_executed = { { id = 400059, delay = 26 }, { id = 400060, delay = 26 }, { id = 400061, delay = 26 }, { id = 400063, delay = 0 } },
	enabled = normal_and_above,
}
local optsNewAmbushTrigger = {
	width = 800,
	depth = 800,
	on_executed = {
		{ id = 400058, delay = 0 },
	},
}
local optsinstance_bag_requirment = {
	instance = "obj_link_005",
	params = {
		var_amount_death_wish = bags_required,
		var_amount_hard = bags_required,
		var_amount_normal = bags_required,
		var_amount_overkill = bags_required,
		var_amount_very_hard = bags_required,
		var_objective = "dinner_hide",
	},
}
local optshideSwatVan = {
	unit_ids = {
		100620,
	},
}

M.elements = {
	--Ambush
	Eclipse.mission_elements.gen_dummy(400001, "cloaker_1", Vector3(-12545, 7176, 4.995), Rotation(-180, 0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400002, "cloaker_2", Vector3(-12458, 7282, 4.995), Rotation(-180, 0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400003, "cloaker_3", Vector3(-12607, 7282, 4.995), Rotation(-180, 0, -0), optsCloaker),
	Eclipse.mission_elements.gen_dummy(400004, "shield_1", Vector3(-12073, 7142, 4.995), Rotation(-180, 0, -0), optsShield),
	Eclipse.mission_elements.gen_dummy(400005, "shield_2", Vector3(-11981, 7142, 4.995), Rotation(-180, 0, -0), optsShield),
	Eclipse.mission_elements.gen_dummy(400006, "taser_1", Vector3(-12023, 7209, 4.995), Rotation(-180, 0, -0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400007, "shield_3", Vector3(-13408, 7176, 4.995), Rotation(-180, 0, -0), optsShield),
	Eclipse.mission_elements.gen_dummy(400008, "shield_4", Vector3(-13334, 7176, 4.995), Rotation(-180, 0, -0), optsShield),
	Eclipse.mission_elements.gen_dummy(400009, "taser_2", Vector3(-13371, 7262, 4.995), Rotation(-180, 0, -0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400010, "shield_3", Vector3(-13666, 6195, 4.995), Rotation(0, 0, -0), optsShield),
	Eclipse.mission_elements.gen_dummy(400011, "shield_4", Vector3(-13756, 6195, 4.995), Rotation(0, 0, -0), optsShield),
	Eclipse.mission_elements.gen_dummy(400012, "bulldozer_1", Vector3(-13707, 6078, 4.995), Rotation(0, 0, -0), optsBulldozer_Ambush),

	--Dozers
	Eclipse.mission_elements.gen_dummy(400019, "bulldozer_2", Vector3(-8785, 3730, -72), Rotation(-90, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_dummy(400020, "bulldozer_3", Vector3(-13231, 6749, 889.902), Rotation(90, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_so(400021, "dozer_hunt_so", Vector3(3600, 2473, -1200), Rotation(0, 0, 0), optsBulldozer_SO),

	--Van Spawngroup
	Eclipse.mission_elements.gen_dummy(400022, "van_dummy_1", Vector3(-15438.496, 5177.672, -81.025), Rotation(170, 0, -0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400023, "van_dummy_2", Vector3(-15371.752, 5177.833, -81.025), Rotation(172, 0, -0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400024, "van_dummy_3", Vector3(-15495.743, 4220.271, -81.025), Rotation(-171, 0, -0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400025, "van_dummy_4", Vector3(-15430.557, 4230.596, -81.025), Rotation(-171, 0, -0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400026, "van_spawngroup", { 400022, 400023, 400024, 400025 }, 5),

	--Snipers
	Eclipse.mission_elements.gen_dummy(400027, "sniper_1", Vector3(-13496, 6470, 889.902), Rotation(90, 0, 0), optsSniper_1),
	Eclipse.mission_elements.gen_dummy(400028, "sniper_2", Vector3(-20101, 6888, 747.404), Rotation(90, 0, 0), optsSniper_2),
	Eclipse.mission_elements.gen_so(400029, "sniper_so_1", Vector3(-19603, 6971, 747.404), Rotation(-90, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400030, "sniper_so_2", Vector3(-16155, 9187, 1012.404), Rotation(180, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_missionscript(400031, "spawn_snipers", spawn_snipers),

	--Respawns
	Eclipse.mission_elements.gen_dummytrigger(400043, "respawn_dozer_1", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsrespawn_dozer_1),
	Eclipse.mission_elements.gen_dummytrigger(400044, "respawn_dozer_2", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsrespawn_dozer_2),
	Eclipse.mission_elements.gen_toggleelement(400045, "disable_dozer", disable_dozer),
	Eclipse.mission_elements.gen_missionscript(400050, "spawn_cloakers", spawn_cloakers),
	Eclipse.mission_elements.gen_missionscript(400051, "spawn_shields_and_taser_1", spawn_shields_and_taser_1),
	Eclipse.mission_elements.gen_missionscript(400052, "spawn_shields_and_taser_2", spawn_shields_and_taser_2),
	Eclipse.mission_elements.gen_missionscript(400053, "spawn_shields_and_dozer", spawn_shields_and_dozer),
	Eclipse.mission_elements.gen_element_random(400058, "ambush_event", spawn_random_ambush),
	Eclipse.mission_elements.gen_missionscript(400054, "spawn_dozer_1", spawn_dozer_1),
	Eclipse.mission_elements.gen_missionscript(400055, "spawn_dozer_2", spawn_dozer_2),
	Eclipse.mission_elements.gen_so(400057, "hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsHunt_SO),

	--Revenge chopper
	Eclipse.mission_elements.gen_dummy(400059, "dozer_heli", Vector3(-15400.147, 6491.773, -73), Rotation(143, 0, 0), optsDozer_heli),
	Eclipse.mission_elements.gen_dummy(400060, "taser_heli", Vector3(-15460.844, 6537.511, -73), Rotation(143, 0, 0), optsTaser_heli),
	Eclipse.mission_elements.gen_dummy(400061, "cloaker_heli", Vector3(-15670.720, 6344.092, -73), Rotation(0, 0, 0), optsCloaker_heli),

	Eclipse.mission_elements.gen_missionscript(400062, "special_chopper_event", optsspawnspecial_chopper),
	Eclipse.mission_elements.gen_object_editor(400063, "revenge_chopper", Vector3(0, 0, 0), Rotation(0, 0, -0), optsSpecialChopper),
	-- new area trigger for the Ambush
	Eclipse.mission_elements.gen_areatrigger(400064, "new_area_trigger_ambush", Vector3(-12657, 6709, 104.007), Rotation(0, 0, 0), optsNewAmbushTrigger),
	-- change bag requirments
	Eclipse.mission_elements.gen_instance_params(400065, "new_bag_requirment", Vector3(0, 0, 0), Rotation(0, 0, 0), optsinstance_bag_requirment),
	-- disable odd swat van
	Eclipse.mission_elements.gen_disable_unit(400066, "hide_swat_van", Vector3(0, 0, 0), Rotation(0, 0, 0), optshideSwatVan),
}

return M
