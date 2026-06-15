---@module Slaughterhouse
local M = {}

local normal, hard, eclipse = Eclipse.utils.diff_groups()
local scripted_enemy = Eclipse.scripted_enemy
local chance_fewest_pigs = normal and 0 or hard and 0.01 or 0.02
local fewest_pigs = math.random() < chance_fewest_pigs

local random_dozers = {
	scripted_enemy.bulldozer_1,
	scripted_enemy.bulldozer_2,
}
local random_elite_dozers = {
	scripted_enemy.elite_bulldozer_1,
	scripted_enemy.elite_bulldozer_2,
}

local container_dozer = is_eclipse_pro and random_elite_dozers or random_dozers

local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_hard_above = Eclipse.utils.set_diff_groups("hard_above")

local patches = {
	bulldozer_container_spawn = {
		dozers = table.set(100007, 100009, 100008, 100010),
		filters_disable = table.set(100002, 100003),
		filters_hard_above = table.set(100004),
		spawn_event_fix = table.set(100021),
	},
}

M["levels/instances/unique/dinner/quad_meat/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if element.id == 100002 then -- choose_random_variation
			if fewest_pigs then
				element.values.on_executed = {
					{ id = 100000, delay = 0 }, -- 1
				}
			elseif normal then
				-- nothing
			elseif hard then
				element.values.on_executed = {
					{ id = 100004, delay = 0 }, -- 3
					{ id = 100005, delay = 0 }, -- 2
					{ id = 100000, delay = 0 }, -- 1
				}
			else
				element.values.on_executed = {
					{ id = 100005, delay = 0 }, -- 2
					{ id = 100000, delay = 0 }, -- 1
				}
			end
		end
	end
end

M["levels/instances/unique/dinner/triple_meat/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if element.id == 100002 then -- choose_random_variation
			if overkill or fewest_pigs then
				element.values.on_executed = {
					{ id = 100004, delay = 0 }, -- 2
					{ id = 100005, delay = 0 }, -- 2
				}
			elseif hard then
				element.values.on_executed = {
					{ id = 100003, delay = 0 }, -- 3
					{ id = 100004, delay = 0 }, -- 2
					{ id = 100004, delay = 0 }, -- 2
					{ id = 100005, delay = 0 }, -- 2
					{ id = 100005, delay = 0 }, -- 2
					{ id = 100005, delay = 0 }, -- 2
				}
			else
				-- nothing
			end
		end
	end
end
M["levels/instances/unique/dinner/container_dozer_spawn/world/world"] = function(result)
	local dozer_event = patches.bulldozer_container_spawn

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if dozer_event.dozers[id] then
			element.values.enemy_table = container_dozer
		elseif dozer_event.spawn_event_fix[id] then
			element.values.event = "spawn"
		elseif dozer_event.filters_hard_above[id] then
			table.map_append(element.values, filter_hard_above)
		elseif dozer_event.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		end
	end
end

return M
