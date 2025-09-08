---@module Alesso Heist
local M = {}

local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_pro_job = Eclipse.utils.is_pro_job()

local bags_required = normal and 4 or 6 + (is_pro_job and 2 or 0)

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

M.elements = {
	-- change bag requirments
	Eclipse.mission_elements.gen_instance_params(400001, "new_bag_requirment", Vector3(0, 0, 0), Rotation(0, 0, 0), optsinstance_bag_requirment),
}

return M
