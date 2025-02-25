---@module Panic Room
local M = {}

local patches = {
	harasser = {
		assault_filters = table.set(100010, 100029),
		disabled_forced_behaviour = table.set(100000, 100002),
	},
}

M["levels/instances/shared/harasser/world/world"] = function(result)
	local harasser = patches.harasser

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if harasser.assault_filters[id] then -- Allow spawns between assaults
			element.values.mode_control = true
		elseif harasser.disabled_forced_behaviour[id] then -- No flee on assault end, no forced spawn on assault start
			element.values.enabled = false
		end
	end
end

return M
