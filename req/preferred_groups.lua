---@module Preferred Groups
local M = {}

local default_preferred = {
	cs_defend_init = true,
	cs_defend_light = true,
	cs_defend_heavy = true,
	cs_stealth_init = true,
	cs_stealth_light = true,
	cs_stealth_heavy = true,
	cs_cops = true,
	cs_swats = true,
	cs_heavies = true,
	cs_shield = true,
	cs_taser = true,
	cs_bulldozer = true,
	fbi_defend_init = true,
	fbi_defend_light = true,
	fbi_defend_heavy = true,
	fbi_stealth_init = true,
	fbi_stealth_light = true,
	fbi_stealth_heavy = true,
	fbi_swats = true,
	fbi_heavies = true,
	fbi_shield = true,
	fbi_taser = true,
	fbi_cloaker = true,
	fbi_bulldozer = true,
	elite_defend_light = true,
	elite_defend_heavy = true,
	elite_swats = true,
	elite_heavies = true,
	elite_sniper = true,
	elite_shield = true,
	elite_taser = true,
	elite_bulldozer = true,
	elite_bulldozer_shield = true,
}

local group_type_mapping = {
	cs_defend_init = "cop_group",
	cs_defend_light = "swat_group",
	cs_defend_heavy = "swat_group",
	cs_stealth_init = "cop_group",
	cs_stealth_light = "hrt_group",
	cs_stealth_heavy = "swat_group",
	cs_cops = "cop_group",
	cs_swats = "swat_group",
	cs_heavies = "swat_group",
	cs_shield = "shield_group",
	cs_taser = "taser_group",
	cs_bulldozer = "bulldozer_group",
	fbi_defend_init = "agent_group",
	fbi_defend_light = "swat_group",
	fbi_defend_heavy = "swat_group",
	fbi_stealth_init = "agent_group",
	fbi_stealth_light = "hrt_group",
	fbi_stealth_heavy = "swat_group",
	fbi_swats = "swat_group",
	fbi_heavies = "swat_group",
	fbi_shield = "shield_group",
	fbi_taser = "taser_group",
	fbi_cloaker = "cloaker_group",
	fbi_bulldozer = "bulldozer_group",
	elite_defend_light = "swat_group",
	elite_defend_heavy = "swat_group",
	elite_swats = "swat_group",
	elite_heavies = "swat_group",
	elite_sniper = "sniper_group",
	elite_shield = "shield_group",
	elite_taser = "taser_group",
	elite_bulldozer = "bulldozer_group",
	elite_bulldozer_shield = "shield_group",
}

local function create_preferred(excluded_types)
	local new_preferred = clone(default_preferred)
	for group, group_type in pairs(group_type_mapping) do
		for _, excluded_type in pairs(excluded_types) do
			if group_type == excluded_type then
				new_preferred[group] = false
			end
		end
	end

	return new_preferred
end

M.all_groups = clone(default_preferred)
M.no_cops = create_preferred({ "cop_group" })
M.no_agents = create_preferred({ "agent_group" })
M.no_cops_agents = create_preferred({ "cop_group", "agent_group" })
M.no_shields = create_preferred({ "shield_group" })
M.no_bulldozers = create_preferred({ "bulldozer_group" })
M.no_cloakers = create_preferred({ "cloaker_group" })
M.no_snipers = create_preferred({ "sniper_group" })
M.no_shields_bulldozers = create_preferred({ "shield_group", "bulldozer_group" })
M.no_cops_agents_shields = create_preferred({ "cop_group", "agent_group", "shield_group" })
M.no_cops_agents_bulldozers = create_preferred({ "cop_group", "agent_group", "bulldozer_group" })
M.no_cops_agents_shields_bulldozers = create_preferred({ "cop_group", "agent_group", "shield_group", "bulldozer_group" })
M.no_cops_agents_hrt_cloakers_snipers = create_preferred({ "cop_group", "agent_group", "hrt_group", "cloaker_group", "sniper_group" })
M.only_cloakers = create_preferred({ "cop_group", "swat_group", "heavy_group", "agent_group", "shield_group", "bulldozer_group", "taser_group", "sniper_group" })

return M
