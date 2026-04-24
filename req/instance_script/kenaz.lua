---@module Golden Grin Casino
local M = {}
local so_access = Eclipse.access_filter
local acrobatic = so_access.acrobatic
local preferred = Eclipse.preferred
local patches = {
	elevator = table.set(100013),
	so_access_tweak_drill = table.set(100302),
	so_access_tweak_powerbox = table.set(100015),
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
	["levels/instances/unique/kenaz/the_drill/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.so_access_tweak_drill[element.id] then
				element.values.SO_access = acrobatic -- only let SWATs, tasers and cloakers disable the drill
			end
		end
	end,
	["levels/instances/unique/kenaz/drill_powerbox/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.so_access_tweak_powerbox[element.id] then
				element.values.SO_access = acrobatic -- only let SWATs, tasers and cloakers disable the power
			end
		end
	end,
}
