---@module Murky Station
local M = {}
local scripted_enemy = Eclipse.scripted_enemy

local murkywater_guard = scripted_enemy.murkywater_1

local optsExtraSecurity = {
	enemy = murkywater_guard,
	spawn_action = "e_sp_run_2m_turn_l_10m", -- there's no other animation that could fit in
	participate_to_group_ai = true,
	enabled = true,
}

local Bain_sendextrasecurity = {
	dialogue = "Play_pln_spawn_01",
}

local optsSpawnExtraSecurity = {
	on_executed = {
		{ id = 400007, delay = 0 },
		{ id = 400006, delay = 0 },
		{ id = 400001, delay = 5 },
		{ id = 400002, delay = 180, delay_rand = 30 },
		{ id = 400003, delay = 300, delay_rand = 30 },
		{ id = 400004, delay = 360, delay_rand = 30 },
	},
	enabled = true,
}
local optsOpen_Gates = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100082, notify_unit_sequence = "open_out", time = 0 },
	},
}

M.elements = {
	-- Add extra security
	Eclipse.mission_elements.gen_dummy(400001, "extra_murky_1", Vector3(4757.644, 1159.446, -700.002), Rotation(46, 0, 0), optsExtraSecurity),
	Eclipse.mission_elements.gen_dummy(400002, "extra_murky_2", Vector3(4757.644, 1159.446, -700.002), Rotation(46, 0, 0), optsExtraSecurity),
	Eclipse.mission_elements.gen_dummy(400003, "extra_murky_3", Vector3(4757.644, 1159.446, -700.002), Rotation(46, 0, 0), optsExtraSecurity),
	Eclipse.mission_elements.gen_dummy(400004, "extra_murky_4", Vector3(4757.644, 1159.446, -700.002), Rotation(46, 0, 0), optsExtraSecurity),
	Eclipse.mission_elements.gen_missionscript(400005, "extra_security_script", optsSpawnExtraSecurity),
	Eclipse.mission_elements.gen_dialogue(400006, "they_sending_security", Bain_sendextrasecurity),

	Eclipse.mission_elements.gen_object_editor(400007, "open_the_gates", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpen_Gates),
}

return M
