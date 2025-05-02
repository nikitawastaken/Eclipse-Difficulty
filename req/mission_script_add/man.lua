---@module Undercover
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local hard_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local cloaker = scripted_enemy.cloaker

local optsBesiegeDummyCloaker = {
	trigger_times = 0,
	enemy = cloaker,
	participate_to_group_ai = true,
	spawn_action = "e_sp_clk_exit_vent_1_5m",
	enabled = true,
}
local optsPreferedCloakerAdd1 = {
	spawn_groups = { 400003 },
	enabled = hard_and_above,
}

M.elements = {
	-- restore cloaker vent spawns and add missing spawns
	Eclipse.mission_elements.gen_dummy(400000, "new_cloaker_1", Vector3(-1260, -2808, 299.986), Rotation(0, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400001, "new_cloaker_2", Vector3(-1440, -2129, 475.001), Rotation(180, 0, 0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_dummy(400002, "new_cloaker_3", Vector3(-2098, 416, -998), Rotation(-177, 0, -0), optsBesiegeDummyCloaker),
	Eclipse.mission_elements.gen_spawngroup(400003, "new_cloaker_spawngroup", { 400000, 400001, 400002, 103794, 103796, 103797, 103800, 103801 }, 0),

	Eclipse.mission_elements.gen_preferedadd(400004, "new_cloaker_spawns", optsPreferedCloakerAdd1),
}
return M