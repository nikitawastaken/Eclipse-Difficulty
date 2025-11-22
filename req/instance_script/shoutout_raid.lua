---@module Meltdown
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local elite_sniper = scripted_enemy.elite_sniper
local light_harasser = { swat_1 }
local heavy_harasser = diff_i > 5 and { [heavy_1] = 5, [elite_sniper] = 1 } or { heavy_1 }

local patches = {
	harassers = table.set(100016, 100017, 100018),
}

M["levels/instances/unique/shout_harasser/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		local id = element.id

		if patches.harassers[id] then
			element.values.enemy_table = diff_i >= 5 and heavy_harasser or light_harasser
		end
	end
end

return M
