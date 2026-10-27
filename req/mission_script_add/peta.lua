---@module Goat Simulator Day 1
local M = {}

local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()

local bags_required = (normal and 5 or hard and 8 or 10) + (is_pro_job and 2 or 0)

local optsinstance_bag_requirment = {
	instance = "obj_link_002",
	params = {
		var_amount_death_wish = bags_required,
		var_amount_hard = bags_required,
		var_amount_normal = bags_required,
		var_amount_overkill = bags_required,
		var_amount_very_hard = bags_required,
		var_objective = "heist_pet1_2",
	},
}
local optsFoundAnyGoat = {
	enabled = true,
}
local optsDifficultyAddend01 = {
	difficulty_addends = {
		{
			amount = 0.075,
			delay = 0,
			time = 15,
			time_balance_mul = { 2.5, 2, 1.5, 1 },
		},
	},
	enabled = true,
}

M.elements = {
	-- change bag requirments
	Eclipse.mission_elements.gen_instance_params(400001, "new_bag_requirment", Vector3(0, 0, 0), Rotation(0, 0, 0), optsinstance_bag_requirment),

	Eclipse.mission_elements.gen_missionscript(400002, "found_any_goat", optsFoundAnyGoat),

	-- Scripted difficulty steps
	Eclipse.mission_elements.gen_difficulty(400003, "peta1_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
}

return M
