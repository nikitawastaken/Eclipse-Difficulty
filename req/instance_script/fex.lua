---@module Buluc's Mansion
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local heavy_swat_sg = scripted_enemy.heavy_swat_2
local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local bulldozers = is_eclipse_pro and random_elite_dozers or random_dozers

local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_easy_above = Eclipse.utils.set_diff_groups("easy_above")
local patches = {
	mexican_heli = {
		dozer_spawns = table.set(100018, 100019),
		swat_spawns = table.set(100027, 100031),
		filters_easy_above = table.set(100014),
		filters_disable = table.set(100015, 100016, 100017),
	},
}

M["levels/instances/unique/fex/fex_helicopter_backup/world/world"] = function(result)
	local dozer_heli = patches.mexican_heli

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if dozer_heli.filters_easy_above[id] then
			table.map_append(element.values, filter_easy_above)
		elseif dozer_heli.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		elseif dozer_heli.dozer_spawns[id] then
			element.values.enemy_table = bulldozers
		end
	end
end

return M
