---@module Hostile Takeover
local M = {}

local optsDifficultyAddend01 = {
	trigger_times = 1,
	difficulty_addends = {
		{
			amount = 1 / 3,
			delay = 0,
			time = 60,
			time_balance_mul = { 2, 1.5, 1, 1 },
		},
	},
	enabled = true,
}

M.elements = {
	Eclipse.mission_elements.gen_difficulty(400001, "corp_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400002, "corp_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
}
return M
