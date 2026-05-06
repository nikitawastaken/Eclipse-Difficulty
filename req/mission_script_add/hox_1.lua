---@module Hoxton Breakout Day 1
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local cloaker_amount = 3
local cloaker_amount_random = overkill_and_above and 1 or 0

local cloaker = scripted_enemy.cloaker

local enabled_chance_cloakers = math.random() <= 0.3 + (is_pro_job and 0.2 or 0)

local optsCloaker_1 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400006, delay = 0 } },
	enabled = normal_and_above and enabled_chance_cloakers,
}
local optsCloaker_2 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400007, delay = 0 } },
	enabled = normal_and_above and enabled_chance_cloakers,
}
local optsCloaker_3 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400008, delay = 0 } },
	enabled = normal_and_above and enabled_chance_cloakers,
}
local optsCloaker_4 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400009, delay = 0 } },
	enabled = normal_and_above and enabled_chance_cloakers,
}
local optsCloaker_5 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400010, delay = 0 } },
	enabled = normal_and_above and enabled_chance_cloakers,
}
local optsCloaker_6 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400011, delay = 0 } },
	enabled = normal_and_above and enabled_chance_cloakers,
}
local optsCloaker_Hide_SO_1 = {
	SO_access = "1024",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interrupt_dis = 7,
	interrupt_dmg = 0,
	interval = 2,
	so_action = "e_so_sneak_wait_crh_var3",
}
local optsCloaker_Hide_SO_2 = {
	SO_access = "1024",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interrupt_dis = 7,
	interrupt_dmg = 0,
	interval = 2,
	so_action = "e_so_hide_under_car_enter",
}
local optsCloaker_Hide_SO_3 = {
	SO_access = "1024",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interrupt_dis = 7,
	interrupt_dmg = 0,
	interval = 2,
	so_action = "e_so_sneak_wait_crh",
}
local spawn_random_cloakers = {
	amount = cloaker_amount,
	amount_random = cloaker_amount_random,
	on_executed = {
		{ id = 400000, delay = 0 },
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
		{ id = 400003, delay = 0 },
		{ id = 400004, delay = 0 },
	},
}

M.elements = {
	-- Cloakers in the garage
	Eclipse.mission_elements.gen_dummy(400000, "garage_spooc_1", Vector3(8467, 5939, -2400), Rotation(-90, 0, 0), optsCloaker_1),
	Eclipse.mission_elements.gen_dummy(400001, "garage_spooc_2", Vector3(11876, 6918, -200.450), Rotation(0, 0, 0), optsCloaker_2),
	Eclipse.mission_elements.gen_dummy(400002, "garage_spooc_3", Vector3(11544, 5074, -2800), Rotation(-90, 0, 0), optsCloaker_3),
	Eclipse.mission_elements.gen_dummy(400003, "garage_spooc_4", Vector3(12247, 5204, -2400), Rotation(-68, 0, 0), optsCloaker_4),
	Eclipse.mission_elements.gen_dummy(400004, "garage_spooc_5", Vector3(10769, 7915, -2578.823), Rotation(-90, 0, 0), optsCloaker_5),
	Eclipse.mission_elements.gen_dummy(400005, "garage_spooc_6", Vector3(9069, 6929, -2800), Rotation(0, 0, 0), optsCloaker_6),
	Eclipse.mission_elements.gen_so(400006, "spooc_hide_so_1", Vector3(8494, 5938, -2400), Rotation(-90, 0, 0), optsCloaker_Hide_SO_1),
	Eclipse.mission_elements.gen_so(400007, "spooc_hide_so_2", Vector3(11874, 6997, -2000.458), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400008, "spooc_hide_so_3", Vector3(11602, 5075, -2800), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400009, "spooc_hide_so_4", Vector3(12201, 5165, -2400), Rotation(-52, 0, 0), optsCloaker_Hide_SO_3),
	Eclipse.mission_elements.gen_so(400010, "spooc_hide_so_5", Vector3(10851.183, 7925.074, -2563.219), Rotation(-90, 0, 0), optsCloaker_Hide_SO_2),
	Eclipse.mission_elements.gen_so(400011, "spooc_hide_so_6", Vector3(9075, 7099, -2800), Rotation(0, 0, 0), optsCloaker_Hide_SO_2),

	Eclipse.mission_elements.gen_element_random(400012, "cloaker_ambush_event", spawn_random_cloakers),
}
return M
