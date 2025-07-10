---@module Hoxton Breakout Day 1
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local swat_1 = diff_i < 5 and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = diff_i < 5 and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local cop_1 = scripted_enemy.cop_1
local cop_2 = scripted_enemy.cop_2
local cop_3 = scripted_enemy.cop_3
local sniper = scripted_enemy.sniper
local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local cops = {
	[cop_1] = 4,
	[cop_3] = 2,
	[cop_2] = 1,
}
local swats = {
	[swat_1] = 6,
	[swat_2] = 2,
	[sniper] = 2,
}
local swat_or_dozer = {
	swat_1,
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local server_dozer = is_eclipse_pro and random_elite_dozers or random_dozers
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("normal_above")
local patches = {
	elevator_group = table.set(100013),
	bulldozer_server_room = {
		dozers = table.set(100061, 100062),
		filters_disable = table.set(100063, 100065),
		filters_normal_above = table.set(100064),
	},
	road_blockade = {
		cops = table.set(100093, 100094),
		swats = table.set(100102, 100103),
		swat_or_dozer = table.set(100101),
		so_group_fix = table.set(100096, 100097, 100099, 100100),
	},
}

M["levels/instances/unique/hox_breakout_elevator001/world/world"] = function(result)
	for _, element in ipairs(result.default.elements) do
		if patches.elevator_group[element.id] then
			element.values.interval = 45
		end
	end
end
M["levels/instances/unique/hox_breakout_road001/world/world"] = function(result)
	local roadblock = patches.road_blockade

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if roadblock.cops[id] then
			element.values.enemy_table = diff_i < 5 and cops or swats
		elseif roadblock.swats[id] then
			element.values.enemy_table = swats
		elseif roadblock.swat_or_dozer[id] then
			element.values.enemy_table = diff_i < 6 and swats or swat_or_dozer
		elseif roadblock.so_group_fix[id] then
			element.values.ai_group = "enemies"
		end
	end
end
M["levels/instances/unique/hox_breakout_serverroom001/world/world"] = function(result)
	local dozer_event = patches.bulldozer_server_room

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if dozer_event.dozers[id] then
			element.values.enemy_table = server_dozer
		elseif dozer_event.filters_normal_above[id] then
			table.map_append(element.values, filter_normal_above)
		elseif dozer_event.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		end
	end
end

return M
