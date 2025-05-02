---@module Watchdogs Day 1
local M = {}

local optsHunt_SO = {
	SO_access = tostring(2048 + 4096),
	path_style = "none",
	scan = true,
	so_action = "AI_hunt",
}

M.elements = {
	-- AI_Hunt SO for scripted shield and dozer
	Eclipse.mission_elements.gen_so(400001, "ai_hunt_so", Vector3(-7273, -2895, -19.999), Rotation(0, 0, -0), optsHunt_SO),
}

return M
