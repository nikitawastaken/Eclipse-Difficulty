---@module Alaskan Deal
local M = {}
local patches = {
	tanker_and_pump_interruption_delay = table.set(100017),
}

M["levels/instances/unique/wwh/wwh_tanker/world/world"] = function(result)
	for _, element in ipairs(result.default.elements) do
		if patches.tanker_and_pump_interruption_delay[element.id] then
			element.values.on_executed = {
				{ id = 100018, delay = 10 }, -- delay the interrupt of the tanker to 10 seconds (from 0 seconds in vanilla)
			}
		end
	end
end
M["levels/instances/unique/wwh/wwh_pump/world/world"] = function(result)
	for _, element in ipairs(result.default.elements) do
		if patches.tanker_and_pump_interruption_delay[element.id] then
			element.values.on_executed = {
				{ id = 100018, delay = 10 }, -- delay the interrupt of the pump to 10 seconds (from 0 seconds in vanilla)
			}
		end
	end
end

return M
