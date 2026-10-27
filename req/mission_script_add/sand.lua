---@module Ukrainian Prisoner
local M = {}

local optsDifficultyAddend01 = {
	trigger_times = 1,
	difficulty_addends = {
		{
			amount = 0.25,
			delay = 0,
			time = 60,
			time_balance_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	enabled = true,
}

M.elements = {
	-- Scripted difficulty steps
	Eclipse.mission_elements.gen_difficulty(400001, "sand_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400002, "sand_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
}

return M
