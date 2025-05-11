---@module Four Stores
local M = {}
local optsPreferedAdd1 = {
	spawn_groups = { 100128, 100130, 100131, 100133 },
	enabled = true,
}
local optsPreferedAdd2 = {
	spawn_groups = { 100007, 100019, 100132, 101470 },
	enabled = true,
}
M.elements = {
	Eclipse.mission_elements.gen_preferedadd(400001, "eclipse_street_preferredadd", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedadd(400002, "eclipse_roof_preferredadd", optsPreferedAdd2),
}
return M
