---@module Dragon Heist
local M = {}
local patches = {
	vault = {
		electric_fix = table.set(100166),
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

return M
