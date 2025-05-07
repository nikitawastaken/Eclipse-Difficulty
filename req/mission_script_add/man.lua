---@module Undercover
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local cloaker = scripted_enemy.cloaker
local taser = scripted_enemy.taser_1

local optsBesiegeDummyCloaker = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_clk_exit_vent_1_5m",
	enabled = true,
}
local optsPreferedCloakerAdd1 = {
	spawn_groups = { 400004 },
	enabled = hard_and_above,
}
local optsTaser = {
	enemy = taser,
	spawn_action = "e_sp_down_16m_right",
	on_executed = { { id = 400012, delay = 0 } },
	enabled = true,
}
local optsHuntSO = {
	SO_access = "8192",
	path_style = "none",
	scan = true,
	so_action = "AI_hunt",
}
local optsTaserChopper = {
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
	enabled = hard_and_above,
}

M.elements = {
	-- restore cloaker vent spawns and add missing spawns
	Eclipse.mission_elements.gen_dummy(400000, "new_cloaker_1", Vector3(-1260, -2808, 299.986), Rotation(0, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400001, "new_cloaker_2", Vector3(-1440, -2129, 475.001), Rotation(180, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400002, "new_cloaker_3", Vector3(-1326.516, 541.548, 821), Rotation(-90, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400003, "new_cloaker_4", Vector3(-863.956, 485.679, 821), Rotation(90, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_spawngroup(400004, "new_cloaker_spawngroup", { 400000, 400001, 400002, 400003, 103794, 103796, 103797, 103800, 103801 }, 0),

	Eclipse.mission_elements.gen_preferedadd(400005, "new_cloaker_spawns", optsPreferedCloakerAdd1),

	-- taser chopper spawn from PDTH
	Eclipse.mission_elements.gen_dummy(400006, "taser_chopper_1", Vector3(-1804.570, -2569.821, 1961.254), Rotation(83, 0, 0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400007, "taser_chopper_2", Vector3(-1803.140, -2656.642, 1961.254), Rotation(83, 0, 0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400008, "taser_chopper_3", Vector3(-2091.744, -2537.606, 1961.254), Rotation(-90, 0, 0), optsTaser),

	Eclipse.mission_elements.gen_missionscript(400010, "spawn_tasers", optsspawntaserchopper),
	Eclipse.mission_elements.gen_object_editor(400011, "chopper_sequence", Vector3(0, 0, 0), Rotation(0, 0, -0), optsTaserChopper),

	Eclipse.mission_elements.gen_so(400012, "hunt_so", Vector3(0, 0, 0), Rotation(0, 0, 0), optsHuntSO),
}
return M
