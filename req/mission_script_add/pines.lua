---@module White Xmas
local M = {}
local optsdisable_cop_lights = {
	unit_ids = {
		100213,
		100061,
		100290,
		104712,
		100214,
		100058,
	},
}
local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts
local optsPreferedCloakerAdd1 = {
	spawn_groups = { 400026, 400027, 400028, 400029, 400030, 400031, 400032, 400033 },
	on_executed = {
		{ id = 400035, delay = 0 },
	},
	enabled = true,
}
local optsAddCloakerHideGroup = {
	enabled = true,
	on_executed = {
		{ id = 400034, delay = 0 },
	},
}
local optsCloakerHideGroup = {
	followup_elements = {
		400010,
		400011,
		400012,
		400013,
		400014,
		400015,
		400016,
		400017,
		400018,
		400019,
		400020,
		400021,
		400022,
		400023,
		400024,
		400025,
	},
}
local optsAssaultStarted = {
	enabled = true,
	global_event = "start_assault",
	trigger_times = 1,
	on_executed = {
		{ id = 400036, delay = 0 },
	},
}
-- Hiding Cloaker SOs are funny
local hide_so_search_pos = Vector3(-2937, 7563, 3050.033)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_hide_under_car_enter", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var3", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_4 = get_hiding_cloaker_so_opts("e_so_sneak_wait_stand", hide_so_search_pos)

M.elements = {
	-- disable cop car lights
	Eclipse.mission_elements.gen_disable_unit(400001, "disable_cop_car_lights", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdisable_cop_lights),
	-- New Cloakers and their hiding spots
	-- hiding spots
	Eclipse.mission_elements.gen_so(400010, "cloaker_hide_so_1", Vector3(-7932, 14259, 4252.500), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400011, "cloaker_hide_so_2", Vector3(-7089.650, 10810.216, 4201.199), Rotation(34, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400012, "cloaker_hide_so_3", Vector3(-7709.402, 10477.996, 3651.622), Rotation(159, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400013, "cloaker_hide_so_4", Vector3(-7205, 12965, 4041.098), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400014, "cloaker_hide_so_5", Vector3(-8299.793, 6214.377, 3347.015), Rotation(-46, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400015, "cloaker_hide_so_6", Vector3(-10193.638, 7866.722, 3521.427), Rotation(175, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400016, "cloaker_hide_so_7", Vector3(-8565, 13510, 4269.322), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400017, "cloaker_hide_so_8", Vector3(-5686.258, 14011.527, 3890.693), Rotation(-170, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400018, "cloaker_hide_so_9", Vector3(-10980.581, 6930.371, 3542.52), Rotation(-77, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400019, "cloaker_hide_so_10", Vector3(-3834.224, 12705.191, 3320.103), Rotation(-72, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400020, "cloaker_hide_so_11", Vector3(-3411.753, 9274.207, 2953.886), Rotation(-161, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400021, "cloaker_hide_so_12", Vector3(-5637.013, 11123.267, 3969.764), Rotation(-175, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400022, "cloaker_hide_so_13", Vector3(-8839.248, 11420.078, 3947.508), Rotation(152, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400023, "cloaker_hide_so_14", Vector3(-6341, 8207, 2924.243), Rotation(97, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400024, "cloaker_hide_so_15", Vector3(-7871, 13580, 4252.500), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400025, "cloaker_hide_so_16", Vector3(-3536.951, 8249.801, 3008.486), Rotation(53, 0, 0), optsCloaker_Hide_SpotSO_2),
	-- White Xmas already has enough cloaker spawns
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(400026, "pines_cloaker_spawngroup_01", { 100843 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400027, "pines_cloaker_spawngroup_02", { 100849 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400028, "pines_cloaker_spawngroup_03", { 100853 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400029, "pines_cloaker_spawngroup_04", { 100857 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400030, "pines_cloaker_spawngroup_05", { 100861 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400031, "pines_cloaker_spawngroup_06", { 100865 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400032, "pines_cloaker_spawngroup_07", { 100869 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400033, "pines_cloaker_spawngroup_08", { 101183 }, 0),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(400034, "pines_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_sogroup(400035, "pines_cloaker_hide_group", hide_so_search_pos, Rotation(0, 0, 0), optsCloakerHideGroup),
	Eclipse.mission_elements.gen_missionscript(400036, "pines_cloaker_spawn_global", optsAddCloakerHideGroup),
	Eclipse.mission_elements.gen_global_event(400037, "pines_assault_start", Vector3(0, 0, 0), Rotation(0, 0, 0), optsAssaultStarted),
}

return M
