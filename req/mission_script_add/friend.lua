---@module Scarface's Mansion
local M = {}
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()

local bags_required = (is_eclipse and 6 or 4) + (is_pro_job and 2 or 0)

local optsPreferedAdd1 = {
	spawn_groups = { 100130 },
	enabled = true,
}
local optsPreferedRemove1 = {
	elements = { 400001 },
	enabled = true,
}
local optsPreferedAdd2 = {
	spawn_groups = { 100132, 102381 },
	enabled = true,
}
local optsPreferedRemove2 = {
	elements = { 400003 },
	enabled = true,
}

local optsinstance_bag_requirment = {
	instance = "obj_link_005",
	params = {
		var_amount_death_wish = bags_required,
		var_amount_hard = bags_required,
		var_amount_normal = bags_required,
		var_amount_overkill = bags_required,
		var_amount_very_hard = bags_required,
		var_objective = "friend_loud_08",
	},
}

M.elements = {
	-- Prefereds
	Eclipse.mission_elements.gen_preferedadd(400001, "van_garden_preferedadd", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedremove(400002, "van_garden_preferedremove", optsPreferedRemove1),
	Eclipse.mission_elements.gen_preferedadd(400003, "van_garden_preferedadd", optsPreferedAdd2),
	Eclipse.mission_elements.gen_preferedremove(400004, "van_garden_preferedremove", optsPreferedRemove2),
	-- change bag requirments
	Eclipse.mission_elements.gen_instance_params(400005, "new_bag_requirment", Vector3(0, 0, 0), Rotation(0, 0, 0), optsinstance_bag_requirment),
}
return M
