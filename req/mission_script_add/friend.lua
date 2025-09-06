---@module Scarface's Mansion
local M = {}
local optsPreferedAdd1 = {
	spawn_groups = { 100130 },
	enabled = true,
}
local optsPreferedRemove1 = {
	elements = { 400001 },
	enabled = true,
}
local optsPreferedAdd2 = {
	spawn_groups = { 100132, 102381 },
	enabled = true,
}
local optsPreferedRemove2 = {
	elements = { 400003 },
	enabled = true,
}

M.elements = {
	Eclipse.mission_elements.gen_preferedadd(400001, "van_garden_preferedadd", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedremove(400002, "van_garden_preferedremove", optsPreferedRemove1),
	Eclipse.mission_elements.gen_preferedadd(400003, "van_garden_preferedadd", optsPreferedAdd2),
	Eclipse.mission_elements.gen_preferedremove(400004, "van_garden_preferedremove", optsPreferedRemove2),
}
return M
