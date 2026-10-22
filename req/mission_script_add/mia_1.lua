---@module Hotline Miami Day 1
local M = {}

local optsAssaultEnd = {
	global_event = "end_assault",
	enabled = true,
}
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
local optsDifficultyAddend02 = {
	difficulty_addends = {
		{
			amount = 0.125,
			delay = 0,
			time = 30,
		},
	},
	enabled = true,
}

M.elements = {
	Eclipse.mission_elements.gen_global_event(400001, "assault_end", Vector3(0, 0, 0), Rotation(0, 0, 0), optsAssaultEnd),
	Eclipse.mission_elements.gen_difficulty(400002, "mia_1_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400003, "mia_1_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400004, "mia_1_difficulty_addend03", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend02),
}
return M
