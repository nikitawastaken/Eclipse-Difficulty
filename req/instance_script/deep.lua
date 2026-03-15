---@module Crude Awakening
local M = {}
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local bellmead = scripted_enemy.bellmead_security_1
local green_bulldozer = scripted_enemy.bulldozer_1
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
local elite_sniper = scripted_enemy.elite_sniper
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("easy_above")

local specials_list_eclipse = { [taser] = 2, [medic] = 2, [cloaker] = 2, [elite_ben_bulldozer] = 1 }
local specials_list_hard_ovk = { [taser] = 4, [medic] = 3, [cloaker] = 2, [green_bulldozer] = 1 }
local specials_list_easy_normal = { [taser] = 3, [cloaker] = 1 }
local specials = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse
local light_harasser = { swat_1 }
local heavy_harasser = diff_i > 5 and { [heavy_1] = 5, [elite_sniper] = 1 } or { heavy_1 }

local patches = {
	swat_chopper = {
		regular_spawns = table.set(100010, 100012),
		special_spawn = table.set(100011, 100013),
		filters_disable = table.set(100041, 100027, 100028),
		filters_normal_above = table.set(100026),
	},
	harassers = table.set(100016, 100017, 100018),
}

M["levels/instances/unique/deep/deep_helicopter_enemies/world/world"] = function(result)
	local heli_spawns = patches.swat_chopper

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if heli_spawns.regular_spawns[id] then
			element.values.enemy = bellmead
		elseif heli_spawns.special_spawn[id] then
			element.values.enemy_table = specials
		elseif heli_spawns.filters_normal_above[id] then
			table.map_append(element.values, filter_normal_above)
		elseif heli_spawns.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		end
	end
end

M["levels/instances/shared/harasser/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		local id = element.id

		if patches.harassers[id] then
			element.values.enemy_table = diff_i >= 5 and heavy_harasser or light_harasser
		end
	end
end

return M
