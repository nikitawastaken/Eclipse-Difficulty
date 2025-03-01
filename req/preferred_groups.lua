---@module Preferred Groups
local M = {}

local default_preferred = {
	CS_assault_cops = true,
	CS_assault_swats = true,
	CS_assault_heavies = true,
	CS_recon_cops = true,
	CS_recon_swat = true,
	CS_reinforce_cops = true,
	CS_reinforce_swats = true,
	FBI_assault_swats = true,
	FBI_assault_heavies = true,
	FBI_recon_agents = true,
	FBI_recon_swats = true,
	FBI_reinforce_agents = true,
	FBI_reinforce_swats = true,
	Elite_assault_swats = true,
	Elite_reinforce_swats = true,
	Zeal_assault_swats = true,
	Zeal_assault_heavies = true,
	Zeal_reinforce_swats = true,
	CS_assault_shield = true,
	FBI_assault_shield = true,
	Elite_assault_shield = true,
	Zeal_assault_shield = true,
	CS_assault_taser = true,
	FBI_assault_taser = true,
	Elite_assault_taser = true,
	Zeal_assault_taser = true,
	FBI_assault_cloaker = true,
	Zeal_assault_cloaker = true,
	CS_assault_bulldozer = true,
	FBI_assault_bulldozer = true,
	Elite_assault_bulldozer = true,
	Elite_assault_sniper = true,
}

local group_type_mapping = {
	CS_assault_cops = "cop_group",
	CS_assault_swats = "swat_group",
	CS_assault_heavies = "heavy_group",
	CS_recon_cops = "cop_group",
	CS_recon_swat = "swat_group",
	CS_reinforce_cops = "cop_group",
	CS_reinforce_swats = "swat_group",
	FBI_assault_swats = "swat_group",
	FBI_assault_heavies = "heavy_group",
	FBI_recon_agents = "agent_group",
	FBI_recon_swats = "swat_group",
	FBI_reinforce_agents = "agent_group",
	FBI_reinforce_swats = "swat_group",
	Elite_assault_swats = "swat_group",
	Elite_reinforce_swats = "swat_group",
	Zeal_assault_swats = "swat_group",
	Zeal_assault_heavies = "heavy_group",
	Zeal_reinforce_swats = "swat_group",
	CS_assault_shield = "shield_group",
	FBI_assault_shield = "shield_group",
	Elite_assault_shield = "shield_group",
	Zeal_assault_shield = "shield_group",
	CS_assault_taser = "taser_group",
	FBI_assault_taser = "taser_group",
	Elite_assault_taser = "taser_group",
	Zeal_assault_taser = "taser_group",
	FBI_assault_cloaker = "cloaker_group",
	Zeal_assault_cloaker = "cloaker_group",
	single_spooc = "cloaker_group",
	CS_assault_bulldozer = "bulldozer_group",
	FBI_assault_bulldozer = "bulldozer_group",
	Elite_assault_bulldozer = "bulldozer_group",
	Elite_assault_sniper = "sniper_group",
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
M.no_shields_bulldozers = create_preferred({ "shield_group", "bulldozer_group" })
M.no_cops_agents_shields = create_preferred({ "cop_group", "agent_group", "shield_group" })
M.no_cops_agents_shields_bulldozers = create_preferred({ "cop_group", "agent_group", "shield_group", "bulldozer_group" })
M.no_cops_agents_bulldozers = create_preferred({ "cop_group", "agent_group", "bulldozer_group" })

return M
