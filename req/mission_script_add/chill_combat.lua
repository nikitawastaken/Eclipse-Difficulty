---@module Safehouse Raid
local M = {}

local is_pro_job = Eclipse.utils.is_pro_job()
local normal, hard, eclipse = Eclipse.utils.diff_groups()

local bags_to_defend = normal and 3 or hard and 2 or 1

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
	trigger_times = 1,
	enabled = true,
}
local optsPreferedAdd2 = {
	spawn_groups = { 100993, 101131 },
	trigger_times = 1,
	enabled = true,
}
local optsPreferedAdd3 = {
	spawn_groups = { 101038, 101204 },
	trigger_times = 1,
	enabled = true,
}
local optsPreferedAdd4 = {
	spawn_groups = { 101859, 101864 },
	trigger_times = 1,
	enabled = true,
}
local optsRandomPreferedAdd = {
	amount = is_pro_job and 2 or 1,
	on_executed = {
		{ id = 400001, delay = 0, delay_rand = 30 },
		{ id = 400002, delay = 0, delay_rand = 30 },
		{ id = 400003, delay = 0, delay_rand = 30 },
	},
}
local optsAssaultStart = {
	enabled = true,
	global_event = "start_assault",
	on_executed = {
		{ id = 400004, delay = 0 },
	},
}
M.elements = {
	Eclipse.mission_elements.gen_preferedadd(400000, "chill_group_add01", optsPreferedAdd1),
	Eclipse.mission_elements.gen_preferedadd(400001, "chill_group_add02", optsPreferedAdd2),
	Eclipse.mission_elements.gen_preferedadd(400002, "chill_group_add03", optsPreferedAdd3),
	Eclipse.mission_elements.gen_preferedadd(400003, "chill_group_add04", optsPreferedAdd4),
	Eclipse.mission_elements.gen_element_random(400004, "chill_random_group_add", optsRandomPreferedAdd),
	Eclipse.mission_elements.gen_global_event(400005, "chill_assault_start", Vector3(0, 0, 0), Rotation(0, 0, 0), optsAssaultStart),
	-- Change bag requirments to defend
	Eclipse.mission_elements.gen_instance_params(400006, "chill_bag_requirment", Vector3(0, 0, 0), Rotation(0, 0, 0), optsinstance_bag_requirment),
}
return M
