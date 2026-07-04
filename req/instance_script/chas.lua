---@module Dragon Heist
local M = {}
local so_access = Eclipse.access_filter
local swat_only = so_access.swat
local patches = {
	vault = {
		electric_fix = table.set(100166),
	},
	tear_gas_vent = {
		gas_so = table.set(100012, 100013),
	},
}

M["levels/instances/unique/chas/chas_vault_gate_blowtorch/world/world"] = function(result)
	local chas_vault = patches.vault

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if chas_vault.electric_fix[id] then
			element.values.trigger_times = 0
		end
	end
end
M["levels/instances/unique/chas/chas_gas_outside_vent/world/world"] = function(result)
	local chas_gas_vent = patches.tear_gas_vent

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if chas_gas_vent.gas_so[id] then
			element.values.SO_access = swat_only -- only let SWATs plant the tear gas
			element.values.align_position = true -- fix position fucking up if they are focusing on the player for split second
			element.values.align_rotation = true
			element.values.needs_pos_rsrv = true
		end
	end
end

return M
