---@module Bank Heist
local M = {}

local diff_i = Eclipse.utils.difficulty_index()
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local elite_bulldozer = scripted_enemy.elite_bulldozer_2

local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local shield = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield
local taser = scripted_enemy.taser_1
local medic = diff_i < 4 and scripted_enemy.taser_1 or scripted_enemy.medic_1

local swats = { [swat_1] = 2, [swat_2] = 1 }

local optsBulldozer = {
	enemy = elite_bulldozer,
	on_executed = {
		{ id = 400002, delay = 0 },
	},
	enabled = is_eclipse,
}
local optsDefend_SO = {
	SO_access = "4096",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	interval = 2,
	so_action = "AI_sniper",
}
local optsDisable_DWDozer = {
	toggle = "off",
	enabled = true,
	elements = {
		400001,
	},
}
local optsEnable_DWDozer = {
	enabled = true,
	elements = {
		400001,
	},
}
local optsSWAT = {
	enemy_table = swats,
	spawn_action = "e_sp_armored_truck_1st",
	participate_to_group_ai = true,
	enabled = true,
}
local optsMedic = {
	enemy = medic,
	spawn_action = "e_sp_armored_truck_1st",
	participate_to_group_ai = true,
	enabled = true,
}
local optsTaser = {
	enemy = taser,
	spawn_action = "e_sp_armored_truck_1st",
	participate_to_group_ai = true,
	enabled = true,
}
local optsShield = {
	enemy = shield,
	spawn_action = "e_sp_armored_truck_1st",
	participate_to_group_ai = true,
	enabled = true,
}
local optsOpenSwatVanDoors_1 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 105216, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsOpenSwatVanDoors_2 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 105081, notify_unit_sequence = "anim_doors_rear_open", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = { { id = 400005, delay = 0 }, { id = 400006, delay = 0 }, { id = 400007, delay = 0 }, { id = 400008, delay = 0 }, { id = 400009, delay = 0 }, { id = 400011, delay = 0 } },
	enabled = true,
}
local optsspawnvanSWATs_2 = {
	on_executed = { { id = 400012, delay = 0 }, { id = 400013, delay = 0 }, { id = 400014, delay = 0 }, { id = 400015, delay = 0 }, { id = 400016, delay = 0 }, { id = 400028, delay = 0 } },
	enabled = true,
}

M.elements = {
	-- skulldozer nearby the van on Eclipse (based on DW Trailer)
	Eclipse.mission_elements.gen_dummy(400001, "van_dozer", Vector3(-8305, -3511, 0), Rotation(-90, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_so(400002, "dozer_defend_so", Vector3(-7273, -2895, -19.999), Rotation(0, 0, -0), optsDefend_SO),
	Eclipse.mission_elements.gen_toggleelement(400003, "enable_dozervan", optsEnable_DWDozer),
	Eclipse.mission_elements.gen_toggleelement(400004, "disable_dozervan", optsDisable_DWDozer),

	-- swat van 1
	Eclipse.mission_elements.gen_dummy(400005, "swat_van_spawn_1", Vector3(-110, -1023, -19.999), Rotation(-84, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400006, "swat_van_spawn_2", Vector3(-114.599, -979.241, -19.999), Rotation(-84, 0, 0), optsMedic),
	Eclipse.mission_elements.gen_dummy(400007, "swat_van_spawn_3", Vector3(-118.989, -937.471, -19.999), Rotation(-84, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400008, "swat_van_spawn_4", Vector3(-38.866, -1020.551, -19.999), Rotation(-84, 0, 0), optsShield),
	Eclipse.mission_elements.gen_dummy(400009, "swat_van_spawn_5", Vector3(-48.378, -930.050, -19.999), Rotation(-84, 0, 0), optsShield),
	Eclipse.mission_elements.gen_missionscript(400010, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400011, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),

	-- swat van 2
	Eclipse.mission_elements.gen_dummy(400012, "swat_van_spawn_1", Vector3(760, 2587, -19.850), Rotation(16, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400013, "swat_van_spawn_2", Vector3(719.627, 2575.423, -19.850), Rotation(16, 0, 0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400014, "swat_van_spawn_3", Vector3(675.409, 2562.744, -19.850), Rotation(16, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400015, "swat_van_spawn_4", Vector3(748.826, 2636.852, -19.850), Rotation(16, 0, 0), optsShield),
	Eclipse.mission_elements.gen_dummy(400016, "swat_van_spawn_5", Vector3(661.351, 2611.769, -19.850), Rotation(16, 0, 0), optsShield),
	Eclipse.mission_elements.gen_missionscript(400017, "spawn_swats_2", optsspawnvanSWATs_2),
	Eclipse.mission_elements.gen_object_editor(400018, "open_swat_doors_2", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_2),
}

return M
