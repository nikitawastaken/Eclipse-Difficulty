---@module Boiling Point
local M = {}

local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value

local optsDifficultyAddend01 = {
	trigger_times = 1,
	difficulty_addends = {
		{
			amount = 0.375,
			delay = 0,
			time = 90,
			time_mul = get_difficulty_specific_value({ 1.2, 1.1, 1, 0.9, 0.8 }),
			time_balance_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	enabled = true,
}

M.elements = {
	Eclipse.mission_elements.gen_difficulty(400001, "mad_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400002, "mad_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
}

return M
