---@module Firestarter Day 1
local M = {}

local choose_sniper_spot_1 = {
	amount = 1,
	on_executed = {
		{ id = 100163, delay = 0 },
		{ id = 100168, delay = 0 },
		{ id = 101906, delay = 0 },
		{ id = 101908, delay = 0 },
	},
}
local choose_sniper_spot_2 = {
	amount = 1,
	on_executed = {
		{ id = 100160, delay = 0 },
		{ id = 100161, delay = 0 },
	},
}

M.elements = {
	-- improve SO sniper spot select
	Eclipse.mission_elements.gen_element_random(400001, "choose_sniper_spot_1", choose_sniper_spot_1),
	Eclipse.mission_elements.gen_element_random(400002, "choose_sniper_spot_2", choose_sniper_spot_2),
}

return M
