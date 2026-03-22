---@module Shadow Raid
local M = {}
local scripted_enemy = Eclipse.scripted_enemy

local murkywater_guard = scripted_enemy.murkywater_1

local optsExtraSecurity = {
	enemy = murkywater_guard,
	participate_to_group_ai = true,
	on_executed = {
		{ id = 104780, delay = 0 }, -- this here is just for preventing guards from getting stuck
	},
	enabled = true,
}

local Bain_sendextrasecurity = {
	dialogue = "Play_pln_spawn_01",
}

local optsSpawnExtraSecurity = {
	on_executed = {
		{ id = 400003, delay = 0 },
		{ id = 400004, delay = 0 },
		{ id = 103509, delay = 0 },
		{ id = 400001, delay = 5 },
		{ id = 400001, delay = 180, delay_rand = 30 },
		{ id = 400001, delay = 300, delay_rand = 30 },
	},
	enabled = true,
	trigger_times = 1,
}
local enable_open_gates = {
	enabled = true,
	elements = {
		400004,
	},
}
local optsOpen_Gates = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102390, notify_unit_sequence = "open_in", time = 0 },
	},
}

M.elements = {
	-- Add extra security
	Eclipse.mission_elements.gen_dummy(400001, "extra_murky", Vector3(6763, 431, 980), Rotation(180, 0, 0), optsExtraSecurity),
	Eclipse.mission_elements.gen_missionscript(400002, "extra_security_script", optsSpawnExtraSecurity),
	Eclipse.mission_elements.gen_dialogue(400003, "they_sending_security", Bain_sendextrasecurity),
	
	Eclipse.mission_elements.gen_object_editor(400004, "open_the_gates_if_closed", Vector3(0, 0, 0), Rotation(0, 0, 0), optsOpen_Gates),
	Eclipse.mission_elements.gen_toggleelement(400005, "enable_open_the_gates", enable_open_gates),

}

return M
