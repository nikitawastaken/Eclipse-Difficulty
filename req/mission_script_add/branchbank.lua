---@module Bank Heist
local M = {}

local diff_i = Eclipse.utils.difficulty_index()
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local elite_bulldozer = scripted_enemy.elite_bulldozer_2

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
	so_action = "AI_defend",
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

M.elements = {
	-- skulldozer nearby the van on Eclipse (based on DW Trailer)
	Eclipse.mission_elements.gen_dummy(400001, "van_dozer", Vector3(-8305, -3511, 0), Rotation(-90, 0, -0), optsBulldozer),
	Eclipse.mission_elements.gen_so(400002, "dozer_defend_so", Vector3(-7273, -2895, -19.999), Rotation(0, 0, -0), optsDefend_SO),
	Eclipse.mission_elements.gen_toggleelement(400003, "enable_dozervan", optsEnable_DWDozer),
	Eclipse.mission_elements.gen_toggleelement(400004, "disable_dozervan", optsDisable_DWDozer),
}

return M
