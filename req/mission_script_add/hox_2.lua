---@module Hoxton Breakout (Day 2)
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()

local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts

local dozer_random_amount = overkill_and_above and 2 or 1
local dozers_respawn = (is_eclipse and 300 or 360) - (is_eclipse_pro and 60 or is_pro_job and 30 or 0)
local dozer_event = not normal or (is_pro_job and normal) and true or false

local enabled_chance_cloakers = math.random() <= 0.4 + (is_pro_job and 0.2 or 0)
local ambush_units_amount = is_eclipse and 2 or 1

local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local green_bulldozer = scripted_enemy.bulldozer_1
local cloaker = scripted_enemy.cloaker
local taser = scripted_enemy.taser_1
local shield = is_eclipse and scripted_enemy.elite_shield or scripted_enemy.shield

local swats = { [swat_1] = 2, [swat_2] = 1 }

local optsSWAT = {
	enemy_table = swats,
	enabled = true,
}
local optsTaser = {
	enemy = taser,
	enabled = true,
}
local optsShield = {
	enemy = shield,
	enabled = true,
}
local optsCloaker_1 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400044, delay = 0 } },
	enabled = true,
}
local optsCloaker_2 = {
	enemy = cloaker,
	participate_to_group_ai = true,
	on_executed = { { id = 400045, delay = 0 } },
	enabled = true,
}
local optsSneaky_Bulldozer_1 = {
	enemy = is_eclipse and elite_ben_bulldozer or green_bulldozer,
	on_executed = { { id = 400060, delay = 0 } },
	enabled = true,
}
local optsSneaky_Bulldozer_2 = {
	enemy = is_eclipse and elite_ben_bulldozer or green_bulldozer,
	on_executed = { { id = 400061, delay = 0 } },
	enabled = true,
}
local optsCloaker_Basement = {
	enemy = cloaker,
	enabled = true,
}
local optsBesiegeDummyCloaker_1 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_repel_into_window",
	enabled = true,
}
local optsBesiegeDummyCloaker_2 = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	enabled = true,
}
local optsPreferedCloakerAdd1 = {
	spawn_groups = { 400091, 400092, 400093, 400094, 400095, 400096, 400097, 400098, 400099 },
	on_executed = {
		{ id = 400107, delay = 0 },
	},
	enabled = true,
}
local optsCloaker_Hide_SO = {
	SO_access = "1024",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "e_so_idle_by_container",
}
local optsDozer_Hide_SO = {
	SO_access = "4096",
	scan = true,
	align_position = true,
	needs_pos_rsrv = true,
	align_rotation = true,
	use_instigator = true,
	interval = 2,
	so_action = "e_so_sneak_wait_stand",
}

local optsCloakerHideGroup = {
	followup_elements = {
		400066,
		400067,
		400068,
		400069,
		400071,
		400072,
		400077,
		400078,
		400079,
		400080,
		400081,
	},
}
local optsCloakerHideGroupUpstairs = {
	followup_elements = {
		400070,
		400073,
		400074,
		400075,
		400076,
	},
}
local optsAddCloakerHideGroupsDefault = {
	enabled = true,
	on_executed = {
		{ id = 400101, delay = 0 },
	},
}
local optsAddCloakerHideGroupsUpstairs = {
	enabled = true,
	on_executed = {
		{ id = 400106, delay = 0 },
	},
}

local spawn_cloaker_ambush = {
	enabled = normal_and_above and enabled_chance_cloakers,
	on_executed = {
		{ id = 400046, delay = 0 },
		{ id = 400042, delay = 0.5 },
		{ id = 400043, delay = 0.5 },
	},
}
local optscloaker_alerticon_exploitfix = {
	elements = {
		400042,
		400043,
	},
}
local optsdisable_the_plants = {
	unit_ids = {
		301002,
		301001,
		301000,
		300999,
	},
}

local pick_blockade_units = {
	amount = ambush_units_amount,
	amount_random = 1,
	on_executed = {
		{ id = 400049, delay = 0 },
		{ id = 400054, delay = 0 },
		{ id = 400057, delay = 0 },
		{ id = 400062, delay = 0 },
	},
}

local spawn_cloaker_basement = {
	enabled = true,
	on_executed = {
		{ id = 400048, delay = 0 },
	},
}

local spawn_swat_basement = {
	enabled = true,
	on_executed = {
		{ id = 400050, delay = 0 },
		{ id = 400051, delay = 0 },
		{ id = 400052, delay = 0 },
		{ id = 400053, delay = 0 },
	},
}

local spawn_taser_basement = {
	enabled = true,
	on_executed = {
		{ id = 400055, delay = 0 },
		{ id = 400056, delay = 0 },
		{ id = 400065, delay = 0 },
	},
}

local spawn_dozer_basement = {
	amount = 1,
	on_executed = {
		{ id = 400058, delay = 0 },
		{ id = 400059, delay = 0 },
	},
}
local spawn_basement_blockades = {
	enabled = true,
	on_executed = {
		{ id = 400063, delay = 0.1 },
	},
}

-- Hiding Cloaker SOs are funny
local hide_so_search_pos = Vector3(0, 2700, -100)
local optsCloaker_Hide_SpotSO_1 = get_hiding_cloaker_so_opts("e_so_hide_under_car_enter", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_2 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_3 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var3", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_4 = get_hiding_cloaker_so_opts("e_so_sneak_wait_crh_var2", hide_so_search_pos)
local optsCloaker_Hide_SpotSO_5 = get_hiding_cloaker_so_opts("e_so_hide_behind_door_enter", hide_so_search_pos)

M.elements = {

	-- suprise cloakers at the start of the heist (so evil)
	Eclipse.mission_elements.gen_dummy(400042, "spooc_ambush_1", Vector3(-585, 4399, -500), Rotation(-90, 0, 0), optsCloaker_1),
	Eclipse.mission_elements.gen_dummy(400043, "spooc_ambush_2", Vector3(265, 4400, -500), Rotation(90, 0, 0), optsCloaker_2),
	Eclipse.mission_elements.gen_so(400044, "spooc_ambush_hide_so_1", Vector3(-549, 4401, -500), Rotation(-90, 0, 0), optsCloaker_Hide_SO),
	Eclipse.mission_elements.gen_so(400045, "spooc_ambush_hide_so_2", Vector3(190, 4401, -500), Rotation(90, 0, 0), optsCloaker_Hide_SO),
	Eclipse.mission_elements.gen_disable_unit(400046, "disable_plants", Vector3(0, 0, 0), Rotation(0, 0, 0), optsdisable_the_plants),
	Eclipse.mission_elements.gen_missionscript(400047, "cloaker_ambush_event", spawn_cloaker_ambush),
	Eclipse.mission_elements.gen_dummytrigger(400109, "alert_icon_exploit_fix", Vector3(0, 0, 0), Rotation(0, 0, 0), optscloaker_alerticon_exploitfix),

	-- add blockade units when you open the basement door (with some evil stuff)
	-- cloaker
	Eclipse.mission_elements.gen_dummy(400048, "spooc_basement", Vector3(-1116, 4875, -500), Rotation(-82, 0, 0), optsCloaker_Basement),
	Eclipse.mission_elements.gen_missionscript(400049, "cloaker", spawn_cloaker_basement),
	-- swats
	Eclipse.mission_elements.gen_dummy(400050, "swat_basement_1", Vector3(-1557.012, 4645.163, -700), Rotation(-85, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400051, "swat_basement_2", Vector3(-1566, 4716, -700), Rotation(-84, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400052, "swat_basement_3", Vector3(-1590.777, 4808.281, -700), Rotation(-102, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_dummy(400053, "swat_basement_4", Vector3(-1587.115, 4916.893, -700), Rotation(-102, 0, 0), optsSWAT),
	Eclipse.mission_elements.gen_missionscript(400054, "swats", spawn_swat_basement),
	-- tasers and shield
	Eclipse.mission_elements.gen_dummy(400055, "taser_basement_1", Vector3(-1079.231, 4977.013, -900), Rotation(108, 0, 0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400056, "taser_basement_2", Vector3(-1082.978, 4875.570, -900), Rotation(93, 0, 0), optsTaser),
	Eclipse.mission_elements.gen_dummy(400065, "shield_basement_1", Vector3(-1165.123, 4909.564, -900), Rotation(99, 0, 0), optsShield),
	Eclipse.mission_elements.gen_missionscript(400057, "tasers", spawn_taser_basement),
	-- sneaky dozer
	Eclipse.mission_elements.gen_dummy(400058, "dozer_basement_1", Vector3(-494, 4796, -940), Rotation(0, 0, 0), optsSneaky_Bulldozer_1),
	Eclipse.mission_elements.gen_dummy(400059, "dozer_basement_2", Vector3(-470.131, 5407.491, -922), Rotation(174, 0, 0), optsSneaky_Bulldozer_2),
	Eclipse.mission_elements.gen_so(400060, "dozer_basement_hide_so_1", Vector3(-507, 4845, -940), Rotation(-90, 0, 0), optsDozer_Hide_SO),
	Eclipse.mission_elements.gen_so(400061, "dozer_basement_hide_so_2", Vector3(-471, 5321, -940), Rotation(-90, 0, 0), optsDozer_Hide_SO),
	Eclipse.mission_elements.gen_element_random(400062, "dozer", spawn_dozer_basement),
	-- global basement blockades
	Eclipse.mission_elements.gen_element_random(400063, "select_random_blockade", pick_blockade_units),
	Eclipse.mission_elements.gen_missionscript(400064, "start_basement_units_blockade", spawn_basement_blockades),

	-- New Cloakers and their hiding spots
	-- hiding spots
	Eclipse.mission_elements.gen_so(400066, "cloaker_hide_so_1", Vector3(-317, 1536, -100), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400067, "cloaker_hide_so_2", Vector3(890, 1147, -100), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400068, "cloaker_hide_so_3", Vector3(1295, 4243, -495), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400069, "cloaker_hide_so_4", Vector3(663, 3340, -500), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400070, "cloaker_hide_so_5", Vector3(-1275, 2394, -100), Rotation(-180, 0, 0), optsCloaker_Hide_SpotSO_4),
	Eclipse.mission_elements.gen_so(400071, "cloaker_hide_so_6", Vector3(-812.010, 4542.311, -100), Rotation(-93, 0, 0), optsCloaker_Hide_SpotSO_5),
	Eclipse.mission_elements.gen_so(400072, "cloaker_hide_so_7", Vector3(-1275, 1713, -100), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_3),
	Eclipse.mission_elements.gen_so(400073, "cloaker_hide_so_8", Vector3(-384, 2300, 300.395), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400074, "cloaker_hide_so_9", Vector3(218, 2300, 300.395), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400075, "cloaker_hide_so_10", Vector3(1463, 1770, 300), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400076, "cloaker_hide_so_11", Vector3(1463, 1070, 300), Rotation(0, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400077, "cloaker_hide_so_12", Vector3(-1400, 1045, -100), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400078, "cloaker_hide_so_13", Vector3(1220, 2153, -99.065), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400079, "cloaker_hide_so_14", Vector3(1072, 456, -100), Rotation(90, 0, 0), optsCloaker_Hide_SpotSO_1),
	Eclipse.mission_elements.gen_so(400080, "cloaker_hide_so_15", Vector3(876, -21, -100), Rotation(-90, 0, 0), optsCloaker_Hide_SpotSO_2),
	Eclipse.mission_elements.gen_so(400081, "cloaker_hide_so_16", Vector3(219, 1538, -100), Rotation(180, 0, 0), optsCloaker_Hide_SpotSO_1),
	-- cloakers
	Eclipse.mission_elements.gen_dummy(400082, "cloaker_spawn_1", Vector3(-1050, 3286, 301), Rotation(-90, 0, 0), optsBesiegeDummyCloaker_1),
	Eclipse.mission_elements.gen_dummy(400083, "cloaker_spawn_2", Vector3(4261, 844, 300), Rotation(0, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400084, "cloaker_spawn_3", Vector3(4261, 362, 300), Rotation(180, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400085, "cloaker_spawn_4", Vector3(-726, 6158, 300), Rotation(90, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400086, "cloaker_spawn_5", Vector3(-1222, 4557, 300), Rotation(0, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400087, "cloaker_spawn_6", Vector3(515, 5646, 300.822), Rotation(0, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400088, "cloaker_spawn_7", Vector3(1296, 3052, 300.935), Rotation(0, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400089, "cloaker_spawn_8", Vector3(-2114, 7037, -500), Rotation(0, 0, 0), optsBesiegeDummyCloaker_2),
	Eclipse.mission_elements.gen_dummy(400090, "cloaker_spawn_9", Vector3(-3176, 6075, -500), Rotation(0, 0, 0), optsBesiegeDummyCloaker_2),
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(400091, "hox_cloaker_spawngroup_01", { 400082 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400092, "hox_cloaker_spawngroup_02", { 400083 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400093, "hox_cloaker_spawngroup_03", { 400084 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400094, "hox_cloaker_spawngroup_04", { 400085 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400095, "hox_cloaker_spawngroup_05", { 400086 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400096, "hox_cloaker_spawngroup_06", { 400087 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400097, "hox_cloaker_spawngroup_07", { 400088 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400098, "hox_cloaker_spawngroup_08", { 400089 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400099, "hox_cloaker_spawngroup_09", { 400090 }, 0),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(400100, "hox_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_sogroup(400101, "cloakerHideGroupDefault", Vector3(-264, 1632, -100), Rotation(0, 0, 0), optsCloakerHideGroup),
	Eclipse.mission_elements.gen_sogroup(400106, "cloakerHideGroupUpstairs", Vector3(-144, 2208, 300.935), Rotation(0, 0, 0), optsCloakerHideGroupUpstairs),
	Eclipse.mission_elements.gen_missionscript(400107, "addCloakerHideGroupsDefault", optsAddCloakerHideGroupsDefault),
	Eclipse.mission_elements.gen_missionscript(400108, "addCloakerHideGroupsUpstairs", optsAddCloakerHideGroupsUpstairs),
}

return M
