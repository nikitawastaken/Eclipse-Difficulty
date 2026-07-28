---@module Lost In Transit
local M = {}
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_easy_above = Eclipse.utils.set_diff_groups("easy_above")

local patches = {
	printing_plates = {
		filters_disable = table.set(100098),
		filters_easy_above = table.set(100107),
	},
}

M["levels/instances/unique/trai/trai_main_wagon/world/world"] = function(result)
	local train_wagon = patches.printing_plates

	for _, element in pairs(result.default.elements) do
		local id = element.id
		
		-- Force spawning 3 priting plates regardless of difficulty
		if train_wagon.filters_easy_above[id] then
			table.map_append(element.values, filter_easy_above)
		elseif train_wagon.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		end
	end
end
