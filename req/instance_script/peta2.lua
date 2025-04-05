---@module Goat Simulator Day 2
local M = {}
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local scripted_enemy = Eclipse.scripted_enemy
local light_soldier = scripted_enemy.soldier_2
local heavy_soldier = scripted_enemy.soldier_3
local green_bulldozer = scripted_enemy.bulldozer_1
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
local filter_disable = Eclipse.utils.set_diff_groups("disable"),
local filter_normal_above = Eclipse.utils.set_diff_groups("normal_above"),

local soldiers = { [light_soldier] = 3, [heavy_soldier] = 1 }
local specials_list_eclipse = { [taser] = 2, [medic] = 2, [cloaker] = 2, [elite_ben_bulldozer] = 1 }
local specials_list_hard_ovk = { [taser] = 4, [medic] = 3, [cloaker] = 2, [green_bulldozer] = 1 }
local specials_list_easy_normal = { [taser] = 3, [cloaker] = 1 }
local specials =  normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse


local patches = {
	--pet_roadswats
	roadswats_soldiers = {
		light_spawn = table.set(100016, 100017),
		heavy_spawn = table.set(100018),
	},
	--pet_helicopter_swat
	swat_chopper = {
		regular_spawns = table.set(100013, 100014, 100015, 100017),
		special_spawn = table.set(100018),
		filters_disable = table.set(100008, 100010),
		filters_normal_above = table.set(100007),
	},
}

M["levels/instances/unique/pet_roadswats/world/world"] = function(result)
	local soldiers = patches.roadswats_soldiers

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if soldiers.light_spawn[id] then
			element.values.enemy = light_soldier
		elseif soldiers.heavy_spawn[id] then
			element.values.enemy = heavy_soldier
		end
	end
end

M["levels/instances/unique/pet_helicopter_swat/world/world"] = function(result)
	local heli_spawns = patches.swat_chopper

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if heli_spawns.regular_spawns[id] then
			element.values.enemy_table = soldiers
		elseif heli_spawns.special_spawn[id] then
			element.values.enemy_table = specials
		elseif heli_spawns.filters_normal_above[id] then
			table.map_append(element.values, filters_normal_above)
		elseif heli_spawns.filters_disable[id] then
			table.map_append(element.values, filters_disable)
		end
	end
end

return M
