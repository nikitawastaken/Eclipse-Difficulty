---@module Election Day (Day 3, Plan C)
local M = {}

local get_navlink_so_opts = Eclipse.utils.get_navlink_so_opts

local optsElevatorTriggerEnemiesEnter01 = {
	width = 375,
	depth = 250,
	height = 300,
	instigator = "enemies",
	trigger_on = "on_enter",
	on_executed = {
		{ id = 400009, delay = 0 },
		{ id = 400021, delay = 2 },
		{ id = 400036, delay = 0 },
	},
	trigger_times = 0,
	enabled = true,
}
local optsElevatorTriggerEnemiesExit01 = {
	width = 375,
	depth = 250,
	height = 300,
	instigator = "enemies",
	trigger_on = "on_empty",
	on_executed = {
		{ id = 400009, delay = 0 },
		{ id = 400025, delay = 2 },
		{ id = 400035, delay = 15 },
	},
	trigger_times = 0,
	enabled = false,
}

local optsElevatorTriggerEnemiesEnter02 = deep_clone(optsElevatorTriggerEnemiesEnter01)
optsElevatorTriggerEnemiesEnter02.on_executed = {
	{ id = 400010, delay = 0 },
	{ id = 400022, delay = 0 },
	{ id = 400044, delay = 0 },
}
local optsElevatorTriggerEnemiesExit02 = deep_clone(optsElevatorTriggerEnemiesExit01)
optsElevatorTriggerEnemiesExit02.on_executed = {
	{ id = 400010, delay = 0 },
	{ id = 400026, delay = 0 },
	{ id = 400043, delay = 15 },
}

local optsElevatorTriggerEnemiesEnter03 = deep_clone(optsElevatorTriggerEnemiesEnter01)
optsElevatorTriggerEnemiesEnter03.on_executed = {
	{ id = 400011, delay = 0 },
	{ id = 400023, delay = 0 },
	{ id = 400052, delay = 0 },
}
local optsElevatorTriggerEnemiesExit03 = deep_clone(optsElevatorTriggerEnemiesExit01)
optsElevatorTriggerEnemiesExit03.on_executed = {
	{ id = 400011, delay = 0 },
	{ id = 400027, delay = 0 },
	{ id = 400051, delay = 15 },
}

local optsElevatorTriggerEnemiesEnter04 = deep_clone(optsElevatorTriggerEnemiesEnter01)
optsElevatorTriggerEnemiesEnter04.on_executed = {
	{ id = 400012, delay = 0 },
	{ id = 400024, delay = 0 },
	{ id = 400060, delay = 0 },
}
local optsElevatorTriggerEnemiesExit04 = deep_clone(optsElevatorTriggerEnemiesExit01)
optsElevatorTriggerEnemiesExit04.on_executed = {
	{ id = 400012, delay = 0 },
	{ id = 400028, delay = 0 },
	{ id = 400059, delay = 15 },
}

local optsElevatorTriggerEnemiesToggle01 = {
	toggle = "toggle",
	elements = {
		400001,
		400005,
	},
	set_trigger_times = -1,
	enabled = true,
}

local optsElevatorTriggerEnemiesToggle02 = deep_clone(optsElevatorTriggerEnemiesToggle01)
optsElevatorTriggerEnemiesToggle02.elements = { 400002, 400006 }

local optsElevatorTriggerEnemiesToggle03 = deep_clone(optsElevatorTriggerEnemiesToggle01)
optsElevatorTriggerEnemiesToggle03.elements = { 400003, 400007 }

local optsElevatorTriggerEnemiesToggle04 = deep_clone(optsElevatorTriggerEnemiesToggle01)
optsElevatorTriggerEnemiesToggle04.elements = { 400004, 400008 }

local optsAiGraphEnter01 = {
	graph_ids = { 83 },
	operation = "allow_access",
	enabled = true,
}
local optsAiGraphExit01 = {
	graph_ids = { 83 },
	operation = "forbid_access",
	enabled = true,
}

local optsAiGraphEnter02 = deep_clone(optsAiGraphEnter01)
optsAiGraphEnter02.graph_ids = { 82 }
local optsAiGraphExit02 = deep_clone(optsAiGraphExit01)
optsAiGraphExit02.graph_ids = { 82 }

local optsAiGraphEnter03 = deep_clone(optsAiGraphEnter01)
optsAiGraphEnter03.graph_ids = { 81 }
local optsAiGraphExit03 = deep_clone(optsAiGraphExit01)
optsAiGraphExit03.graph_ids = { 81 }

local optsAiGraphEnter04 = deep_clone(optsAiGraphEnter01)
optsAiGraphEnter04.graph_ids = { 80 }
local optsAiGraphExit04 = deep_clone(optsAiGraphExit01)
optsAiGraphExit04.graph_ids = { 80 }

local optsElevatorOpen01 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 600152, notify_unit_sequence = "open_doors", time = 0 },
	},
	on_executed = {
		{ id = 103176, delay = 0 },
		{ id = 103209, delay = 0 }, -- bing
	},
	enabled = true,
}
local optsElevatorClose01 = {
	trigger_list = {
		{ id = 1, name = "run_sequence", notify_unit_id = 600152, notify_unit_sequence = "close_doors", time = 0 },
	},
	enabled = true,
}

local optsElevatorOpen02 = deep_clone(optsElevatorOpen01)
optsElevatorOpen02.trigger_list[1].notify_unit_id = 600080
optsElevatorOpen02.on_executed[1].id = 103178
optsElevatorOpen02.on_executed[2].id = 103210

local optsElevatorClose02 = deep_clone(optsElevatorClose01)
optsElevatorClose02.trigger_list[1].notify_unit_id = 600080

local optsElevatorOpen03 = deep_clone(optsElevatorOpen01)
optsElevatorOpen03.trigger_list[1].notify_unit_id = 600078
optsElevatorOpen03.on_executed[1].id = 103217
optsElevatorOpen03.on_executed[2].id = 103211

local optsElevatorClose03 = deep_clone(optsElevatorClose01)
optsElevatorClose03.trigger_list[1].notify_unit_id = 600078

local optsElevatorOpen04 = deep_clone(optsElevatorOpen01)
optsElevatorOpen04.trigger_list[1].notify_unit_id = 600079
optsElevatorOpen04.on_executed[1].id = 103219
optsElevatorOpen04.on_executed[2].id = 103212

local optsElevatorClose04 = deep_clone(optsElevatorClose01)
optsElevatorClose04.trigger_list[1].notify_unit_id = 600079

local optsBesiegeDummy = {
	participate_to_group_ai = true,
	enabled = true,
}
local optsElevatorGroup = {
	amount = 5,
}

local optsElevatorGroupAdd01 = {
	spawn_groups = { 400034 },
	enabled = true,
}
local optsElevatorGroupRemove01 = {
	elements = { 400035 },
	enabled = true,
}

local optsElevatorGroupAdd02 = deep_clone(optsElevatorGroupAdd01)
optsElevatorGroupAdd02.spawn_groups = { 400042 }
local optsElevatorGroupRemove02 = deep_clone(optsElevatorGroupRemove01)
optsElevatorGroupRemove02.elements = { 400043 }

local optsElevatorGroupAdd03 = deep_clone(optsElevatorGroupAdd01)
optsElevatorGroupAdd03.spawn_groups = { 400050 }
local optsElevatorGroupRemove03 = deep_clone(optsElevatorGroupRemove01)
optsElevatorGroupRemove03.elements = { 400051 }

local optsElevatorGroupAdd04 = deep_clone(optsElevatorGroupAdd01)
optsElevatorGroupAdd04.spawn_groups = { 400058 }
local optsElevatorGroupRemove04 = deep_clone(optsElevatorGroupRemove01)
optsElevatorGroupRemove04.elements = { 400059 }

local optsDisableElevatorGroup01 = {
	toggle = "off",
	elements = {
		400035,
		400001,
		400005,
		400065,
		400069,
	},
	enabled = true,
}

local optsDisableElevatorGroup02 = deep_clone(optsDisableElevatorGroup01)
optsDisableElevatorGroup02.elements = { 400043, 400002, 400006, 400066, 400070 }

local optsDisableElevatorGroup03 = deep_clone(optsDisableElevatorGroup01)
optsDisableElevatorGroup03.elements = { 400051, 400003, 400007, 400067, 400071 }

local optsDisableElevatorGroup04 = deep_clone(optsDisableElevatorGroup01)
optsDisableElevatorGroup04.elements = { 400059, 400004, 400008, 400068, 400072 }

local optsElevatorTriggerPlayersEnter01 = {
	width = 375,
	depth = 250,
	height = 300,
	instigator = "player",
	trigger_on = "on_enter",
	on_executed = {
		{ id = 400073, delay = 0 },
		{ id = 400021, delay = 0 },
	},
	trigger_times = 0,
	enabled = true,
}
local optsElevatorTriggerPlayersExit01 = {
	width = 375,
	depth = 250,
	height = 300,
	instigator = "player",
	trigger_on = "on_empty",
	on_executed = {
		{ id = 400073, delay = 0 },
		{ id = 400025, delay = 0 },
	},
	trigger_times = 0,
	enabled = false,
}

local optsElevatorTriggerPlayersEnter02 = deep_clone(optsElevatorTriggerPlayersEnter01)
optsElevatorTriggerPlayersEnter02.on_executed = {
	{ id = 400074, delay = 0 },
	{ id = 400022, delay = 0 },
}
local optsElevatorTriggerPlayersExit02 = deep_clone(optsElevatorTriggerPlayersExit01)
optsElevatorTriggerPlayersExit02.on_executed = {
	{ id = 400074, delay = 0 },
	{ id = 400026, delay = 0 },
}

local optsElevatorTriggerPlayersEnter03 = deep_clone(optsElevatorTriggerPlayersEnter01)
optsElevatorTriggerPlayersEnter03.on_executed = {
	{ id = 400075, delay = 0 },
	{ id = 400023, delay = 0 },
}
local optsElevatorTriggerPlayersExit03 = deep_clone(optsElevatorTriggerPlayersExit01)
optsElevatorTriggerPlayersExit03.on_executed = {
	{ id = 400075, delay = 0 },
	{ id = 400027, delay = 0 },
}

local optsElevatorTriggerPlayersEnter04 = deep_clone(optsElevatorTriggerPlayersEnter01)
optsElevatorTriggerPlayersEnter04.on_executed = {
	{ id = 400076, delay = 0 },
	{ id = 400024, delay = 0 },
}
local optsElevatorTriggerPlayersExit04 = deep_clone(optsElevatorTriggerPlayersExit01)
optsElevatorTriggerPlayersExit04.on_executed = {
	{ id = 400076, delay = 0 },
	{ id = 400028, delay = 0 },
}

local optsElevatorTriggerPlayersToggle01 = {
	toggle = "toggle",
	elements = {
		400065,
		400069,
	},
	set_trigger_times = -1,
	enabled = true,
}

local optsElevatorTriggerPlayersToggle02 = deep_clone(optsElevatorTriggerPlayersToggle01)
optsElevatorTriggerPlayersToggle02.elements = { 400066, 400070 }

local optsElevatorTriggerPlayersToggle03 = deep_clone(optsElevatorTriggerPlayersToggle01)
optsElevatorTriggerPlayersToggle03.elements = { 400067, 400071 }

local optsElevatorTriggerPlayersToggle04 = deep_clone(optsElevatorTriggerPlayersToggle01)
optsElevatorTriggerPlayersToggle04.elements = { 400068, 400072 }

local optsAddElevatorPrefereds = {
	on_executed = {
		{ id = 400035, delay = 15, delay_rand = 45 },
		{ id = 400043, delay = 15, delay_rand = 45 },
		{ id = 400051, delay = 15, delay_rand = 45 },
		{ id = 400059, delay = 15, delay_rand = 45 },
	},
	enabled = true,
}

local optsElevatorNavlink01 = get_navlink_so_opts("e_nl_fwd_2m", Vector3(-1625, -925, 0), 10, false, true, true)
local optsElevatorNavlink02 = get_navlink_so_opts("e_nl_fwd_2m", Vector3(-1625, -1275, 0), 10, false, true, true)
local optsElevatorNavlink03 = get_navlink_so_opts("e_nl_fwd_2m", Vector3(-1625, -1925, 0), 10, false, true, true)
local optsElevatorNavlink04 = get_navlink_so_opts("e_nl_fwd_2m", Vector3(-1625, -2275, 0), 10, false, true, true)

M.elements = {
	-- Only open elevators when there's an enemy inside
	Eclipse.mission_elements.gen_areatrigger(400001, "elevator_area_trigger_enter_enemy_01", Vector3(-1950, -925, 150), Rotation(0, 0, 0), optsElevatorTriggerEnemiesEnter01),
	Eclipse.mission_elements.gen_areatrigger(400002, "elevator_area_trigger_enter_enemy_02", Vector3(-1950, -1275, 150), Rotation(0, 0, 0), optsElevatorTriggerEnemiesEnter02),
	Eclipse.mission_elements.gen_areatrigger(400003, "elevator_area_trigger_enter_enemy_03", Vector3(-1950, -1925, 150), Rotation(0, 0, 0), optsElevatorTriggerEnemiesEnter03),
	Eclipse.mission_elements.gen_areatrigger(400004, "elevator_area_trigger_enter_enemy_04", Vector3(-1950, -2275, 150), Rotation(0, 0, 0), optsElevatorTriggerEnemiesEnter04),

	Eclipse.mission_elements.gen_areatrigger(400005, "elevator_area_trigger_enter_enemy_01", Vector3(-1950, -925, 150), Rotation(0, 0, 0), optsElevatorTriggerEnemiesExit01),
	Eclipse.mission_elements.gen_areatrigger(400006, "elevator_area_trigger_enter_enemy_02", Vector3(-1950, -1275, 150), Rotation(0, 0, 0), optsElevatorTriggerEnemiesExit02),
	Eclipse.mission_elements.gen_areatrigger(400007, "elevator_area_trigger_enter_enemy_03", Vector3(-1950, -1925, 150), Rotation(0, 0, 0), optsElevatorTriggerEnemiesExit03),
	Eclipse.mission_elements.gen_areatrigger(400008, "elevator_area_trigger_enter_enemy_04", Vector3(-1950, -2275, 150), Rotation(0, 0, 0), optsElevatorTriggerEnemiesExit04),

	Eclipse.mission_elements.gen_toggleelement(400009, "toggle_elevator_enemy_triggers_01", optsElevatorTriggerEnemiesToggle01),
	Eclipse.mission_elements.gen_toggleelement(400010, "toggle_elevator_enemy_triggers_02", optsElevatorTriggerEnemiesToggle02),
	Eclipse.mission_elements.gen_toggleelement(400011, "toggle_elevator_enemy_triggers_03", optsElevatorTriggerEnemiesToggle03),
	Eclipse.mission_elements.gen_toggleelement(400012, "toggle_elevator_enemy_triggers_04", optsElevatorTriggerEnemiesToggle04),

	-- Only enable nav segments inside elevators when there's an enemy inside and vice versa.
	Eclipse.mission_elements.gen_aigraph(400013, "elevator_ai_graph_allow_access_01", Vector3(-1975, -850, 25), Rotation(0, 0, 0), optsAiGraphEnter01),
	Eclipse.mission_elements.gen_aigraph(400014, "elevator_ai_graph_allow_access_02", Vector3(-1975, -1200, 25), Rotation(0, 0, 0), optsAiGraphEnter02),
	Eclipse.mission_elements.gen_aigraph(400015, "elevator_ai_graph_allow_access_03", Vector3(-1975, -1850, 25), Rotation(0, 0, 0), optsAiGraphEnter03),
	Eclipse.mission_elements.gen_aigraph(400016, "elevator_ai_graph_allow_access_04", Vector3(-1975, -2200, 25), Rotation(0, 0, 0), optsAiGraphEnter04),

	Eclipse.mission_elements.gen_aigraph(400017, "elevator_ai_graph_forbid_access_01", Vector3(-1975, -850, 25), Rotation(0, 0, 0), optsAiGraphExit01),
	Eclipse.mission_elements.gen_aigraph(400018, "elevator_ai_graph_forbid_access_02", Vector3(-1975, -1200, 25), Rotation(0, 0, 0), optsAiGraphExit02),
	Eclipse.mission_elements.gen_aigraph(400019, "elevator_ai_graph_forbid_access_03", Vector3(-1975, -1850, 25), Rotation(0, 0, 0), optsAiGraphExit03),
	Eclipse.mission_elements.gen_aigraph(400020, "elevator_ai_graph_forbid_access_04", Vector3(-1975, -2200, 25), Rotation(0, 0, 0), optsAiGraphExit04),

	-- Sequence Triggers for opening/closing elevator doors
	Eclipse.mission_elements.gen_object_editor(400021, "elevator_open_doors_01", Vector3(0, 0, 0), Rotation(0, 0, -0), optsElevatorOpen01),
	Eclipse.mission_elements.gen_object_editor(400022, "elevator_open_doors_02", Vector3(0, 0, 0), Rotation(0, 0, -0), optsElevatorOpen02),
	Eclipse.mission_elements.gen_object_editor(400023, "elevator_open_doors_03", Vector3(0, 0, 0), Rotation(0, 0, -0), optsElevatorOpen03),
	Eclipse.mission_elements.gen_object_editor(400024, "elevator_open_doors_04", Vector3(0, 0, 0), Rotation(0, 0, -0), optsElevatorOpen04),

	Eclipse.mission_elements.gen_object_editor(400025, "elevator_close_doors_01", Vector3(0, 0, 0), Rotation(0, 0, -0), optsElevatorClose01),
	Eclipse.mission_elements.gen_object_editor(400026, "elevator_close_doors_02", Vector3(0, 0, 0), Rotation(0, 0, -0), optsElevatorClose02),
	Eclipse.mission_elements.gen_object_editor(400027, "elevator_close_doors_03", Vector3(0, 0, 0), Rotation(0, 0, -0), optsElevatorClose03),
	Eclipse.mission_elements.gen_object_editor(400028, "elevator_close_doors_04", Vector3(0, 0, 0), Rotation(0, 0, -0), optsElevatorClose04),

	-- Elevator spawn groups
	Eclipse.mission_elements.gen_dummy(400029, "elevator_spawn_enemy_01", Vector3(-2000, -975, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400030, "elevator_spawn_enemy_02", Vector3(-2000, -875, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400031, "elevator_spawn_enemy_03", Vector3(-1900, -975, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400032, "elevator_spawn_enemy_04", Vector3(-1900, -875, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400033, "elevator_spawn_enemy_05", Vector3(-1950, -925, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400034, "elevator_group_01", { 400029, 400030, 400031, 400032, 400033 }, 0, optsElevatorGroup),
	Eclipse.mission_elements.gen_preferedadd(400035, "add_elevator_group_prefered01", optsElevatorGroupAdd01),
	Eclipse.mission_elements.gen_preferedremove(400036, "remove_elevator_group_prefered01", optsElevatorGroupRemove01),

	Eclipse.mission_elements.gen_dummy(400037, "elevator_spawn_enemy_06", Vector3(-2000, -1325, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400038, "elevator_spawn_enemy_07", Vector3(-2000, -1225, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400039, "elevator_spawn_enemy_08", Vector3(-1900, -1325, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400040, "elevator_spawn_enemy_09", Vector3(-1900, -1225, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400041, "elevator_spawn_enemy_10", Vector3(-1950, -1275, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400042, "elevator_group_02", { 400037, 400038, 400039, 400040, 400041 }, 0, optsElevatorGroup),
	Eclipse.mission_elements.gen_preferedadd(400043, "add_elevator_group_prefered02", optsElevatorGroupAdd02),
	Eclipse.mission_elements.gen_preferedremove(400044, "remove_elevator_group_prefered02", optsElevatorGroupRemove02),

	Eclipse.mission_elements.gen_dummy(400045, "elevator_spawn_enemy_11", Vector3(-2000, -1975, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400046, "elevator_spawn_enemy_12", Vector3(-2000, -1875, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400047, "elevator_spawn_enemy_13", Vector3(-1900, -1975, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400048, "elevator_spawn_enemy_14", Vector3(-1900, -1875, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400049, "elevator_spawn_enemy_15", Vector3(-1950, -1925, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400050, "elevator_group_03", { 400045, 400046, 400047, 400048, 400049 }, 0, optsElevatorGroup),
	Eclipse.mission_elements.gen_preferedadd(400051, "add_elevator_group_prefered03", optsElevatorGroupAdd03),
	Eclipse.mission_elements.gen_preferedremove(400052, "remove_elevator_group_prefered03", optsElevatorGroupRemove03),

	Eclipse.mission_elements.gen_dummy(400053, "elevator_spawn_enemy_16", Vector3(-2000, -2375, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400054, "elevator_spawn_enemy_17", Vector3(-2000, -2175, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400055, "elevator_spawn_enemy_18", Vector3(-1900, -2375, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400056, "elevator_spawn_enemy_19", Vector3(-1900, -2175, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_dummy(400057, "elevator_spawn_enemy_20", Vector3(-1950, -2275, 0), Rotation(-90, 0, 0), optsBesiegeDummy),
	Eclipse.mission_elements.gen_spawngroup(400058, "elevator_group_04", { 400053, 400054, 400055, 400056, 400057 }, 0, optsElevatorGroup),
	Eclipse.mission_elements.gen_preferedadd(400059, "add_elevator_group_prefered04", optsElevatorGroupAdd04),
	Eclipse.mission_elements.gen_preferedremove(400060, "remove_elevator_group_prefered04", optsElevatorGroupRemove04),

	-- Disable the prefered and all the area triggers inside the elevator that drops off the Thermal Drill
	Eclipse.mission_elements.gen_toggleelement(400061, "disable_elevator_group_01", optsDisableElevatorGroup01),
	Eclipse.mission_elements.gen_toggleelement(400062, "disable_elevator_group_02", optsDisableElevatorGroup02),
	Eclipse.mission_elements.gen_toggleelement(400063, "disable_elevator_group_03", optsDisableElevatorGroup03),
	Eclipse.mission_elements.gen_toggleelement(400064, "disable_elevator_group_04", optsDisableElevatorGroup04),

	-- Add these just in case a player walks into one of the elevators
	Eclipse.mission_elements.gen_areatrigger(400065, "elevator_area_trigger_enter_player_01", Vector3(-1950, -925, 150), Rotation(0, 0, 0), optsElevatorTriggerPlayersEnter01),
	Eclipse.mission_elements.gen_areatrigger(400066, "elevator_area_trigger_enter_player_02", Vector3(-1950, -1275, 150), Rotation(0, 0, 0), optsElevatorTriggerPlayersEnter02),
	Eclipse.mission_elements.gen_areatrigger(400067, "elevator_area_trigger_enter_player_03", Vector3(-1950, -1925, 150), Rotation(0, 0, 0), optsElevatorTriggerPlayersEnter03),
	Eclipse.mission_elements.gen_areatrigger(400068, "elevator_area_trigger_enter_player_04", Vector3(-1950, -2275, 150), Rotation(0, 0, 0), optsElevatorTriggerPlayersEnter04),

	Eclipse.mission_elements.gen_areatrigger(400069, "elevator_area_trigger_exit_player_01", Vector3(-1950, -925, 150), Rotation(0, 0, 0), optsElevatorTriggerPlayersExit01),
	Eclipse.mission_elements.gen_areatrigger(400070, "elevator_area_trigger_exit_player_02", Vector3(-1950, -1275, 150), Rotation(0, 0, 0), optsElevatorTriggerPlayersExit02),
	Eclipse.mission_elements.gen_areatrigger(400071, "elevator_area_trigger_exit_player_03", Vector3(-1950, -1925, 150), Rotation(0, 0, 0), optsElevatorTriggerPlayersExit03),
	Eclipse.mission_elements.gen_areatrigger(400072, "elevator_area_trigger_exit_player_04", Vector3(-1950, -2275, 150), Rotation(0, 0, 0), optsElevatorTriggerPlayersExit04),

	Eclipse.mission_elements.gen_toggleelement(400073, "toggle_elevator_player_triggers_01", optsElevatorTriggerPlayersToggle01),
	Eclipse.mission_elements.gen_toggleelement(400074, "toggle_elevator_player_triggers_02", optsElevatorTriggerPlayersToggle02),
	Eclipse.mission_elements.gen_toggleelement(400075, "toggle_elevator_player_triggers_03", optsElevatorTriggerPlayersToggle03),
	Eclipse.mission_elements.gen_toggleelement(400076, "toggle_elevator_player_triggers_04", optsElevatorTriggerPlayersToggle04),

	-- Add the new prefereds
	Eclipse.mission_elements.gen_missionscript(400077, "add_elevator_prefereds", optsAddElevatorPrefereds),

	-- Add silly navlinks similar to the ones inside elevators on Big Bank
	Eclipse.mission_elements.gen_so(400078, "elevator_navlink_01", Vector3(-1825, -925, 0), Rotation(-90, 0, 0), optsElevatorNavlink01),
	Eclipse.mission_elements.gen_so(400079, "elevator_navlink_02", Vector3(-1825, -1275, 0), Rotation(-90, 0, 0), optsElevatorNavlink02),
	Eclipse.mission_elements.gen_so(400080, "elevator_navlink_03", Vector3(-1825, -1925, 0), Rotation(-90, 0, 0), optsElevatorNavlink03),
	Eclipse.mission_elements.gen_so(400081, "elevator_navlink_04", Vector3(-1825, -2275, 0), Rotation(-90, 0, 0), optsElevatorNavlink04),
}

return M
