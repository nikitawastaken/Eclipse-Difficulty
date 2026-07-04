---@module Border Crossing
local M = {}
local patches = {
	tanker_and_pump_interruption_delay = table.set(100017),
	vault = {
		prevent_disabling_the_vault_timer = table.set(100008),
	},
}

M["levels/instances/unique/mex/mex_vault/world/world"] = function(result)
	local mex_vault = patches.vault

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if mex_vault.prevent_disabling_the_vault_timer[id] then
			element.values.enabled = false
		end
	end
end
M["levels/instances/unique/mex/mex_tanker/world/world"] = function(result)
	for _, element in ipairs(result.default.elements) do
		if patches.tanker_and_pump_interruption_delay[element.id] then
			element.values.on_executed = {
				{ id = 100018, delay = 20 }, -- delay the interrupt of the tanker to 20 seconds (from 5 seconds in vanilla)
				{ id = 100038, delay = 1 }, -- defend icon waypoint
			}
		end
	end
end
M["levels/instances/unique/mex/mex_pump/world/world"] = function(result)
	for _, element in ipairs(result.default.elements) do
		if patches.tanker_and_pump_interruption_delay[element.id] then
			element.values.on_executed = {
				{ id = 100018, delay = 20 }, -- delay the interrupt of the pump to 20 seconds (from 5 seconds in vanilla
				{ id = 100038, delay = 1 }, -- defend icon waypoint
			}
		end
	end
end

return M
