---@module Prison Nightmare
local M = {}

local optsWheelsDoneCounter = {
	enabled = true,
}
local optsWheelsDoneCounterOperator = {
	operation = "add",
	amount = 1,
	elements = {
		400001,
	},
	enabled = true,
}
local optsWheelsDoneCounterTrigger = {
	trigger_type = "value",
	amount = 8,
	elements = {
		400001,
	},
	enabled = true,
}

M.elements = {
	-- FFO stuff
	Eclipse.mission_elements.gen_counter(400001, "wheel_done_counter", optsWheelsDoneCounter),
	Eclipse.mission_elements.gen_counter_operator(400002, "wheel_done_counter_addend", optsWheelsDoneCounterOperator),
	Eclipse.mission_elements.gen_counter_trigger(400003, "wheel_done_counter_trigger", optsWheelsDoneCounterTrigger),
}
return M
