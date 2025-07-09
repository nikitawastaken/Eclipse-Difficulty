---@module Golden Grin Casino
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job
local sniper_amount = normal and 2 or hard and 3 or 4
local snipers_respawn = (is_eclipse and 120 or 180) - (is_pro_job and 30 or 0)

local sniper = scripted_enemy.sniper

local optsSniper_1 = {
	enemy = sniper,
	spawn_action = "e_sp_clk_3_5m_dwn_vent_var2",
	on_executed = {
		{ id = 400005, delay = 0 },
	},
	enabled = true,
}
local optsSniper_2 = {
	enemy = sniper,
	spawn_action = "e_sp_clk_3_5m_dwn_vent_var2",
	on_executed = {
		{ id = 400006, delay = 0 },
	},
	enabled = true,
}
local optsSniper_3 = {
	enemy = sniper,
	spawn_action = "e_sp_clk_3_5m_dwn_vent_var2",
	on_executed = {
		{ id = 400008, delay = 0 },
	},
	enabled = true,
}
local optsSniper_4 = {
	enemy = sniper,
	spawn_action = "e_sp_clk_3_5m_dwn_vent_var2",
	on_executed = {
		{ id = 400007, delay = 0 },
	},
	enabled = true,
}
local optsSniper_5 = {
	enemy = sniper,
	spawn_action = "e_sp_dwn_5m",
	on_executed = {
		{ id = 400009, delay = 0 },
	},
	enabled = true,
}
local optsSniper_SO = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsSniper_3_1SO = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400035, delay = 20 },
	},	
}
local optsSniper_3_2SO = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400007, delay = 20 },
	},	
}
local optsSniper_4_1SO = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400036, delay = 20 },
	},	
}
local optsSniper_4_2SO = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400008, delay = 20 },
	},	
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
		{ id = 400011, delay = 0 },
		{ id = 400010, delay = snipers_respawn },
		{ id = 400032, delay = 0 },
	},
	elements = {
		400000,
	},
	event = "death",
}
local optssniperdied_2 = {
	on_executed = {
		{ id = 400012, delay = 0 },
		{ id = 400010, delay = snipers_respawn },
		{ id = 400032, delay = 0 },
	},
	elements = {
		400001,
	},
	event = "death",
}
local optssniperdied_3 = {
	on_executed = {
		{ id = 400013, delay = 0 },
		{ id = 400010, delay = snipers_respawn },
		{ id = 400032, delay = 0 },
	},
	elements = {
		400002,
	},
	event = "death",
}
local optssniperdied_4 = {
	on_executed = {
		{ id = 400014, delay = 0 },
		{ id = 400010, delay = snipers_respawn },
		{ id = 400032, delay = 0 },
	},
	elements = {
		400003,
	},
	event = "death",
}
local optssniperdied_5 = {
	on_executed = {
		{ id = 400015, delay = 0 },
		{ id = 400010, delay = snipers_respawn },
		{ id = 400032, delay = 0 },
	},
	elements = {
		400004,
	},
	event = "death",
}
local optssniperspawned_1 = {
	on_executed = {
		{ id = 400016, delay = 0 },
		{ id = 400031, delay = 0 },
	},
	elements = {
		400000,
	},
}
local optssniperspawned_2 = {
	on_executed = {
		{ id = 400017, delay = 0 },
		{ id = 400031, delay = 0 },
	},
	elements = {
		400001,
	},
}
local optssniperspawned_3 = {
	on_executed = {
		{ id = 400018, delay = 0 },
		{ id = 400031, delay = 0 },
	},
	elements = {
		400002,
	},
}
local optssniperspawned_4 = {
	on_executed = {
		{ id = 400019, delay = 0 },
		{ id = 400031, delay = 0 },
	},
	elements = {
		400003,
	},
}
local optssniperspawned_5 = {
	on_executed = {
		{ id = 400020, delay = 0 },
		{ id = 400031, delay = 0 },
	},
	elements = {
		400004,
	},
}
local spawn_random_snipers = {
	amount = sniper_amount,
	trigger_times = 1,
	on_executed = {
		{ id = 400000, delay = 0 },
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
		{ id = 400003, delay = 0 },
		{ id = 400004, delay = 0 },
	},
}
local spawn_snipers_global = {
	enabled = true,
	trigger_times = 1,
	on_executed = {
		{ id = 400010, delay = 0 },
		{ id = 400033, delay = 0 },
	},
}
local Bain_sendsnipers = {
	dialogue = "play_pln_gen_snip_06",
}

M.elements = {
	-- snipers in the interior
	Eclipse.mission_elements.gen_dummy(400000, "sniper_1", Vector3(1423, 2448, 598), Rotation(180, 0, 0), optsSniper_1),
	Eclipse.mission_elements.gen_dummy(400001, "sniper_2", Vector3(-1383, 2448, 598), Rotation(180, 0, 0), optsSniper_2),
	Eclipse.mission_elements.gen_dummy(400002, "sniper_3", Vector3(-1383.001, -6840, 699), Rotation(0, 0, 0), optsSniper_3),
	Eclipse.mission_elements.gen_dummy(400003, "sniper_4", Vector3(1427.999, -6840, 699), Rotation(0, 0, 0), optsSniper_4),
	Eclipse.mission_elements.gen_dummy(400004, "sniper_5", Vector3(-1869, -1887, 602.500), Rotation(-90, 0, 0), optsSniper_5),
	Eclipse.mission_elements.gen_so(400005, "sniper_spot_so_1", Vector3(907.007, -670.306, 600), Rotation(160, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400006, "sniper_spot_so_2", Vector3(-1005, -942, 602.500), Rotation(-130, -0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400007, "sniper_spot_so_3_1", Vector3(1069, -3349, 602.500), Rotation(51, 0, 0), optsSniper_3_1SO),
	Eclipse.mission_elements.gen_so(400035, "sniper_spot_so_3_2", Vector3(392.921, -3504.528, 307.501), Rotation(0, 0, 0), optsSniper_3_2SO),
	Eclipse.mission_elements.gen_so(400008, "sniper_spot_so_4_1", Vector3(-1018, -3197, 602.500), Rotation(-52, 0, 0), optsSniper_4_1SO),
	Eclipse.mission_elements.gen_so(400036, "sniper_spot_so_4_2", Vector3(-339, -3495.679, 312.449), Rotation(-8, 0, 0), optsSniper_4_2SO),
	Eclipse.mission_elements.gen_so(400009, "sniper_spot_so_5", Vector3(-613, -2409, 502.708), Rotation(-90, 0, 0), optsSniper_SO),

	-- sniper spawn stuff
	Eclipse.mission_elements.gen_element_random(400010, "bfd_sniper_event_random_loop", spawn_random_snipers),
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
	Eclipse.mission_elements.gen_missionscript(400034, "bfd_snipers_event_global", spawn_snipers_global),
}
return M