---@module San Martin Bank
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()

local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local shield = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield
local medic = hard_and_above and scripted_enemy.medic_1 or scripted_enemy.taser_1
local taser = scripted_enemy.taser_1
local green_bulldozer = scripted_enemy.bulldozer_1
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2

local enabled_chance_dozers = math.random() < 0.4

local swats = { [swat_1] = 2, [swat_2] = 1 }

local optsDwTrailer_Dozer_1 = {
	enemy = elite_skull_bulldozer,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = {
		{ id = 400002, delay = 0 },
		{ id = 400008, delay = 0 },
	},
	enabled = true,
}
local optsDwTrailer_Dozer_2 = {
	enemy = elite_skull_bulldozer,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = {
		{ id = 400003, delay = 0 },
		{ id = 400007, delay = 0 },
	},
	enabled = true,
}
local optVaultDozer = {
	enemy = is_eclipse and elite_ben_bulldozer or green_bulldozer,
	enabled = overkill_and_above and enabled_chance_dozers,
}
local optsSWAT_wall = {
	enemy_table = swats,
	spawn_action = "e_sp_armored_truck_1st",
	participate_to_group_ai = true,
	enabled = true,
}
local optsShield_wall = {
	enemy = shield,
	spawn_action = "e_sp_armored_truck_1st",
	participate_to_group_ai = true,
	enabled = true,
}
local optsSWAT_1 = {
	enemy_table = swats,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400026, delay = 0 } },
	enabled = true,
}
local optsSWAT_2 = {
	enemy_table = swats,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400027, delay = 0 } },
	enabled = true,
}
local optsSWAT_3 = {
	enemy_table = swats,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400028, delay = 0 } },
	enabled = true,
}
local optsMedic_1 = {
	enemy = medic,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400029, delay = 0 } },
	enabled = true,
}
local optsMedic_2 = {
	enemy = medic,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400030, delay = 0 } },
	enabled = true,
}
local optsTaser = {
	enemy = taser,
	spawn_action = "e_sp_armored_truck_1st",
	on_executed = { { id = 400031, delay = 0 } },
	enabled = true,
}
local optsDefend_Dozer = {
	SO_access = "4096",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsDefend_SWAT = {
	SO_access = tostring(128 + 2048 + 8192),
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_defend",
}
local optsDisable_dwdozers = {
	toggle = "off",
	enabled = true,
	elements = {
		400000,
		400001,
	},
}
local optsEnable_dwdozer = {
	enabled = is_eclipse,
	elements = {
		400000,
		400001,
	},
}
local optsOpenSwatVanDoors_1 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102986, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 104797, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_3 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 104798, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_4 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102821, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = { { id = 400011, delay = 0 }, { id = 400012, delay = 0 }, { id = 400013, delay = 0 }, { id = 400014, delay = 0 }, { id = 400015, delay = 0 }, { id = 400017, delay = 0 } },
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400018, delay = 0 },
		{ id = 400019, delay = 0 },
		{ id = 400020, delay = 0 },
		{ id = 400021, delay = 0 },
		{ id = 400022, delay = 0 },
		{ id = 400023, delay = 0 },
		{ id = 400025, delay = 0 },
	},
	enabled = true,
}

M.elements = {
	-- dw trailer styled skullies
	Eclipse.mission_elements.gen_dummy(400000, "tank_1", Vector3(1509, 4783, -13.500), Rotation(41, 0, 0), optsDwTrailer_Dozer_1),
	Eclipse.mission_elements.gen_dummy(400001, "tank_2", Vector3(-1864.375, 4782.167, -13.500), Rotation(37, 0, 0), optsDwTrailer_Dozer_2),
	Eclipse.mission_elements.gen_so(400002, "tank_so_1", Vector3(3013, 3481, 0), Rotation(90, 0, 0), optsDefend_Dozer),
	Eclipse.mission_elements.gen_so(400003, "tank_so_2", Vector3(-2979.969, 3633.456, 0), Rotation(-90, 0, 0), optsDefend_Dozer),

	Eclipse.mission_elements.gen_toggleelement(400004, "disable_dozers", optsDisable_dwdozers),
	Eclipse.mission_elements.gen_toggleelement(400005, "enable_dozers", optsEnable_dwdozer),
	Eclipse.mission_elements.gen_object_editor(400007, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_object_editor(400008, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_2),

	-- bulldozers inside the vault
	Eclipse.mission_elements.gen_dummy(400009, "tank_vault_1", Vector3(45, -5729, -400), Rotation(0, 0, 0), optVaultDozer),
	Eclipse.mission_elements.gen_dummy(400010, "tank_vault_2", Vector3(-53, -5729, -400), Rotation(0, 0, 0), optVaultDozer),

	-- swat van 1 (that crashes at the wall)
	Eclipse.mission_elements.gen_dummy(400011, "swat_van_spawn_1", Vector3(-2319, -6194, -13.500), Rotation(116, 0, 0), optsSWAT_wall),
	Eclipse.mission_elements.gen_dummy(400012, "swat_van_spawn_2", Vector3(-2297.082, -6238.939, -13.500), Rotation(116, 0, 0), optsSWAT_wall),
	Eclipse.mission_elements.gen_dummy(400013, "swat_van_spawn_3", Vector3(-2276.040, -6282.082, -13.500), Rotation(116, 0, 0), optsSWAT_wall),
	Eclipse.mission_elements.gen_dummy(400014, "swat_van_spawn_4", Vector3(-2364, -6217.256, -13.500), Rotation(116, 0, 0), optsShield_wall),
	Eclipse.mission_elements.gen_dummy(400015, "swat_van_spawn_5", Vector3(-2321.878, -6304.438, -13.500), Rotation(116, 0, 0), optsShield_wall),
	Eclipse.mission_elements.gen_missionscript(400016, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400017, "open_swat_doors_3", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_4),

	-- swat van 2 (middle)
	Eclipse.mission_elements.gen_dummy(400018, "swat_van_spawn_1", Vector3(-2608, 50, -13.500), Rotation(99, 0, 0), optsSWAT_1),
	Eclipse.mission_elements.gen_dummy(400019, "swat_van_spawn_2", Vector3(-2601.273, 7.529, -13.500), Rotation(99, 0, 0), optsSWAT_2),
	Eclipse.mission_elements.gen_dummy(400020, "swat_van_spawn_3", Vector3(-2593.295, -42.843, -13.500), Rotation(99, 0, 0), optsSWAT_3),
	Eclipse.mission_elements.gen_dummy(400021, "swat_van_spawn_4", Vector3(-2641.692, -50.508, -13.500), Rotation(99, 0, 0), optsMedic_1),
	Eclipse.mission_elements.gen_dummy(400022, "swat_van_spawn_5", Vector3(-2648.731, -6.062, -13.500), Rotation(99, 0, 0), optsMedic_2),
	Eclipse.mission_elements.gen_dummy(400023, "swat_van_spawn_6", Vector3(-2659.179, 47.273, -13.500), Rotation(99, 0, 0), optsTaser),
	Eclipse.mission_elements.gen_missionscript(400024, "spawn_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400025, "open_swat_doors_4", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_3),

	Eclipse.mission_elements.gen_so(400026, "swat_so_1", Vector3(-247.473, -1317.539, 0), Rotation(-174, 0, 0), optsDefend_SWAT),
	Eclipse.mission_elements.gen_so(400027, "swat_so_2", Vector3(-516, -1410, 0), Rotation(-161, 0, 0), optsDefend_SWAT),
	Eclipse.mission_elements.gen_so(400028, "swat_so_3", Vector3(298.423, -1398.999, 0), Rotation(163, 0, 0), optsDefend_SWAT),
	Eclipse.mission_elements.gen_so(400029, "swat_so_4", Vector3(403, -1405, 0), Rotation(169, 0, 0), optsDefend_SWAT),
	Eclipse.mission_elements.gen_so(400030, "swat_so_5", Vector3(-364.826, -1329.879, 0), Rotation(-174, 0, 0), optsDefend_SWAT),
	Eclipse.mission_elements.gen_so(400031, "swat_so_6", Vector3(8, -1331, 3.094), Rotation(178, 0, 0), optsDefend_SWAT),
}
return M
