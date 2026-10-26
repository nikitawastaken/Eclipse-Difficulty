---@module Cursed Killroom
local M = {}

local optsDifficultyAddend01 = {
	trigger_times = 1,
	difficulty_addends = {
		{
			amount = 0.25,
			delay = 0,
			time = 3,
		},
	},
	enabled = true,
}

local optsSecuredBagsCounter = {
	enabled = true,
}
local optsSecuredBagsCounterOperator = {
	operation = "add",
	amount = 1,
	elements = {
		400010,
	},
	enabled = true,
}
local optsSecuredBagsCounterTrigger = {
	trigger_type = "value",
	amount = 14,
	elements = {
		400010,
	},
	enabled = true,
}

M.elements = {
	Eclipse.mission_elements.gen_difficulty(400001, "hvh_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400002, "hvh_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	
	-- FFO stuff
	Eclipse.mission_elements.gen_counter(400010, "Secured_bags_counter", optsSecuredBagsCounter),
	Eclipse.mission_elements.gen_counter_operator(400011, "Secured_bags_counter_addend", optsSecuredBagsCounterOperator),
	Eclipse.mission_elements.gen_counter_trigger(400012, "Secured_bags_counter_trigger", optsSecuredBagsCounterTrigger),
}
return M
