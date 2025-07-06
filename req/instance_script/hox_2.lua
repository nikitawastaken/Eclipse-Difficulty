---@module The Search
local M = {}
local preferred = Eclipse.preferred
local patches = {
	breach_group = table.set(100012),
}

return {
	["levels/instances/unique/hox_fbi_ceiling_breach/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.breach_group[element.id] then
				element.values.interval = 30
				element.values.groups = preferred.no_cops_agents
			end
		end
	end,
}
