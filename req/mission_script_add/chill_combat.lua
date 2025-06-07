---@module Safehouse Raid
local M = {}
local optsPreferedAdd1 = {
	spawn_groups = { 101178, 100994 },
	enabled = true,
}
local optsPreferedAdd2 = {
	spawn_groups = { 100993, 101131 },
	enabled = true,
}
local optsPreferedAdd3 = {
	spawn_groups = { 101038, 101204 },
	enabled = true,
}
local optsPreferedAdd3 = {
	spawn_groups = { 101859, 101864 },
	enabled = true,
}
M.elements = {
	Eclipse.mission_elements.gen_preferedadd(400001, "eclipse_street_preferredadd", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedadd(400002, "eclipse_bushes_preferredadd", optsPreferedAdd2),
	Eclipse.mission_elements.gen_preferedadd(400003, "eclipse_roof_preferredadd", optsPreferedAdd3),
	Eclipse.mission_elements.gen_preferedadd(400004, "eclipse_window_preferredadd", optsPreferedAdd4),
}
return M
