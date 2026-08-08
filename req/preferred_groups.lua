---@module Preferred Groups
local M = {}

local group_type_mapping = {
	cs_reenforce_init = "cop_group",
	cs_reenforce_light = "swat_group",
	cs_reenforce_heavy = "swat_group",
	cs_recon_init = "cop_group",
	cs_recon_light = "hrt_group",
	cs_recon_heavy = "swat_group",
	cs_assault_init = "cop_group",
	cs_assault_light = "swat_group",
	cs_assault_heavy = "swat_group",
	cs_assault_shield = "shield_group",
	cs_assault_taser = "taser_group",
	cs_assault_tank = "bulldozer_group",
	fbi_reenforce_init = "agent_group",
	fbi_reenforce_light = "swat_group",
	fbi_reenforce_heavy = "swat_group",
	fbi_recon_init = "agent_group",
	fbi_recon_light = "hrt_group",
	fbi_recon_heavy = "swat_group",
	fbi_assault_light = "swat_group",
	fbi_assault_heavy = "swat_group",
	fbi_assault_shield = "shield_group",
	fbi_assault_taser = "taser_group",
	fbi_assault_spooc = "cloaker_group",
	fbi_assault_tank = "bulldozer_group",
	elite_reenforce_light = "swat_group",
	elite_reenforce_heavy = "swat_group",
	elite_assault_light = "swat_group",
	elite_assault_heavy = "swat_group",
	elite_assault_marksman = "sniper_group",
	elite_assault_shield = "shield_group",
	elite_assault_taser = "taser_group",
	elite_assault_tank = "bulldozer_group",
	single_spooc = "cloaker_group_single",
}

-- If include, types are the group types to include (unspecified group types are set to false)
-- If not include, types are the group types to exclude (unspecified group types are set to true)
local function create_preferred(types, include)
	local new_preferred = {}
	for group, typ in pairs(group_type_mapping) do
		if table.contains(types, typ) then
			new_preferred[group] = include == true
		else
			new_preferred[group] = include ~= true
		end
	end
	return new_preferred
end

-- "cloaker_group_single" is excluded from regular spawns
M.all_groups = create_preferred({})
M.no_cops = create_preferred({ "cop_group", "cloaker_group_single" })
M.no_agents = create_preferred({ "agent_group", "cloaker_group_single" })
M.no_cops_agents = create_preferred({ "cop_group", "agent_group", "cloaker_group_single" })
M.no_shields = create_preferred({ "shield_group", "cloaker_group_single" })
M.no_bulldozers = create_preferred({ "bulldozer_group", "cloaker_group_single" })
M.no_cloakers = create_preferred({ "cloaker_group", "cloaker_group_single" })
M.no_snipers = create_preferred({ "sniper_group", "cloaker_group_single" })
M.no_shields_bulldozers = create_preferred({ "shield_group", "bulldozer_group", "cloaker_group_single" })
M.no_cops_agents_shields = create_preferred({ "cop_group", "agent_group", "shield_group", "cloaker_group_single" })
M.no_cops_agents_bulldozers = create_preferred({ "cop_group", "agent_group", "bulldozer_group", "cloaker_group_single" })
M.no_cops_agents_shields_bulldozers = create_preferred({ "cop_group", "agent_group", "shield_group", "bulldozer_group", "cloaker_group_single" })
M.no_cops_agents_hrt_cloakers_snipers = create_preferred({ "cop_group", "agent_group", "hrt_group", "cloaker_group", "cloaker_group_single", "sniper_group" })
M.only_cloakers = create_preferred({ "cloaker_group" }, true)
M.only_cloakers_single = create_preferred({ "cloaker_group_single" }, true)

function M.get_as_list(preferred)
	if type(preferred) ~= "table" then
		Eclipse:warn_console("Invalid preferred argument in Eclipse.preferred.get_as_list()!")
		return {}
	end

	local preferred_list = {}
	for group, enabled in pairs(preferred) do
		if enabled then
			table.insert(preferred_list, group)
		end
	end
	return preferred_list
end

return M
