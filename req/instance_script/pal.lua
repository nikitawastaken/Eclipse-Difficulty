---@module Counterfeit
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local heavy_swat = scripted_enemy.heavy_swat_2
local cloaker = scripted_enemy.cloaker
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("normal_above")
local filter_eclipse_only = Eclipse.utils.set_diff_groups("eclipse")

local patches = {
	disable_power_delay = table.set(100016),
	sewer_spawn = {
		spooc = table.set(100010),
		swat_sg = table.set(100019),
		taser = table.set(100021),
		filters_disable = table.set(100011, 100012),
		filters_normal_above = table.set(100013),
		spawn_chance = table.set(100003),
		squad = table.set(100003),
	},
	pipe_spawn = {
		filters_disable = table.set(100014, 100015, 100011),
		filters_eclipse = table.set(100013),
		spawn_chance = table.set(100000),
	},
}

M["levels/instances/unique/sub_sewer_grate/world/world"] = function(result)
	local sewer_grate = patches.sewer_spawn

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if sewer_grate.spooc[id] then
			element.values.enemy = cloaker
			element.values.position = Vector3(-109, 20, 0)
		elseif sewer_grate.taser[id] then
			element.values.position = Vector3(-48, 17, 0)
		elseif sewer_grate.swat_sg[id] then
			element.values.enemy = heavy_swat
			element.values.position = Vector3(13, 16, 0)
		elseif sewer_grate.filters_normal_above[id] then
			table.map_append(element.values, filter_normal_above)
			element.values.on_executed = {
				{ id = 100010, delay = 0 },
				{ id = 100019, delay = 0 },
				{ id = 100021, delay = 0 },
			}
		elseif sewer_grate.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		elseif sewer_grate.spawn_chance[id] then
			element.values.chance = 45
		end
	end
end

M["levels/instances/unique/sub_sewer_sidespawn/world/world"] = function(result)
	local side_spawn = patches.pipe_spawn

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if side_spawn.filters_eclipse[id] then
			table.map_append(element.values, filter_eclipse_only)
		elseif side_spawn.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		elseif side_spawn.spawn_chance[id] then
			element.values.chance = 30
			element.values.on_executed = {
				{ id = 100020, delay = 0 },
			}
		end
	end
end
M["levels/instances/unique/sub_circut_breaker/world/world"] = function(result)
	for _, element in ipairs(result.default.elements) do
		if patches.disable_power_delay[element.id] then
			element.values.on_executed = {
				{ id = 100015, delay = 20, delay_rand = 10 },
			}
		end
	end
end

return M
