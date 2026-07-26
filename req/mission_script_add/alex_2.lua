---@module Rats Day 2
local M = {}
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy


local fbi_team = {
	scripted_enemy.ready_team_1,
	scripted_enemy.ready_team_2,
}

-- FBI ROOFTOP ENEMIES
local optsFBIRooftop_1 = {
	enemy = scripted_enemy.swat_1,
	on_executed = {
		{ id = 400003, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_2 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400004, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_3 = {
	enemy = scripted_enemy.swat_1,
	on_executed = {
		{ id = 400008, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_4 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400009, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_5 = {
	enemy = scripted_enemy.swat_1,
	on_executed = {
		{ id = 400010, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_6 = {
	enemy = scripted_enemy.swat_1,
	on_executed = {
		{ id = 400015, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_7 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400016, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_8 = {
	enemy = scripted_enemy.swat_1,
	on_executed = {
		{ id = 400017, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_9 = {
	enemy = scripted_enemy.swat_1,
	on_executed = {
		{ id = 400022, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_10 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400023, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_11 = {
	enemy = scripted_enemy.swat_1,
	on_executed = {
		{ id = 400024, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_12 = {
	enemy = scripted_enemy.swat_1,
	on_executed = {
		{ id = 400029, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_13 = {
	enemy = scripted_enemy.sniper,
	on_executed = {
		{ id = 400030, delay = 0 },
	},
	enabled = true,
}
local optsFBIRooftop_14 = {
	enemy = scripted_enemy.swat_1,
	on_executed = {
		{ id = 400031, delay = 0 },
	},
	enabled = true,
}
local optsAmbushRooftop_1 = {
	on_executed = {
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
	},
	enabled = true,
}
local optsAmbushRooftop_2 = {
	on_executed = {
		{ id = 400006, delay = 0 },
		{ id = 400007, delay = 0 },
		{ id = 400068, delay = 0 },
	},
	enabled = true,
}
local optsAmbushRooftop_3 = {
	on_executed = {
		{ id = 400012, delay = 0 },
		{ id = 400013, delay = 0 },
		{ id = 400014, delay = 0 },
	},
	enabled = true,
}
local optsAmbushRooftop_4 = {
	on_executed = {
		{ id = 400019, delay = 0 },
		{ id = 400020, delay = 0 },
		{ id = 400021, delay = 0 },
	},
	enabled = true,
}
local optsAmbushRooftop_5 = {
	on_executed = {
		{ id = 400026, delay = 0 },
		{ id = 400027, delay = 0 },
		{ id = 400028, delay = 0 },
	},
	enabled = true,
}

local optsAmbushRooftop_Global = {
	on_executed = {
		{ id = 400005, delay = 0 },
		{ id = 400011, delay = 0 },
		{ id = 400018, delay = 0 },
		{ id = 400025, delay = 0 },
		{ id = 400032, delay = 0 },
	},
	enabled = true,
}

local optsFBIRooftop_SO = {
	SO_access = tostring(128 + 512),
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
}

-- FBI READY TEAMS TAKEOVER
local optsFBI_Team_1 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400052, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_2 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400053, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_3 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400054, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_4 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400055, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_5 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400056, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_6 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400057, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_7 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400058, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_8 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400059, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_9 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400060, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_10 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400061, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_11 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400062, delay = 0 },
	},
	enabled = true,
}
local optsFBI_Team_12 = {
	enemy_table = fbi_team,
	on_executed = {
		{ id = 400063, delay = 0 },
	},
	enabled = true,
}

local optsDefendFBI_SO = {
	SO_access = "128",
	scan = true,
	align_position = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_defend",
}
local optsSpawnFBITeamSquad_1 = {
	on_executed = {
		{ id = 400040, delay = 0 },
		{ id = 400041, delay = 0 },
		{ id = 400042, delay = 0 },
		{ id = 400043, delay = 0 },
		{ id = 400044, delay = 0 },
		{ id = 400045, delay = 0 },
	},
	enabled = true,
}
local optsSpawnFBITeamSquad_2 = {
	on_executed = {
		{ id = 400046, delay = 0 },
		{ id = 400047, delay = 0 },
		{ id = 400048, delay = 0 },
		{ id = 400049, delay = 0 },
		{ id = 400050, delay = 0 },
		{ id = 400051, delay = 0 },
	},
	enabled = true,
}
local optsSpawnFBITeams = {
	on_executed = {
		{ id = 400065, delay = 0 },
		{ id = 400066, delay = 5 },
	},
	enabled = true,
}

local optsDisable_gangster_rooftop = {
	toggle = "off",
	enabled = true,
	elements = {
		101928,
	},
}

M.elements = {
	-- 1st rooftop spawn
	Eclipse.mission_elements.gen_dummy(400001, "fbi_ambush_rooftop_enemy_1", Vector3(3069.967, 1828.752, 400), Rotation(90, 0, 0), optsFBIRooftop_1),
	Eclipse.mission_elements.gen_dummy(400002, "fbi_ambush_rooftop_enemy_2", Vector3(3054, 1553, 400), Rotation(90, 0, 0), optsFBIRooftop_2),
	
	Eclipse.mission_elements.gen_so(400003, "fbi_ambush_rooftop_so_spot_1", Vector3(2389, 1951, 400), Rotation(90, 0, 0), optsFBIRooftop_SO),
	Eclipse.mission_elements.gen_so(400004, "fbi_ambush_rooftop_so_spot_2", Vector3(2380, 1477, 400), Rotation(90, 0, 0), optsFBIRooftop_SO),
	
	Eclipse.mission_elements.gen_missionscript(400005, "ambush_rooftop_1", optsAmbushRooftop_1),
	-- 2nd rooftop spawn
	Eclipse.mission_elements.gen_dummy(400006, "fbi_ambush_rooftop_enemy_3", Vector3(1950, 3914, 624), Rotation(0, 0, 0), optsFBIRooftop_3),
	Eclipse.mission_elements.gen_dummy(400007, "fbi_ambush_rooftop_enemy_4", Vector3(1884, 3914, 624), Rotation(0, 0, 0), optsFBIRooftop_4),
	Eclipse.mission_elements.gen_dummy(400068, "fbi_ambush_rooftop_enemy_5", Vector3(1822, 3914, 624), Rotation(0, 0, 0), optsFBIRooftop_5),
	
	Eclipse.mission_elements.gen_so(400008, "fbi_ambush_rooftop_so_spot_3", Vector3(1613, 3388, 624), Rotation(-180, 0, 0), optsFBIRooftop_SO),
	Eclipse.mission_elements.gen_so(400009, "fbi_ambush_rooftop_so_spot_4", Vector3(1936, 3388, 624), Rotation(-180, 0, 0), optsFBIRooftop_SO),
	Eclipse.mission_elements.gen_so(400010, "fbi_ambush_rooftop_so_spot_5", Vector3(2123, 3388, 624), Rotation(-180, 0, 0), optsFBIRooftop_SO),
	
	Eclipse.mission_elements.gen_missionscript(400011, "ambush_rooftop_2", optsAmbushRooftop_2),
	-- 3rd rooftop spawn
	Eclipse.mission_elements.gen_dummy(400012, "fbi_ambush_rooftop_enemy_6", Vector3(1330, 4501, 201.491), Rotation(90, 0, 0), optsFBIRooftop_6),
	Eclipse.mission_elements.gen_dummy(400013, "fbi_ambush_rooftop_enemy_7", Vector3(1409, 4512, 201.491), Rotation(90, 0, 0), optsFBIRooftop_7),
	Eclipse.mission_elements.gen_dummy(400014, "fbi_ambush_rooftop_enemy_8", Vector3(1409, 4445, 201.491), Rotation(90, 0, 0), optsFBIRooftop_8),
	
	Eclipse.mission_elements.gen_so(400015, "fbi_ambush_rooftop_so_spot_6", Vector3(830, 3595, 200), Rotation(-154, 0, 0), optsFBIRooftop_SO),
	Eclipse.mission_elements.gen_so(400016, "fbi_ambush_rooftop_so_spot_7", Vector3(988, 3595, 200), Rotation(-180, 0, 0), optsFBIRooftop_SO),
	Eclipse.mission_elements.gen_so(400017, "fbi_ambush_rooftop_so_spot_8", Vector3(1179, 3595, 200), Rotation(-180, 0, 0), optsFBIRooftop_SO),
	
	Eclipse.mission_elements.gen_missionscript(400018, "ambush_rooftop_3", optsAmbushRooftop_3),
	-- 4th rooftop spawn
	Eclipse.mission_elements.gen_dummy(400019, "fbi_ambush_rooftop_enemy_9", Vector3(2031, -2574, 400), Rotation(90, 0, 0), optsFBIRooftop_9),
	Eclipse.mission_elements.gen_dummy(400020, "fbi_ambush_rooftop_enemy_10", Vector3(2031, -2690, 400), Rotation(90, 0, 0), optsFBIRooftop_10),
	Eclipse.mission_elements.gen_dummy(400021, "fbi_ambush_rooftop_enemy_11", Vector3(2031, -2759, 400), Rotation(90, 0, 0), optsFBIRooftop_11),
	
	Eclipse.mission_elements.gen_so(400022, "fbi_ambush_rooftop_so_spot_9", Vector3(854, -2308, 400), Rotation(0, 0, 0), optsFBIRooftop_SO),
	Eclipse.mission_elements.gen_so(400023, "fbi_ambush_rooftop_so_spot_10", Vector3(739, -2308, 400), Rotation(0, 0, 0), optsFBIRooftop_SO),
	Eclipse.mission_elements.gen_so(400024, "fbi_ambush_rooftop_so_spot_11", Vector3(595, -2308, 400), Rotation(0, 0, 0), optsFBIRooftop_SO),
	
	Eclipse.mission_elements.gen_missionscript(400025, "ambush_rooftop_4", optsAmbushRooftop_4),
	-- 5th rooftop spawn
	Eclipse.mission_elements.gen_dummy(400026, "fbi_ambush_rooftop_enemy_12", Vector3(-1067, -2019, 400), Rotation(0, 0, 0), optsFBIRooftop_12),
	Eclipse.mission_elements.gen_dummy(400027, "fbi_ambush_rooftop_enemy_13", Vector3(-1067, -2079, 400), Rotation(0, 0, 0), optsFBIRooftop_13),
	Eclipse.mission_elements.gen_dummy(400028, "fbi_ambush_rooftop_enemy_14", Vector3(-1067, -2137, 400), Rotation(0, 0, 0), optsFBIRooftop_14),
	
	Eclipse.mission_elements.gen_so(400029, "fbi_ambush_rooftop_so_spot_12", Vector3(-508.315, -2137.143, 400), Rotation(-43, 0, 0), optsFBIRooftop_SO),
	Eclipse.mission_elements.gen_so(400030, "fbi_ambush_rooftop_so_spot_13", Vector3(-497.533, -1939.364, 400), Rotation(-43, 0, 0), optsFBIRooftop_SO),
	Eclipse.mission_elements.gen_so(400031, "fbi_ambush_rooftop_so_spot_14", Vector3(-528.856, -1751.545, 402), Rotation(-43, 0, 0), optsFBIRooftop_SO),
	
	Eclipse.mission_elements.gen_missionscript(400032, "ambush_rooftop_5", optsAmbushRooftop_5),
	
	Eclipse.mission_elements.gen_missionscript(400033, "spawn_rooftop_enemies", optsAmbushRooftop_Global),
	
	-- FBI Ready Teams securing the area
	Eclipse.mission_elements.gen_dummy(400040, "fbi_ready_team_spawn_1", Vector3(-581, 4688, -600), Rotation(155, 0, 0), optsFBI_Team_1),
	Eclipse.mission_elements.gen_dummy(400041, "fbi_ready_team_spawn_2", Vector3(-651, 4808, -600), Rotation(155, 0, 0), optsFBI_Team_2),
	Eclipse.mission_elements.gen_dummy(400042, "fbi_ready_team_spawn_3", Vector3(-523, 4812, -600), Rotation(155, 0, 0), optsFBI_Team_3),
	Eclipse.mission_elements.gen_dummy(400043, "fbi_ready_team_spawn_4", Vector3(-566, 4924, -600), Rotation(155, 0, 0), optsFBI_Team_4),
	Eclipse.mission_elements.gen_dummy(400044, "fbi_ready_team_spawn_5", Vector3(-384, 5013, -600), Rotation(155, 0, 0), optsFBI_Team_5),
	Eclipse.mission_elements.gen_dummy(400045, "fbi_ready_team_spawn_6", Vector3(-458, 5078, -600), Rotation(155, 0, 0), optsFBI_Team_6),
	Eclipse.mission_elements.gen_dummy(400046, "fbi_ready_team_spawn_7", Vector3(-2074, -832, -800), Rotation(-180, 0, 0), optsFBI_Team_7),
	Eclipse.mission_elements.gen_dummy(400047, "fbi_ready_team_spawn_8", Vector3(-2145, -832, -800), Rotation(-180, 0, 0), optsFBI_Team_8),
	Eclipse.mission_elements.gen_dummy(400048, "fbi_ready_team_spawn_9", Vector3(-2123, -1711, -800), Rotation(0, 0, 0), optsFBI_Team_9),
	Eclipse.mission_elements.gen_dummy(400049, "fbi_ready_team_spawn_10", Vector3(-2184, -1718, -800), Rotation(0, 0, 0), optsFBI_Team_10),
	Eclipse.mission_elements.gen_dummy(400050, "fbi_ready_team_spawn_11", Vector3(-2173, -1765, -800), Rotation(0, 0, 0), optsFBI_Team_11),
	Eclipse.mission_elements.gen_dummy(400051, "fbi_ready_team_spawn_12", Vector3(-2122, -1768, -800), Rotation(0, 0, 0), optsFBI_Team_12),

	Eclipse.mission_elements.gen_so(400052, "fbi_defend_so_1", Vector3(1281, 3091, -600), Rotation(-146, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400053, "fbi_defend_so_2", Vector3(1254.984, 2875.632, -600), Rotation(154, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400054, "fbi_defend_so_3", Vector3(1027.875, 2594.765, -600), Rotation(-176, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400055, "fbi_defend_so_4", Vector3(1974.373, 2851.868, -600), Rotation(154, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400056, "fbi_defend_so_5", Vector3(1762.260, 2546.998, -600), Rotation(154, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400057, "fbi_defend_so_6", Vector3(1809.428, 2384, -600), Rotation(137, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400058, "fbi_defend_so_7", Vector3(851, -850, -800), Rotation(0, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400059, "fbi_defend_so_8", Vector3(921, -257, -800), Rotation(0, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400060, "fbi_defend_so_9", Vector3(633, -1133, -800), Rotation(0, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400061, "fbi_defend_so_10", Vector3(-129, -560, -800), Rotation(-30, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400062, "fbi_defend_so_11", Vector3(69, -837, -800), Rotation(-30, 0, 0), optsDefendFBI_SO),
	Eclipse.mission_elements.gen_so(400063, "fbi_defend_so_12", Vector3(658, -36, -800), Rotation(0, 0, 0), optsDefendFBI_SO),

	Eclipse.mission_elements.gen_missionscript(400064, "spawn_fbi_ready_teams", optsSpawnFBITeams),
	
	Eclipse.mission_elements.gen_missionscript(400065, "fbi_ready_team_squad_1", optsSpawnFBITeamSquad_1),
	Eclipse.mission_elements.gen_missionscript(400066, "fbi_ready_team_squad_2", optsSpawnFBITeamSquad_2),
	
	-- misc
	Eclipse.mission_elements.gen_toggleelement(400067, "disable_rooftop_gangsters", optsDisable_gangster_rooftop),
}

return M
