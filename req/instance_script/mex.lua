---@module Border Crossing
local M = {}
local patches = {
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

return M
