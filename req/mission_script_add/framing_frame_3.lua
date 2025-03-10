local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local sniper = scripted_enemy.sniper

local optsSniper_1 = {
	enemy = sniper,
	spawn_action = "e_sp_down_9_6m",
	on_executed = {
		{ id = 400005, delay = 0 },
	},
	enabled = true,
}
local optsSniper_2 = {
	enemy = sniper,
	spawn_action = "e_sp_down_9_6m",
	on_executed = {
		{ id = 400006, delay = 0 },
	},
	enabled = true,
}
local optsSniper_3 = {
	enemy = sniper,
	on_executed = {
		{ id = 400007, delay = 0 },
	},
	enabled = true,
}
local optsSniper_4 = {
	enemy = sniper,
	on_executed = {
		{ id = 400008, delay = 0 },
	},
	enabled = true,
}
local optsrespawn_sniper_1 = {
	on_executed = {
		{ id = 400001, delay = 45, delay_rand = 10 },
	},
	elements = {
		400001,
	},
	event = "death",
}
local optsrespawn_sniper_2 = {
	on_executed = {
		{ id = 400002, delay = 45, delay_rand = 10 },
	},
	elements = {
		400002,
	},
	event = "death",
}
local optsrespawn_sniper_3 = {
	on_executed = {
		{ id = 400003, delay = 45, delay_rand = 10 },
	},
	elements = {
		400003,
	},
	event = "death",
}
local optsrespawn_sniper_4 = {
	on_executed = {
		{ id = 400004, delay = 45, delay_rand = 10 },
	},
	elements = {
		400004,
	},
	event = "death",
}
local optsSniper_SO = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local Bain_sendsnipers = {
	dialogue = "play_pln_gen_snip_01",
}
local spawn_snipers = {
	enabled = true,
	trigger_times = 1,
	on_executed = {
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
		{ id = 400003, delay = 0 },
		{ id = 400004, delay = 0 },
		{ id = 400010, delay = 0 },
	},
}
local Bain_sendsnipers = {
	dialogue = "play_pln_gen_snip_01",
	can_not_be_muted = true,
}

M.elements = {
	--Snipers
	Eclipse.mission_elements.gen_dummy(400001, "sniper_1", Vector3(-800, -1040, 3450), Rotation(-90, 0, -0), optsSniper_1),
	Eclipse.mission_elements.gen_dummy(400002, "sniper_2", Vector3(-800, -1197, 3450), Rotation(-90, 0, -0), optsSniper_2),
	Eclipse.mission_elements.gen_dummy(400003, "sniper_3", Vector3(-6254, 3383, 4175), Rotation(90, -0, -0), optsSniper_3),
	Eclipse.mission_elements.gen_dummy(400004, "sniper_4", Vector3(-1109, 2995, 4200), Rotation(90, -0, -0), optsSniper_4),
	Eclipse.mission_elements.gen_so(400005, "sniper_so_1", Vector3(-1209, -524, 3450), Rotation(40, 0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400006, "sniper_so_2", Vector3(-1027, -261, 3450), Rotation(55, -0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400007, "sniper_so_3", Vector3(-5457, 3631, 4175), Rotation(-90, 0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400008, "sniper_so_4", Vector3(-2511, 3341, 4200), Rotation(90, -0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_missionscript(400009, "send_snipers", spawn_snipers),
	Eclipse.mission_elements.gen_dialogue(400010, "they_sending_snipers", Bain_sendsnipers),

	--Respawns
	Eclipse.mission_elements.gen_dummytrigger(400011, "respawn_sniper_1", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsrespawn_sniper_1),
	Eclipse.mission_elements.gen_dummytrigger(400012, "respawn_sniper_2", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsrespawn_sniper_2),
	Eclipse.mission_elements.gen_dummytrigger(400013, "respawn_sniper_3", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsrespawn_sniper_3),
	Eclipse.mission_elements.gen_dummytrigger(400014, "respawn_sniper_4", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsrespawn_sniper_4),
}
return M
