---@module San Martin Bank
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()

local green_bulldozer = scripted_enemy.bulldozer_1
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2

local enabled_chance_dozers = math.random() <= 0.4

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
local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
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
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102986, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 104797, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_3 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 102821, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_4 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 104798, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400016, delay = 0 },
		{ id = 400017, delay = 0 },
	},
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = {
		{ id = 400023, delay = 0 },
		{ id = 400024, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
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
	Eclipse.mission_elements.gen_dummy(400011, "swat_van_spawn_1", Vector3(-2325, -6200, -15), Rotation(115, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400012, "swat_van_spawn_2", Vector3(-2300, -6250, -15), Rotation(115, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400013, "swat_van_spawn_3", Vector3(-2350, -6275, -15), Rotation(115, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400014, "swat_van_spawn_4", Vector3(-2375, -6225, -15), Rotation(115, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400015, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400016, "open_swat_doors_3", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_3),
	Eclipse.mission_elements.gen_spawngroup(400017, "swat_group_1", { 400011, 400012, 400013, 400014 }, 0, opts_swat_group),

	-- swat van 2 (middle)
	Eclipse.mission_elements.gen_dummy(400018, "swat_van_spawn_5", Vector3(-2600, 50, -15), Rotation(100, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400019, "swat_van_spawn_6", Vector3(-2600, -25, -15), Rotation(100, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400020, "swat_van_spawn_7", Vector3(-2650, 50, -15), Rotation(100, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400021, "swat_van_spawn_8", Vector3(-2650, -25, -15), Rotation(100, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400022, "spawn_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400023, "open_swat_doors_4", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_4),
	Eclipse.mission_elements.gen_spawngroup(400024, "swat_group_2", { 400018, 400019, 400020, 400021 }, 0, opts_swat_group),
}
return M
