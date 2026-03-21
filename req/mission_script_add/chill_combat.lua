---@module Safehouse Raid
local M = {}
local diff_i = Eclipse.utils.difficulty_index()

local bags_to_defend = diff_i <= 2 and 3 or (diff_i == 3 or diff_i == 4) and 2 or 1

local optsinstance_bag_requirment = {
	instance = "obj_link_003",
	params = {
		var_amount_death_wish = bags_to_defend,
		var_amount_hard = bags_to_defend,
		var_amount_normal = bags_to_defend,
		var_amount_overkill = bags_to_defend,
		var_amount_very_hard = bags_to_defend,
		var_objective = "heist_chill2",
	},
}

local optsPreferedAdd1 = {
	spawn_groups = { 101178, 100994 },
	enabled = true,
}
local optsPreferedAdd2 = {
	spawn_groups = { 100993, 101131 },
	enabled = true,
}
local optsPreferedAdd3 = {
	spawn_groups = { 101038, 101204 },
	enabled = true,
}
local optsPreferedAdd3 = {
	spawn_groups = { 101859, 101864 },
	enabled = true,
}
M.elements = {
	Eclipse.mission_elements.gen_preferedadd(400001, "eclipse_street_preferredadd", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedadd(400002, "eclipse_bushes_preferredadd", optsPreferedAdd2),
	Eclipse.mission_elements.gen_preferedadd(400003, "eclipse_roof_preferredadd", optsPreferedAdd3),
	Eclipse.mission_elements.gen_preferedadd(400004, "eclipse_window_preferredadd", optsPreferedAdd4),
	-- change bag requirments to defend
	Eclipse.mission_elements.gen_instance_params(400005, "chill_bag_requirment", Vector3(0, 0, 0), Rotation(0, 0, 0), optsinstance_bag_requirment),
}
return M
