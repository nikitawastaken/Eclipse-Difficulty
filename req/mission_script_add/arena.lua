---@module Alesso Heist
local M = {}

local is_pro_job = Eclipse.utils.is_pro_job()

local bags_required = 4 + (is_pro_job and 2 or 0)

local optsinstance_bag_requirment = {
	instance = "obj_link_009",
	params = {
		var_amount_death_wish = bags_required,
		var_amount_hard = bags_required,
		var_amount_normal = bags_required,
		var_amount_overkill = bags_required,
		var_amount_very_hard = bags_required,
		var_objective = "arena_mission_9",
	},
}
local optsDifficultyAddend01 = {
	trigger_times = 1,
	difficulty_addends = {
		{
			amount = 0.25,
			delay = 0,
			time = 60,
			time_balance_mul = { 2, 1.5, 1, 1 },
		},
	},
	enabled = true,
}
local optsDifficultyAddend02 = deep_clone(optsDifficultyAddend01)
local optsDifficultyAddend03 = deep_clone(optsDifficultyAddend01)

M.elements = {
	-- Change bag requirments
	Eclipse.mission_elements.gen_instance_params(400001, "new_bag_requirment", Vector3(0, 0, 0), Rotation(0, 0, 0), optsinstance_bag_requirment),

	-- Scripted difficulty steps
	Eclipse.mission_elements.gen_difficulty(400002, "arena_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400003, "arena_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend02),
	Eclipse.mission_elements.gen_difficulty(400004, "arena_difficulty_addend03", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend03),
}

return M
