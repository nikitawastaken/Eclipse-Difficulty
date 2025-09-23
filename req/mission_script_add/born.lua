---@module Biker Heist Day 1
local M = {}

local opts_swat_group = {
	spawn_type = "group_guaranteed",
	amount = 4,
}

M.elements = {
	-- twaek swat chopper
	Eclipse.mission_elements.gen_spawngroup(400001, "swat_group", { 101560, 101814, 101627, 101672 }, 0, opts_swat_group),
}

return M
