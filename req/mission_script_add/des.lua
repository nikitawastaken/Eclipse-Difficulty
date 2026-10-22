---@module Green Bridge
local M = {}

local optsFlankPreferredAdd01 = {
	spawn_groups = { 400001 },
	enabled = true,
}
local optsFlankPreferredRemove01 = {
	elements = { 400002 },
	enabled = true,
}
local optsFlankPreferredAdd02 = {
	spawn_groups = { 400004 },
	enabled = true,
}
local optsFlankPreferredRemove02 = {
	elements = { 400005 },
	enabled = true,
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

M.elements = {
	-- Add new spawngroups to diversify directions enemies approach from
	Eclipse.mission_elements.gen_spawngroup(400001, "des_hub_flank_spawn_group", { 102435, 102437, 102383, 102436, 102239 }, 0),
	Eclipse.mission_elements.gen_preferedadd(400002, "des_hub_flank_preferedadd", optsFlankPreferredAdd01),
	Eclipse.mission_elements.gen_preferedremove(400003, "des_hub_flank_preferedremove", optsFlankPreferredRemove01),

	Eclipse.mission_elements.gen_spawngroup(400004, "des_intro_flank_spawn_group", { 108277, 108278, 108279, 108280, 108281 }, 0),
	Eclipse.mission_elements.gen_preferedadd(400005, "des_intro_flank_preferedadd", optsFlankPreferredAdd02),
	Eclipse.mission_elements.gen_preferedremove(400006, "des_intro_flank_preferedremove", optsFlankPreferredRemove02),

	-- Scripted difficulty steps
	Eclipse.mission_elements.gen_difficulty(400007, "des_difficulty_addend01", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400008, "des_difficulty_addend02", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
	Eclipse.mission_elements.gen_difficulty(400009, "des_difficulty_addend03", Vector3(0, 0, 0), Rotation(0, 0, 0), optsDifficultyAddend01),
}

return M
