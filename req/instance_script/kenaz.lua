---@module Golden Grin Casino
local M = {}
local preferred = Eclipse.preferred
local patches = {
	elevator = table.set(100013),
}

return {
	["levels/instances/unique/kenaz/elevator_openable/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.elevator[element.id] then
				element.values.interval = 20
				element.values.interval_balance_mul = { 1.7, 1.4, 1.1, 0.8 }
			end
		end
	end,
}
