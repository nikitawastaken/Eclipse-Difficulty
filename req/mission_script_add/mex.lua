---@module Border Crossing
local M = {}

local optsDisable_Spawngroup_1 = {
	toggle = "off",
	enabled = true,
	elements = {
		100694,
	},
}
local optsDisable_Spawngroup_2 = {
	toggle = "off",
	enabled = true,
	elements = {
		102227,
	},
}
local optsDisable_Spawngroup_3 = {
	toggle = "off",
	enabled = true,
	elements = {
		102255,
	},
}

M.elements = {
	-- disable spawngroups depending on which tunnel has been choosen
	Eclipse.mission_elements.gen_toggleelement(400001, "disable_spawngroup_1", optsDisable_Spawngroup_1),
	Eclipse.mission_elements.gen_toggleelement(400002, "disable_spawngroup_2", optsDisable_Spawngroup_2),
	Eclipse.mission_elements.gen_toggleelement(400003, "disable_spawngroup_3", optsDisable_Spawngroup_3),
}

return M
