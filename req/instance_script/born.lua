---@module Lion's Den
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local swat_1 = scripted_enemy.swat_1
local swat_2 = scripted_enemy.swat_2
local heavy_swat_1 = scripted_enemy.heavy_swat_1
local heavy_swat_2 = scripted_enemy.heavy_swat_2
local cloaker = scripted_enemy.cloaker
local swats_normal_and_below = {
	swat_1,
	swat_2,
	heavy_swat_1,
	heavy_swat_2,
}
local swats_above_normal = {
	[swat_1] = 2,
	[swat_2] = 2,
	[heavy_swat_1] = 2,
	[heavy_swat_2] = 2,
	[cloaker] = 1,
}
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("easy_above")
local patches = {
	armory = {
		swats = table.set(100155, 100151, 100149, 100123, 100124, 100150),
		start_spawn_enemies = table.set(100119),
		reinforce = table.set(100107),
		filters_disable = table.set(100166, 100168, 100127, 100129),
		filters_normal_above = table.set(100165, 100126),
	},
}

return {
	["levels/instances/unique/born/born_armory/world/world"] = function(result)
		local skull_armory = patches.armory

		for _, element in pairs(result.default.elements) do
			local id = element.id

			if skull_armory.swats[id] then
				element.values.enemy_table = diff_i < 4 and swats_normal_and_below or swats_above_normal
			elseif skull_armory.start_spawn_enemies[id] then
				element.values.on_executed = {
					{ id = 100114, delay = 0 },
					{ id = 100164, delay = 5 },
					{ id = 100163, delay = 5, delay_rand = 5 },
				}
			elseif skull_armory.reinforce[id] then
				element.values.enabled = false
			elseif skull_armory.filters_normal_above[id] then
				table.map_append(element.values, filter_normal_above)
			elseif skull_armory.filters_disable[id] then
				table.map_append(element.values, filter_disable)
			end
		end
	end,
}
