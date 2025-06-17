---@module Golden Grin Casino
local M = {}
local patches = {
	elevator = table.set(100013),
}

return {
	["levels/instances/unique/kenaz/elevator_openable/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.elevator[element.id] then
				element.values.interval = 10
			end
		end
	end,
}
