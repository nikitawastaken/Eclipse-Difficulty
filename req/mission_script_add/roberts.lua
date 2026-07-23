---@module Go Bank
local M = {}

local scripted_enemy = Eclipse.scripted_enemy

local optsATM_Tweaks = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 103134, notify_unit_sequence = "generic", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 103135, notify_unit_sequence = "generic", time = 0 },
	},
}

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_armored_truck_1st",
}
local optsOpenSwatVanDoors_1 = {
	enabled = true,
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 105577, notify_unit_sequence = "anim_door_right_open", time = 0 },
		{ id = 2, name = "run_sequence", notify_unit_id = 105577, notify_unit_sequence = "anim_door_left_open", time = 0 },
	},
}
local optsspawnvanSWATs_1 = {
	on_executed = {
		{ id = 400007, delay = 0 },
		{ id = 400006, delay = 0 },
	},
	enabled = true,
}
local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

local optsNewSniper_1 = {
	enemy = scripted_enemy.sniper,
	spawn_action = "e_sp_up_ledge",
	trigger_times = 1,
	on_executed = {
		{ id = 400012, delay = 0 },
	},
	enabled = true,
}
local optsNewSniper_2 = {
	enemy = scripted_enemy.sniper,
	spawn_action = "e_sp_up_ledge",
	trigger_times = 1,
	on_executed = {
		{ id = 400013, delay = 0 },
	},
	enabled = true,
}

local optsdisable_new_sniper_1 = {
	enabled = true,
	toggle = "off",
	elements = {
		400010,
	},
}
local optsdisable_new_sniper_2 = {
	enabled = true,
	toggle = "off",
	elements = {
		400011,
	},
}
local optsenable_new_sniper_1 = {
	enabled = true,
	set_trigger_times = 1,
	elements = {
		400010,
	},
}
local optsenable_new_sniper_2 = {
	enabled = true,
	set_trigger_times = 1,
	elements = {
		400011,
	},
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

M.elements = {
	-- swat van
	Eclipse.mission_elements.gen_dummy(400001, "swat_van_spawn_1", Vector3(1567.972, 871.511, -76.450), Rotation(4, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400002, "swat_van_spawn_2", Vector3(1479.193, 865.163, -76.450), Rotation(4, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400003, "swat_van_spawn_3", Vector3(1472.636, 958.934, -76.450), Rotation(4, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400004, "swat_van_spawn_4", Vector3(1560.422, 965.073, -76.450), Rotation(4, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_missionscript(400005, "spawn_swats_1", optsspawnvanSWATs_1),
	Eclipse.mission_elements.gen_object_editor(400006, "open_swat_doors_1", Vector3(0, 0, 0), Rotation(0, 0, -0), optsOpenSwatVanDoors_1),
	Eclipse.mission_elements.gen_spawngroup(400007, "swat_group_1", { 400001, 400002, 400003, 400004 }, 0, opts_swat_group),
	
	-- new snipers on the gas station's roof
	Eclipse.mission_elements.gen_dummy(400010, "new_sniper_1", Vector3(4122, 833, 293.027), Rotation(90, 0, 0), optsNewSniper_1),
	Eclipse.mission_elements.gen_dummy(400011, "new_sniper_2", Vector3(4122, 1320, 293.027), Rotation(90, 0, 0), optsNewSniper_2),
	Eclipse.mission_elements.gen_so(400012, "new_sniper_spot_so_1", Vector3(3206, -117, 444.138), Rotation(90, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_so(400013, "new_sniper_spot_so_2", Vector3(3297, 610, 313.138), Rotation(90, 0, 0), optsSniper_SO),
	Eclipse.mission_elements.gen_toggleelement(400014, "enable_new_sniper_1", optsenable_new_sniper_1),
	Eclipse.mission_elements.gen_toggleelement(400015, "enable_new_sniper_2", optsenable_new_sniper_2),
	Eclipse.mission_elements.gen_toggleelement(400016, "disable_new_sniper_1", optsdisable_new_sniper_1),
	Eclipse.mission_elements.gen_toggleelement(400017, "disable_new_sniper_2", optsdisable_new_sniper_2),
	
	-- ATM tweaks
	Eclipse.mission_elements.gen_object_editor(400018, "atm_tweaks", Vector3(0, 0, 0), Rotation(0, 0, 0), optsATM_Tweaks),
}

return M
