---@module Border Crossing
local M = {}

local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value

local optsDisable_Spawngroup_1 = {
	toggle = "off",
	enabled = true,
	elements = {
		100694,
	},
}
local optsDisable_Spawngroup_2 = {
	toggle = "off",
	enabled = true,
	elements = {
		102227,
	},
}
local optsDisable_Spawngroup_3 = {
	toggle = "off",
	enabled = true,
	elements = {
		102255,
	},
}
local optsCookedBagsCounter = {
	enabled = true,
}
local optsCookedBagsCounterOperator = {
	operation = "add",
	amount = 1,
	elements = {
		400004,
	},
	enabled = true,
}
local optsCookedBagsCounterTrigger = {
	trigger_type = "value",
	amount = 15,
	elements = {
		400004,
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
	-- disable spawngroups depending on which tunnel has been choosen
	Eclipse.mission_elements.gen_toggleelement(400001, "disable_spawngroup_1", optsDisable_Spawngroup_1),
	Eclipse.mission_elements.gen_toggleelement(400002, "disable_spawngroup_2", optsDisable_Spawngroup_2),
	Eclipse.mission_elements.gen_toggleelement(400003, "disable_spawngroup_3", optsDisable_Spawngroup_3),

	Eclipse.mission_elements.gen_counter(400004, "cooked_bags_counter", optsCookedBagsCounter),
	Eclipse.mission_elements.gen_counter_operator(400005, "cooked_bags_counter_addend", optsCookedBagsCounterOperator),
	Eclipse.mission_elements.gen_counter_trigger(400006, "cooked_bags_counter_trigger", optsCookedBagsCounterTrigger),

	-- Scripted difficulty addends
	Eclipse.mission_elements.gen_difficulty(400007, "mex_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400008, "mex_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
}

return M
