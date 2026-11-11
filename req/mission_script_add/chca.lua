---@module The Black Cat
local M = {}

local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value

local optsObjectivesDoneCounter = {
	enabled = true,
}
local optsObjectivesDoneCounterOperator = {
	operation = "add",
	amount = 1,
	elements = {
		400001,
	},
	enabled = true,
}
local optsObjectivesDoneCounterTrigger = {
	trigger_type = "value",
	amount = 2,
	elements = {
		400001,
	},
	enabled = true,
}
local optsDifficultyAddend01 = {
	trigger_times = 1,
	difficulty_addends = {
		{
			amount = 0.25,
			delay = 0,
			time = 60,
			time_mul = get_difficulty_specific_value({ 1.2, 1.1, 1, 0.9, 0.8 }),
			time_balance_mul = { 1.5, 1.25, 1, 1 },
		},
	},
	enabled = true,
}

M.elements = {
	Eclipse.mission_elements.gen_counter(400001, "objectives_done_counter", optsObjectivesDoneCounter),
	Eclipse.mission_elements.gen_counter_operator(400002, "objectives_done_addend", optsObjectivesDoneCounterOperator),
	Eclipse.mission_elements.gen_counter_trigger(400003, "objectives_done_trigger", optsObjectivesDoneCounterTrigger),

	Eclipse.mission_elements.gen_difficulty(400004, "chca_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400005, "chca_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
}
return M
