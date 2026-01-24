---@module Alesso Heist
local M = {}

local normal, hard, eclipse = Eclipse.utils.diff_groups()
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
local optsPreferedAdd01 = { -- Default preferreds, always active
	spawn_groups = { 100133, 100694 },
	enabled = true,
}
local optsPreferedRemove01 = {
	elements = { 400002 },
	enabled = true,
}
local optsPreferedAdd02 = { -- Lobby preferreds, localized
	spawn_groups = { 100132, 104471 },
	enabled = true,
}
local optsPreferedRemove02 = {
	elements = { 400004 },
	enabled = true,
}
local optsPreferedAdd03 = { -- Lobby preferreds, localized
	spawn_groups = { 101310, 102066 },
	enabled = true,
}
local optsPreferedRemove03 = {
	elements = { 400006 },
	enabled = true,
}
local optsPreferedAdd04 = { -- Upper floor preferreds, localized
	spawn_groups = { 101166 },
	enabled = true,
}
local optsPreferedRemove04 = {
	elements = { 400008 },
	enabled = true,
}
local optsPreferedAdd05 = { -- Pyro booth preferreds, localized
	spawn_groups = { 100805, 101555 },
	enabled = true,
}
local optsPreferedRemove05 = {
	elements = { 400010 },
	enabled = true,
}
local optsPreferedAdd06 = { -- 2nd+ assault preferreds, localized
	spawn_groups = { 100128, 101309 },
	enabled = true,
}
local optsPreferedRemove06 = {
	elements = { 400012 },
	enabled = true,
}
local optsAreaReportTrigger01 = { -- Localized lobby preferreds trigger
	enabled = false,
	width = 3600,
	depth = 4200,
	height = 1000,
	on_executed = {
		{ id = 400004, alternative = "enter", delay = 0 },
		{ id = 400005, alternative = "empty", delay = 0 },
		{ id = 101501, alternative = "enter", delay = 0 },
		{ id = 101502, alternative = "empty", delay = 0 },
	},
}
local optsAreaReportTrigger02 = { -- localized garage preferreds trigger
	enabled = false,
	width = 3200,
	depth = 3200,
	height = 600,
	on_executed = {
		{ id = 400006, alternative = "enter", delay = 0 },
		{ id = 400007, alternative = "empty", delay = 0 },
		{ id = 101661, alternative = "enter", delay = 0 },
		{ id = 101663, alternative = "empty", delay = 0 },
		{ id = 101664, alternative = "enter", delay = 0 },
		{ id = 101666, alternative = "empty", delay = 0 },
	},
}
local optsAreaReportTrigger03 = { -- localized upper floor preferreds trigger
	enabled = false,
	width = 6000,
	depth = 6000,
	height = 600,
	on_executed = {
		{ id = 400008, alternative = "enter", delay = 0 },
		{ id = 400009, alternative = "empty", delay = 0 },
		{ id = 100238, alternative = "enter", delay = 0 },
		{ id = 100326, alternative = "empty", delay = 0 },
	},
}
local optsAreaReportTrigger04 = { -- Localized Pyro booth preferred trigger
	enabled = false,
	width = 2000,
	depth = 4000,
	height = 600,
	on_executed = {
		{ id = 400010, alternative = "enter", delay = 0 },
		{ id = 400011, alternative = "empty", delay = 0 },
		{ id = 101674, alternative = "enter", delay = 0 },
		{ id = 101678, alternative = "empty", delay = 0 },
	},
}
local optsToggleAreaReportTriggers = {
	toggle = "on",
	enabled = true,
	elements = {
		400014,
		400015,
		400016,
		400017,
	},
}

M.elements = {
	-- change bag requirments
	Eclipse.mission_elements.gen_instance_params(400001, "new_bag_requirment", Vector3(0, 0, 0), Rotation(0, 0, 0), optsinstance_bag_requirment),
	-- Add new preferreds and area report triggers
	Eclipse.mission_elements.gen_preferedadd(400002, "arena_preferredadd01", optsPreferedAdd01), -- Default lobby preferreds
	Eclipse.mission_elements.gen_preferedremove(400003, "arena_preferredremove01", optsPreferedRemove01),
	Eclipse.mission_elements.gen_preferedadd(400004, "arena_preferredadd02", optsPreferedAdd02), -- Localized lobby preferreds
	Eclipse.mission_elements.gen_preferedremove(400005, "arena_preferredremove02", optsPreferedRemove02),
	Eclipse.mission_elements.gen_preferedadd(400006, "arena_preferredadd03", optsPreferedAdd03), -- localized garage preferreds
	Eclipse.mission_elements.gen_preferedremove(400007, "arena_preferredremove03", optsPreferedRemove03),
	Eclipse.mission_elements.gen_preferedadd(400008, "arena_preferredadd04", optsPreferedAdd04), -- localized upper floor preferreds
	Eclipse.mission_elements.gen_preferedremove(400009, "arena_preferredremove04", optsPreferedRemove04),
	Eclipse.mission_elements.gen_preferedadd(400010, "arena_preferredadd05", optsPreferedAdd05), -- Localized Pyro booth preferred
	Eclipse.mission_elements.gen_preferedremove(400011, "arena_preferredremove05", optsPreferedRemove05),
	Eclipse.mission_elements.gen_preferedadd(400012, "arena_preferredadd06", optsPreferedAdd06), -- 2nd+ assault preferreds
	Eclipse.mission_elements.gen_preferedremove(400013, "arena_preferredremove06", optsPreferedRemove06),
	Eclipse.mission_elements.gen_areareporttrigger(400014, "area_report_trigger_preferred01", Vector3(-320, 1385, 85), Rotation(0, 0, 0), optsAreaReportTrigger01),
	Eclipse.mission_elements.gen_areareporttrigger(400015, "area_report_trigger_preferred02", Vector3(-2485, -2750, -700), Rotation(0, 0, 0), optsAreaReportTrigger02),
	Eclipse.mission_elements.gen_areareporttrigger(400016, "area_report_trigger_preferred03", Vector3(-2050, 3000, 900), Rotation(0, 0, 0), optsAreaReportTrigger03),
	Eclipse.mission_elements.gen_areareporttrigger(400017, "area_report_trigger_preferred04", Vector3(-200, 3750, 900), Rotation(0, 0, 0), optsAreaReportTrigger04),
	Eclipse.mission_elements.gen_toggleelement(400018, "arena_toggle_area_report_triggers", optsToggleAreaReportTriggers),
}

return M
