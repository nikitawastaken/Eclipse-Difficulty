---@module Big Bank
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local cloaker_amount = (is_eclipse and 3 or 2) + (is_pro_job and 1 or 0)

local cloaker = scripted_enemy.cloaker

local enabled_chance_cloakers = math.random() <= 0.4 + (is_pro_job and 0.2 or 0)

local optsCloaker_1 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400005, delay = 0 } },
	enabled = overkill_and_above and enabled_chance_cloakers,
}
local optsCloaker_2 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400006, delay = 0 } },
	enabled = overkill_and_above and enabled_chance_cloakers,
}
local optsCloaker_3 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400007, delay = 0 } },
	enabled = overkill_and_above and enabled_chance_cloakers,
}
local optsCloaker_4 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400008, delay = 0 } },
	enabled = overkill_and_above and enabled_chance_cloakers,
}
local optsCloaker_5 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400009, delay = 0 } },
	enabled = overkill_and_above and enabled_chance_cloakers,
}
local optsCloaker_Hide_SO_1 = {
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
local optsCloaker_Hide_SO_2 = {
	SO_access = "1024",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interrupt_dis = 5,
	interrupt_dmg = 0.3,
	interval = 2,
	so_action = "e_so_sneak_wait_stand",
}
local optsDisable_cloakers = {
	toggle = "off",
	enabled = true,
	elements = {
		400012,
	},
}
local optsEnable_cloakers = {
	enabled = true,
	elements = {
		400012,
	},
}
local spawn_random_cloakers = {
	amount = cloaker_amount,
	on_executed = {
		{ id = 400000, delay = 0 },
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
		{ id = 400003, delay = 0 },
		{ id = 400004, delay = 0 },
	},
}

local optsBesiegeDummy = {
	trigger_times = 0,
	participate_to_group_ai = true,
	spawn_action = "e_sp_down_10m_swing_in_var2",
	enabled = true,
}
local optsPreferedAdd = {
	spawn_groups = { 400019 },
	on_executed = {
		{ id = 400021, delay = 0 },
	},
	enabled = true,
}
local optsOpen_the_elevator = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103057, notify_unit_sequence = "open_doors", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 103070, notify_unit_sequence = "open_doors", time = 0 },
	},
}

M.elements = {
	-- cloakers, spawn as ambush in vault hallway (similiar to First World Bank)
	Eclipse.mission_elements.gen_dummy(400000, "spooc_1", Vector3(-2864, 746, -1000), Rotation(-180, 0, -0), optsCloaker_1),
	Eclipse.mission_elements.gen_dummy(400001, "spooc_2", Vector3(-2864, -1449, -599), Rotation(0, 0, -0), optsCloaker_2),
	Eclipse.mission_elements.gen_dummy(400002, "spooc_3", Vector3(-2098, 416, -998), Rotation(-177, 0, -0), optsCloaker_3),
	Eclipse.mission_elements.gen_dummy(400003, "spooc_4", Vector3(-2135.105, 1124.028, -998), Rotation(90, -0, -0), optsCloaker_4),
	Eclipse.mission_elements.gen_dummy(400004, "spooc_5", Vector3(-2690, 1478, -599), Rotation(-180, -0, -0), optsCloaker_5),
	Eclipse.mission_elements.gen_so(400005, "spooc_hide_so_1", Vector3(-2830, 375, -1000), Rotation(-180, 0, -0), optsCloaker_Hide_SO_1),
	Eclipse.mission_elements.gen_so(400006, "spooc_hide_so_2", Vector3(-2854, -1158, -597), Rotation(0, 0, -0), optsCloaker_Hide_SO_1),
	Eclipse.mission_elements.gen_so(400007, "spooc_hide_so_3", Vector3(-2104.004, 52.529, -1000), Rotation(89, -0, -0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400008, "spooc_hide_so_4", Vector3(-2858.536, 1231.877, -1000), Rotation(89, -0, -0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400009, "spooc_hide_so_5", Vector3(-2475, 1258, -599), Rotation(-180, 0, 0), optsCloaker_Hide_SO_1),

	Eclipse.mission_elements.gen_toggleelement(400010, "enable_cloakers", optsEnable_cloakers),
	Eclipse.mission_elements.gen_toggleelement(400011, "disable_cloakers", optsDisable_cloakers),
	Eclipse.mission_elements.gen_element_random(400012, "cloaker_ambush_event", spawn_random_cloakers),

	-- 3rd elevator spawn
	Eclipse.mission_elements.gen_dummy(400013, "eclipse_spawn_enemy_001", Vector3(-745, -804, -600), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400015, "eclipse_spawn_enemy_002", Vector3(-858, -804, -600), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400016, "eclipse_spawn_enemy_003", Vector3(-1130, -804, -600), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400018, "eclipse_spawn_enemy_004", Vector3(-1268, -804, -600), Rotation(0, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400019, "eclipse_enemy_group_001", { 400013, 400015, 400016, 400018 }, 0),

	Eclipse.mission_elements.gen_preferedadd(400020, "eclipse_3rd_elevator_spawn", optsPreferedAdd),
	Eclipse.mission_elements.gen_object_editor(400021, "hit_it", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpen_the_elevator),
}
return M
