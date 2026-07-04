---@module Border Crossing
local M = {}

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
	amount = 15,
	elements = {
		400004,
	},
	enabled = true,
}

M.elements = {
	-- disable spawngroups depending on which tunnel has been choosen
	Eclipse.mission_elements.gen_toggleelement(400001, "disable_spawngroup_1", optsDisable_Spawngroup_1),
	Eclipse.mission_elements.gen_toggleelement(400002, "disable_spawngroup_2", optsDisable_Spawngroup_2),
	Eclipse.mission_elements.gen_toggleelement(400003, "disable_spawngroup_3", optsDisable_Spawngroup_3),
	--	Eclipse.mission_elements.gen_counter(400004, "cooked_bags_counter", optsCookedBagsCounter),
	--	Eclipse.mission_elements.gen_counter_operator(400005, "cooked_bags_counter_addend", optsCookedBagsCounterOperator),
	--	Eclipse.mission_elements.gen_counter_trigger(400006, "cooked_bags_counter_trigger", optsCookedBagsCounterTrigger),
}

return M
