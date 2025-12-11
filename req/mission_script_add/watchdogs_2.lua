---@module Watchdogs Day2
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()

local sniper = scripted_enemy.sniper

local optsSniper_1 = {
	enemy = sniper,
	on_executed = { { id = 400007, delay = 0 } },
	enabled = true,
}
local optsSniper_2 = {
	enemy = sniper,
	on_executed = { { id = 400008, delay = 0 } },
	enabled = true,
}
local optsSniper_3 = {
	enemy = sniper,
	on_executed = { { id = 400009, delay = 0 } },
	enabled = true,
}
local optsSniper_4 = {
	enemy = sniper,
	on_executed = { { id = 400010, delay = 0 } },
	enabled = true,
}
local optsSniper_5 = {
	enemy = sniper,
	on_executed = { { id = 400011, delay = 0 } },
	enabled = true,
}
local optsSniper_6 = {
	enemy = sniper,
	on_executed = { { id = 400012, delay = 0 } },
	enabled = true,
}
local optsGroundSniper_1 = {
	enemy = sniper,
	on_executed = { { id = 400025, delay = 0 } },
	enabled = true,
}
local optsGroundSniper_2 = {
	enemy = sniper,
	on_executed = { { id = 400029, delay = 0 } },
	enabled = true,
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
local optsgroundSniper_SO_1_1 = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400026, delay = 15 },
	},
}
local optsgroundSniper_SO_1_2 = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400027, delay = 15 },
	},
}
local optsgroundSniper_SO_1_3 = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400028, delay = 15 },
	},
}
local optsgroundSniper_SO_1_4 = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400025, delay = 15 },
	},
}
local optsgroundSniper_SO_2_1 = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400030, delay = 15 },
	},
}
local optsgroundSniper_SO_2_2 = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400031, delay = 15 },
	},
}
local optsgroundSniper_SO_2_3 = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400032, delay = 15 },
	},
}
local optsgroundSniper_SO_2_4 = {
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_sniper",
	on_executed = {
		{ id = 400029, delay = 15 },
	},
}
local spawnSnipers_1 = {
	enabled = true,
	trigger_times = 1,
	on_executed = {
		{ id = 400001, delay = 4 },
		{ id = 400002, delay = 4 },
		{ id = 400022, delay = 0 },
	},
}
local spawnSnipers_2 = {
	enabled = true,
	trigger_times = 1,
	on_executed = {
		{ id = 400003, delay = 4 },
		{ id = 400004, delay = 4 },
		{ id = 400022, delay = 0 },
	},
}
local spawnSnipers_3 = {
	enabled = true,
	trigger_times = 1,
	on_executed = {
		{ id = 400005, delay = 4 },
		{ id = 400006, delay = 4 },
		{ id = 400022, delay = 0 },
	},
}
local spawnGroundSnipers = {
	enabled = true,
	on_executed = {
		{ id = 400023, delay = 0 },
		{ id = 400024, delay = 0 },
	},
}
local Bain_sendsnipers = {
	dialogue = "play_pln_gen_snip_01",
}
local ground_sniper_delay = 30
local ground_sniper_delay_rand = 30
local optsrespawn_sniper_1 = {
	on_executed = {
		{ id = 400001, delay = ground_sniper_delay, delay_rand = ground_sniper_delay_rand },
	},
	elements = {
		400001,
	},
	event = "death",
}
local optsrespawn_sniper_2 = {
	on_executed = {
		{ id = 400002, delay = ground_sniper_delay, delay_rand = ground_sniper_delay_rand },
	},
	elements = {
		400002,
	},
	event = "death",
}
local optsrespawn_sniper_3 = {
	on_executed = {
		{ id = 400003, delay = ground_sniper_delay, delay_rand = ground_sniper_delay_rand },
	},
	elements = {
		400003,
	},
	event = "death",
}
local optsrespawn_sniper_4 = {
	on_executed = {
		{ id = 400004, delay = ground_sniper_delay, delay_rand = ground_sniper_delay_rand },
	},
	elements = {
		400004,
	},
	event = "death",
}
local optsrespawn_sniper_5 = {
	on_executed = {
		{ id = 400005, delay = ground_sniper_delay, delay_rand = ground_sniper_delay_rand },
	},
	elements = {
		400005,
	},
	event = "death",
}
local optsrespawn_sniper_6 = {
	on_executed = {
		{ id = 400006, delay = ground_sniper_delay, delay_rand = ground_sniper_delay_rand },
	},
	elements = {
		400006,
	},
	event = "death",
}
local optsrespawn_ground_sniper_1 = {
	on_executed = {
		{ id = 400023, delay = ground_sniper_delay, delay_rand = ground_sniper_delay_rand },
	},
	elements = {
		400023,
	},
	event = "death",
}
local optsrespawn_ground_sniper_2 = {
	on_executed = {
		{ id = 400024, delay = ground_sniper_delay, delay_rand = ground_sniper_delay_rand },
	},
	elements = {
		400024,
	},
	event = "death",
}

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400041, delay = 0 },
		{ id = 400042, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400049, delay = 0 },
		{ id = 400050, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100476, notify_unit_sequence = "anim_door_right_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100476, notify_unit_sequence = "anim_door_left_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 100478, notify_unit_sequence = "anim_door_right_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 100478, notify_unit_sequence = "anim_door_left_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_Trigger_1 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_police_responce", unit_id = 100476 },
	},
	on_executed = {
		{ id = 400040, delay = 0, delay_rand = 5 },
	},
}
local optsOpenSwatVanDoors_Trigger_2 = {
	enabled = true,
	sequence_list = {
		{ guis_id = 1, sequence = "done_police_responce", unit_id = 100478 },
	},
	on_executed = {
		{ id = 400048, delay = 0, delay_rand = 5 },
	},
}

M.elements = {
	--Snipers
	Eclipse.mission_elements.gen_dummy(400001, "sniper_1", Vector3(3385, -3308, 540.404), Rotation(-90, 0, -0), optsSniper_1),
	Eclipse.mission_elements.gen_dummy(400002, "sniper_2", Vector3(3285, -3308, 540.404), Rotation(-90, 0, -0), optsSniper_2),
	Eclipse.mission_elements.gen_dummy(400003, "sniper_3", Vector3(4202, 4376, 540.404), Rotation(90, -0, -0), optsSniper_3),
	Eclipse.mission_elements.gen_dummy(400004, "sniper_4", Vector3(4133, 4368, 540.404), Rotation(90, -0, -0), optsSniper_4),
	Eclipse.mission_elements.gen_dummy(400005, "sniper_5", Vector3(5936, 405, 540.404), Rotation(0, 0, -0), optsSniper_5),
	Eclipse.mission_elements.gen_dummy(400006, "sniper_6", Vector3(5936, 500, 540.404), Rotation(0, 0, -0), optsSniper_6),
	Eclipse.mission_elements.gen_so(400007, "sniper_so_1", Vector3(3974, -2994, 540.404), Rotation(0, 0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400008, "sniper_so_2", Vector3(4132, -2997, 540.404), Rotation(0, 0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400009, "sniper_so_3", Vector3(3509, 4051, 540.404), Rotation(-180, 0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400010, "sniper_so_4", Vector3(3701, 4051, 540.404), Rotation(-180, 0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400011, "sniper_so_5", Vector3(5643, 1060, 540.404), Rotation(90, -0, -0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400012, "sniper_so_6", Vector3(5643, 929, 540.404), Rotation(90, -0, -0), optsSniper_SO),

	--Mission Scripts
	Eclipse.mission_elements.gen_missionscript(400013, "spawn_snipers_1", spawnSnipers_1),
	Eclipse.mission_elements.gen_missionscript(400014, "spawn_snipers_2", spawnSnipers_2),
	Eclipse.mission_elements.gen_missionscript(400015, "spawn_snipers_3", spawnSnipers_3),
	Eclipse.mission_elements.gen_dummytrigger(400016, "respawn_sniper_1", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsrespawn_sniper_1),
	Eclipse.mission_elements.gen_dummytrigger(400017, "respawn_sniper_2", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsrespawn_sniper_2),
	Eclipse.mission_elements.gen_dummytrigger(400018, "respawn_sniper_3", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsrespawn_sniper_3),
	Eclipse.mission_elements.gen_dummytrigger(400019, "respawn_sniper_4", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsrespawn_sniper_4),
	Eclipse.mission_elements.gen_dummytrigger(400020, "respawn_sniper_5", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsrespawn_sniper_5),
	Eclipse.mission_elements.gen_dummytrigger(400021, "respawn_sniper_6", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsrespawn_sniper_6),
	Eclipse.mission_elements.gen_dialogue(400022, "they_sending_snipers", Bain_sendsnipers),

	--Ground Snipers
	Eclipse.mission_elements.gen_dummy(400023, "ground_sniper_1", Vector3(-2983, 193, 0), Rotation(0, 0, -0), optsGroundSniper_1),
	Eclipse.mission_elements.gen_dummy(400024, "ground_sniper_2", Vector3(-2559, -2495, 0), Rotation(-90, 0, -0), optsGroundSniper_2),
	Eclipse.mission_elements.gen_so(400025, "ground_sniper_loop_1_1", Vector3(-2189, 1500, -0), Rotation(-90, 0, -0), optsgroundSniper_SO_1_1),
	Eclipse.mission_elements.gen_so(400026, "ground_sniper_loop_1_2", Vector3(-1024.726, 3595.228, 0), Rotation(-130, 0, -0), optsgroundSniper_SO_1_2),
	Eclipse.mission_elements.gen_so(400027, "ground_sniper_loop_1_3", Vector3(617, 1198, 0), Rotation(-80, 0, -0), optsgroundSniper_SO_1_3),
	Eclipse.mission_elements.gen_so(400028, "ground_sniper_loop_1_4", Vector3(-186, -1162, 0), Rotation(-90, 0, -0), optsgroundSniper_SO_1_4),
	Eclipse.mission_elements.gen_so(400029, "ground_sniper_loop_2_1", Vector3(413, -1575, 0), Rotation(-90, 0, -0), optsgroundSniper_SO_2_1),
	Eclipse.mission_elements.gen_so(400030, "ground_sniper_loop_2_2", Vector3(1096, -1170, 0), Rotation(-104, 0, -0), optsgroundSniper_SO_2_2),
	Eclipse.mission_elements.gen_so(400031, "ground_sniper_loop_2_3", Vector3(1476, 656, -0), Rotation(-55, 0, -0), optsgroundSniper_SO_2_3),
	Eclipse.mission_elements.gen_so(400032, "ground_sniper_loop_2_4", Vector3(-465, 1287, -0), Rotation(-90, 0, -0), optsgroundSniper_SO_2_4),
	Eclipse.mission_elements.gen_dummytrigger(400033, "respawn_ground_sniper_1", Vector3(-2400, -3677, 375), Rotation(90, -0, -0), optsrespawn_ground_sniper_1),
	Eclipse.mission_elements.gen_dummytrigger(400034, "respawn_ground_sniper_2", Vector3(-2400, -3577, 375), Rotation(90, -0, -0), optsrespawn_ground_sniper_2),
	Eclipse.mission_elements.gen_missionscript(400035, "spawn_ground_snipers", spawnGroundSnipers),

	-- swat van 1
	Eclipse.mission_elements.gen_dummy(400036, "swat_van_spawn_1", Vector3(-3982, -1294, -19.999), Rotation(163, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400037, "swat_van_spawn_2", Vector3(-3920.797, -1312.712, -19.999), Rotation(163, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400038, "swat_van_spawn_3", Vector3(-4004.830, -1354.990, -19.999), Rotation(163, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400039, "swat_van_spawn_4", Vector3(-3939.801, -1374.871, -19.999), Rotation(163, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400040, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400041, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_spawngroup(400042, "swat_group_1", { 400036, 400037, 400038, 400039 }, 0, opts_swat_group),
	Eclipse.mission_elements.gen_object_editor_trigger(400043, "swat_van_doors_trigger_1", optsOpenSwatVanDoors_Trigger_1),

	-- swat van 2
	Eclipse.mission_elements.gen_dummy(400044, "swat_van_spawn_5", Vector3(-3358, 7936, -19.999), Rotation(-23, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400045, "swat_van_spawn_6", Vector3(-3416.912, 7961.006, -19.999), Rotation(-23, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400046, "swat_van_spawn_7", Vector3(-3332.881, 8000.296, -19.999), Rotation(-23, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400047, "swat_van_spawn_8", Vector3(-3389.952, 8024.521, -19.999), Rotation(-23, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400048, "spawn_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400049, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_2),
	Eclipse.mission_elements.gen_spawngroup(400050, "swat_group_2", { 400044, 400045, 400046, 400047 }, 0, opts_swat_group),
	Eclipse.mission_elements.gen_object_editor_trigger(400051, "swat_van_doors_trigger_2", optsOpenSwatVanDoors_Trigger_2),
}

return M
