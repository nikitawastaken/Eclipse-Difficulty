---@module Rats Day 1
local M = {}
local is_eclipse = Eclipse.utils.is_eclipse()

local activate_navlinks = {
	enabled = is_eclipse,
	trigger_times = 1,
	on_executed = {
		{ id = 101483, delay = 0 },
		{ id = 101484, delay = 0 },
		{ id = 101485, delay = 0 },
		{ id = 101486, delay = 0 },
		{ id = 101508, delay = 0 },
		{ id = 101770, delay = 0 },
		{ id = 101509, delay = 0 },
		{ id = 101510, delay = 0 },
		{ id = 102124, delay = 0 },
		{ id = 102125, delay = 0 },
		{ id = 101872, delay = 0 },
		{ id = 101873, delay = 0 },
	},
}

M.elements = {
	-- activate Eclipse exclusive event
	Eclipse.mission_elements.gen_missionscript(400001, "activate_eclipse_navlinks", activate_navlinks),
}

return M
