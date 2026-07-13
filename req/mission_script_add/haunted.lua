---@module Safehouse Nightmare
local M = {}
local is_pro_job = Eclipse.utils.is_pro_job()
local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts

local begin_the_nightmare = {
	enabled = true,
	on_executed = {
		{ id = 400048, delay = 0 },
	},
}
local optsCloakerHideGroup = {
	followup_elements = {
		400052,
		400053,
		400054,
		400055,
		400056,
		400057,
		400058,
		400059,
	},
}
local optsBesiegeDummy_1 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_uno_ground",
}
local optsBesiegeDummy_2 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_uno_wall",
}
local optsBesiegeDummy_3 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_uno_jump_in",
}
local optsBesiegeDummy_4 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_over_3m",
}
local optsBesiegeDummy_5 = {
	participate_to_group_ai = true,
	enabled = true,
	spawn_action = "e_sp_down_8m_var4",
}
local optsPreferedAdd1 = {
	spawn_groups = {
		400005,
		400011,
		400017,
		400023,
		400029,
		400035,
	},
}
local optsPreferedAdd2 = {
	spawn_groups = {
		400041,
		400047,
	},
}
local optsDisableSWATs = {
	toggle = "off",
	enabled = is_pro_job and true or false,
	elements = {
		400048,
		400049,
	},
}
local optsDisableHelldozers = {
	toggle = "off",
	enabled = not is_pro_job and true or false,
	elements = {
		101669,
		102717,
	},
}

local hide_so_search_pos = Vector3(1300, -4000, -300)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var2", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts("e_so_sneak_wait_stand", hide_so_search_pos)

M.elements = {
	Eclipse.mission_elements.gen_dummy(400000, "haunted_spawn_enemy001", Vector3(-300, 4500, -400), Rotation(-180, 0, 0), optsBesiegeDummy_1),
	Eclipse.mission_elements.gen_dummy(400001, "haunted_spawn_enemy002", Vector3(-225, 4500, -400), Rotation(-180, 0, 0), optsBesiegeDummy_1),
	Eclipse.mission_elements.gen_dummy(400002, "haunted_spawn_enemy003", Vector3(-150, 4500, -400), Rotation(-180, 0, 0), optsBesiegeDummy_1),
	Eclipse.mission_elements.gen_dummy(400003, "haunted_spawn_enemy004", Vector3(-75, 4500, -400), Rotation(-180, 0, 0), optsBesiegeDummy_1),
	Eclipse.mission_elements.gen_dummy(400004, "haunted_spawn_enemy005", Vector3(0, 4500, -400), Rotation(-180, 0, 0), optsBesiegeDummy_1),
	Eclipse.mission_elements.gen_spawngroup(400005, "haunted_enemy_group001", { 400000, 400001, 400002, 400003, 400004 }, 0),

	Eclipse.mission_elements.gen_dummy(400006, "haunted_spawn_enemy006", Vector3(-1625, 3300, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400007, "haunted_spawn_enemy007", Vector3(-1700, 3300, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400008, "haunted_spawn_enemy008", Vector3(-1775, 3300, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400009, "haunted_spawn_enemy009", Vector3(-1850, 3300, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400010, "haunted_spawn_enemy010", Vector3(-1925, 3300, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_spawngroup(400011, "haunted_enemy_group002", { 400006, 400007, 400008, 400009, 400010 }, 0),

	Eclipse.mission_elements.gen_dummy(400012, "haunted_spawn_enemy011", Vector3(200, 3300, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400013, "haunted_spawn_enemy012", Vector3(125, 3300, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400014, "haunted_spawn_enemy013", Vector3(50, 3300, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400015, "haunted_spawn_enemy014", Vector3(-25, 3300, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400016, "haunted_spawn_enemy015", Vector3(-100, 3300, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_spawngroup(400017, "haunted_enemy_group003", { 400012, 400013, 400014, 400015, 400016 }, 0),

	Eclipse.mission_elements.gen_dummy(400018, "haunted_spawn_enemy016", Vector3(300, 4050, -400), Rotation(90, 0, 0), optsBesiegeDummy_3),
	Eclipse.mission_elements.gen_dummy(400019, "haunted_spawn_enemy017", Vector3(300, 3975, -400), Rotation(90, 0, 0), optsBesiegeDummy_3),
	Eclipse.mission_elements.gen_dummy(400020, "haunted_spawn_enemy018", Vector3(300, 3900, -400), Rotation(90, 0, 0), optsBesiegeDummy_3),
	Eclipse.mission_elements.gen_dummy(400021, "haunted_spawn_enemy019", Vector3(300, 3825, -400), Rotation(90, 0, 0), optsBesiegeDummy_3),
	Eclipse.mission_elements.gen_dummy(400022, "haunted_spawn_enemy020", Vector3(300, 3750, -400), Rotation(90, 0, 0), optsBesiegeDummy_3),
	Eclipse.mission_elements.gen_spawngroup(400023, "haunted_enemy_group004", { 400018, 400019, 400020, 400021, 400022 }, 0),

	Eclipse.mission_elements.gen_dummy(400024, "haunted_spawn_enemy021", Vector3(-550, 2750, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400025, "haunted_spawn_enemy022", Vector3(-625, 2750, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400026, "haunted_spawn_enemy023", Vector3(-700, 2750, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400027, "haunted_spawn_enemy024", Vector3(-775, 2750, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400028, "haunted_spawn_enemy025", Vector3(-850, 2750, -400), Rotation(0, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_spawngroup(400029, "haunted_enemy_group005", { 400024, 400025, 400026, 400027, 400028 }, 0),

	Eclipse.mission_elements.gen_dummy(400030, "haunted_spawn_enemy026", Vector3(-2500, 4800, -400), Rotation(-180, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400031, "haunted_spawn_enemy027", Vector3(-2425, 4800, -398.479), Rotation(-180, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400032, "haunted_spawn_enemy028", Vector3(-2350, 4800, -398.479), Rotation(-180, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400033, "haunted_spawn_enemy029", Vector3(-2275, 4800, -398.479), Rotation(-180, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_dummy(400034, "haunted_spawn_enemy030", Vector3(-2200, 4800, -398.479), Rotation(-180, 0, 0), optsBesiegeDummy_2),
	Eclipse.mission_elements.gen_spawngroup(400035, "haunted_enemy_group006", { 400030, 400031, 400032, 400033, 400034 }, 0),

	Eclipse.mission_elements.gen_dummy(400036, "haunted_spawn_enemy031", Vector3(-3350, 1300, 0), Rotation(90, 0, 0), optsBesiegeDummy_4),
	Eclipse.mission_elements.gen_dummy(400037, "haunted_spawn_enemy032", Vector3(-3350, 1225, 0), Rotation(90, 0, 0), optsBesiegeDummy_4),
	Eclipse.mission_elements.gen_dummy(400038, "haunted_spawn_enemy033", Vector3(-3350, 1150, 0), Rotation(90, 0, 0), optsBesiegeDummy_4),
	Eclipse.mission_elements.gen_dummy(400039, "haunted_spawn_enemy034", Vector3(-3350, 1075, 0), Rotation(90, 0, 0), optsBesiegeDummy_4),
	Eclipse.mission_elements.gen_dummy(400040, "haunted_spawn_enemy035", Vector3(-3350, 1000, 0), Rotation(90, 0, 0), optsBesiegeDummy_4),
	Eclipse.mission_elements.gen_spawngroup(400041, "haunted_enemy_group007", { 400036, 400037, 400038, 400039, 400040 }, 0),

	Eclipse.mission_elements.gen_dummy(400042, "haunted_spawn_enemy036", Vector3(-4300, 2500, 0), Rotation(180, 0, 0), optsBesiegeDummy_5),
	Eclipse.mission_elements.gen_dummy(400043, "haunted_spawn_enemy037", Vector3(-4225, 2500, 0), Rotation(180, 0, 0), optsBesiegeDummy_5),
	Eclipse.mission_elements.gen_dummy(400044, "haunted_spawn_enemy038", Vector3(-4150, 2500, 0), Rotation(180, 0, 0), optsBesiegeDummy_5),
	Eclipse.mission_elements.gen_dummy(400045, "haunted_spawn_enemy039", Vector3(-4075, 2500, 0), Rotation(180, 0, 0), optsBesiegeDummy_5),
	Eclipse.mission_elements.gen_dummy(400046, "haunted_spawn_enemy040", Vector3(-4000, 2500, 0), Rotation(180, 0, 0), optsBesiegeDummy_5),
	Eclipse.mission_elements.gen_spawngroup(400047, "haunted_enemy_group008", { 400042, 400043, 400044, 400045, 400046 }, 0),

	Eclipse.mission_elements.gen_preferedadd(400048, "haunted_add_spawns_basement", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedadd(400049, "haunted_add_spawns_garage", optsPreferedAdd2),
	Eclipse.mission_elements.gen_toggleelement(400050, "haunted_enable_swat", optsDisableSWATs),
	Eclipse.mission_elements.gen_toggleelement(400051, "haunted_disable_helldozers", optsDisableHelldozers),

	Eclipse.mission_elements.gen_so(400052, "haunted_cloaker_hide_so001", Vector3(-2900, 3725, -400), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400053, "haunted_cloaker_hide_so002", Vector3(-2875, 4625, -400), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400054, "haunted_cloaker_hide_so003", Vector3(-1525, 4000, -400), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400055, "haunted_cloaker_hide_so004", Vector3(-1575, 4575, -400), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400056, "haunted_cloaker_hide_so005", Vector3(-875, 4575, -400), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400057, "haunted_cloaker_hide_so006", Vector3(-1050, 2925, -400), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400058, "haunted_cloaker_hide_so007", Vector3(-325, 3250, -400), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400059, "haunted_cloaker_hide_so008", Vector3(-350, 4225, -400), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_sogroup(400060, "haunted_cloaker_hide_so_group", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup),
}
return M
