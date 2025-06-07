---@module Mallcrasher
local M = {}
local optsPreferedAdd = {
	spawn_groups = { 300313 },
	enabled = true,
}
M.elements = {
	Eclipse.mission_elements.gen_preferedadd(400000, "eclipse_mallcrasher_street", optsPreferedAdd),
}

return M
