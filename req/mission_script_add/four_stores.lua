---@module Four Stores
local M = {}
local optsPreferedAdd = {
	spawn_groups = { 101375 },
	enabled = true,
}
M.elements = {
	Eclipse.mission_elements.gen_preferedadd(400001, "eclipse_rappel_preferedadd", optsPreferedAdd),
}
return M
