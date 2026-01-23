---@module Transport: Crossroads
local M = {}
local scripted_enemy = Eclipse.scripted_enemy

local get_hiding_cloaker_so_opts = Eclipse.utils.get_hiding_cloaker_so_opts

local cloaker = scripted_enemy.cloaker

local optsBesiegeDummyCloaker = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	enabled = true,
}
local optsPreferedCloakerAdd1 = {
	spawn_groups = { 400005, 400006, 400007, 400008 },
	on_executed = {
		{ id = 102207, delay = 0 },
	},
	enabled = true,
}
local optsAddCloakerHideGroup = {
	enabled = true,
	on_executed = {
		{ id = 400009, delay = 0 },
	},
}

M.elements = {
	-- cloakers
	Eclipse.mission_elements.gen_dummy(400001, "cloaker_spawn_1", Vector3(4450, 1100, 0), Rotation(180, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400002, "cloaker_spawn_2", Vector3(-2400, -3275, 0), Rotation(-180, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400003, "cloaker_spawn_3", Vector3(2825, 6800, 0), Rotation(90, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400004, "cloaker_spawn_4", Vector3(-5275, 1450, 0), Rotation(-180, 0, 0), optsBesiegeDummyCloaker),
	-- spawngroups
	Eclipse.mission_elements.gen_spawngroup(400005, "cro_cloaker_spawngroup_01", { 400001 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400006, "cro_cloaker_spawngroup_02", { 400002 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400007, "cro_cloaker_spawngroup_03", { 400003 }, 0),
	Eclipse.mission_elements.gen_spawngroup(400008, "cro_cloaker_spawngroup_04", { 400004 }, 0),
	-- the whole system that does the thing
	Eclipse.mission_elements.gen_preferedadd(400009, "cro_cloaker_spawns", optsPreferedCloakerAdd1),
	Eclipse.mission_elements.gen_missionscript(400010, "cro_cloaker_spawn_global", optsAddCloakerHideGroup),
}
return M
