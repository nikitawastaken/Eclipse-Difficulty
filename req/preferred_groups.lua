---@module Preferred Groups
local M = {}

local default_preferred = {
	cs_defend_init = true,
	cs_defend_light = true,
	cs_defend_heavy = true,
	cs_stealth_light = true,
	cs_stealth_heavy = true,
	cs_cops_init = true,
	cs_swats_ranged = true,
	cs_swats_charge = true,
	cs_heavies_ranged = true,
	cs_heavies_charge = true,
	cs_shield_ranged = true,
	cs_shield_charge = true,
	cs_taser_flank = true,
	cs_taser_charge = true,
	cs_bulldozer_charge = true,
	fbi_defend_init = true,
	fbi_defend_light = true,
	fbi_defend_heavy = true,
	fbi_stealth_light = true,
	fbi_stealth_heavy = true,
	fbi_swats_ranged = true,
	fbi_swats_charge = true,
	fbi_heavies_ranged = true,
	fbi_heavies_charge = true,
	fbi_shield_ranged = true,
	fbi_shield_charge = true,
	fbi_taser_flank = true,
	fbi_taser_charge = true,
	fbi_taser_takedown = true,
	fbi_cloaker_charge = true,
	fbi_cloaker_hide = true,
	fbi_bulldozer_charge = true,
	fbi_bulldozer_shield = true,
	elite_defend_light = true,
	elite_defend_heavy = true,
	elite_swats_ranged = true,
	elite_swats_charge = true,
	elite_heavies_ranged = true,
	elite_heavies_charge = true,
	elite_shield_ranged = true,
	elite_shield_charge = true,
	elite_taser_flank = true,
	elite_taser_charge = true,
	elite_bulldozer_takedown = true,
	elite_bulldozer_charge = true,
}

local group_type_mapping = {
	cs_defend_init = "cop_group",
	cs_defend_light = "swat_group",
	cs_defend_heavy = "swat_group",
	cs_stealth_light = "cop_group",
	cs_stealth_heavy = "swat_group",
	cs_cops_init = "cop_group",
	cs_swats_ranged = "swat_group",
	cs_swats_charge = "swat_group",
	cs_heavies_ranged = "swat_group",
	cs_heavies_charge = "swat_group",
	cs_shield_ranged = "shield_group",
	cs_shield_charge = "shield_group",
	cs_taser_flank = "taser_group",
	cs_taser_charge = "taser_group",
	cs_bulldozer_charge = "bulldozer_group",
	fbi_defend_init = "agent_group",
	fbi_defend_light = "swat_group",
	fbi_defend_heavy = "swat_group",
	fbi_stealth_light = "agent_group",
	fbi_stealth_heavy = "swat_group",
	fbi_swats_ranged = "swat_group",
	fbi_swats_charge = "swat_group",
	fbi_heavies_ranged = "swat_group",
	fbi_heavies_charge = "swat_group",
	fbi_shield_ranged = "shield_group",
	fbi_shield_charge = "shield_group",
	fbi_taser_flank = "taser_group",
	fbi_taser_charge = "taser_group",
	fbi_cloaker_charge = "cloaker_group",
	fbi_cloaker_hide = "cloaker_group",
	fbi_bulldozer_charge = "bulldozer_group",
	elite_defend_light = "swat_group",
	elite_defend_heavy = "swat_group",
	elite_swats_ranged = "swat_group",
	elite_swats_charge = "swat_group",
	elite_heavies_ranged = "swat_group",
	elite_heavies_charge = "swat_group",
	elite_shield_ranged = "shield_group",
	elite_shield_charge = "shield_group",
	elite_taser_takedown = "taser_group",
	elite_taser_flank = "taser_group",
	elite_taser_charge = "taser_group",
	elite_bulldozer_takedown = "bulldozer_group",
	elite_bulldozer_shield = "bulldozer_group",
	elite_bulldozer_charge = "bulldozer_group",
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
M.no_bulldozers_snipers = create_preferred({ "bulldozer_group", "sniper_group" })
M.no_cloakers_snipers = create_preferred({ "cloaker_group", "sniper_group" })
M.no_cops_agents_shields = create_preferred({ "cop_group", "agent_group", "shield_group" })
M.no_cops_agents_bulldozers = create_preferred({ "cop_group", "agent_group", "bulldozer_group" })
M.no_cops_agents_cloakers = create_preferred({ "cop_group", "agent_group", "cloaker_group" })
M.no_shields_bulldozers_snipers = create_preferred({ "shield_group", "bulldozer_group", "sniper_group" })
M.no_cops_agents_shields_bulldozers = create_preferred({ "cop_group", "agent_group", "shield_group", "bulldozer_group" })
M.no_cops_agents_cloakers_snipers = create_preferred({ "cop_group", "agent_group", "cloaker_group", "sniper_group" })
M.only_cloakers = create_preferred({ "cop_group", "swat_group", "heavy_group", "agent_group", "shield_group", "bulldozer_group", "taser_group", "sniper_group" })
M.only_swats_tasers_cloakers = create_preferred({ "cop_group", "agent_group", "shield_group", "bulldozer_group", "sniper_group" })
M.only_swats_tasers = create_preferred({ "cop_group", "agent_group", "shield_group", "bulldozer_group", "cloaker_group", "sniper_group" })

return M
