---@module Reservoir Dogs (Day 2 but actually Day 1 idfk)
local M = {}

local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()

local optsAmbushShield = {
	enemy = scripted_enemy.elite_shield,
	on_executed = { { id = 400009, delay = 0 } },
	enabled = true,
}
local optsAmbushSpooc = {
	enemy = scripted_enemy.cloaker,
	on_executed = { { id = 400009, delay = 0 } },
	enabled = true,
}
local optsAmbushTaser = {
	enemy = scripted_enemy.taser_1,
	on_executed = { { id = 400009, delay = 0 } },
	enabled = true,
}
local optsspawnEvilAmbush = {
	on_executed = {
		{ id = 400001, delay = 0 },
		{ id = 400002, delay = 0 },
		{ id = 400003, delay = 0 },
		{ id = 400004, delay = 0 },
		{ id = 400005, delay = 0 },
		{ id = 400006, delay = 0 },
		{ id = 400007, delay = 0 },
		{ id = 400008, delay = 0 },
	},
	enabled = is_eclipse_pro,
}
local optsHuntSO = {
	SO_access = tostring(1024 + 2048 + 8192),
	path_style = "none",
	scan = true,
	use_instigator = true,
	interval = 2,
	so_action = "AI_hunt",
}

M.elements = {
	-- Evil Ambush for DWPJ
	Eclipse.mission_elements.gen_dummy(400001, "spooc_ambush_1", Vector3(3010, 4440, 50.937), Rotation(-180, 0, 0), optsAmbushSpooc),
	Eclipse.mission_elements.gen_dummy(400002, "spooc_ambush_2", Vector3(2957, 4501, 50.937), Rotation(-180, 0, 0), optsAmbushSpooc),
	Eclipse.mission_elements.gen_dummy(400003, "spooc_ambush_3", Vector3(2894, 4548, 50.937), Rotation(-180, 0, 0), optsAmbushSpooc),
	Eclipse.mission_elements.gen_dummy(400004, "shield_lobby_1", Vector3(2569, 4432, 50.937), Rotation(-180, 0, 0), optsAmbushShield),
	Eclipse.mission_elements.gen_dummy(400005, "shield_lobby_2", Vector3(2507, 4436, 50.937), Rotation(-180, 0, 0), optsAmbushShield),
	Eclipse.mission_elements.gen_dummy(400006, "shield_lobby_3", Vector3(2440, 4426, 50.937), Rotation(-180, 0, 0), optsAmbushShield),
	Eclipse.mission_elements.gen_dummy(400007, "taser_ambush_1", Vector3(2541, 4574, 50.937), Rotation(-180, 0, 0), optsAmbushTaser),
	Eclipse.mission_elements.gen_dummy(400008, "taser_ambush_2", Vector3(2453, 4574, 50.937), Rotation(-180, 0, 0), optsAmbushTaser),
	Eclipse.mission_elements.gen_so(400009, "ambush_hunt", Vector3(0, 0, 0), Rotation(0, 0, 0), optsHuntSO),
	Eclipse.mission_elements.gen_missionscript(400010, "evil_ambush", optsspawnEvilAmbush),
}

return M
