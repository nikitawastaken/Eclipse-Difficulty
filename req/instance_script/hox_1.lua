---@module Hoxton Breakout Day 1
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = is_eclipse and is_pro_job
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local server_dozer = is_eclipse_pro and random_elite_dozers or diff_i > 3 and random_dozers or green_bulldozer
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("normal_above")
local patches = {
	elevator_group = table.set(100013),
	bulldozer_server_room = {
		dozers = table.set(100061, 100062),
		filters_disable = table.set(100063, 100065),
		filters_normal_above = table.set(100064),
	},
}

M["levels/instances/unique/hox_breakout_elevator001/world/world"] = function(result)
	for _, element in ipairs(result.default.elements) do
		if patches.elevator_group[element.id] then
			element.values.interval = 40
		end
	end
end
M["levels/instances/unique/hox_breakout_serverroom001/world/world"] = function(result)
	local dozer_event = patches.bulldozer_server_room

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if sewer_grate.dozers[id] then
			element.values.enemy = server_dozer
		elseif dozer_event.filters_normal_above[id] then
			table.map_append(element.values, filter_normal_above)}
		elseif dozer_event.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		end
	end
end

return M
