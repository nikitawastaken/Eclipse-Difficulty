---@module Crude Awakening
local M = {}
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local scripted_enemy = Eclipse.scripted_enemy
local bellmead_1 = scripted_enemy.bellmead_security_1
local bellmead_heavy_1 = scripted_enemy.bellmead_gunner_1
local bellmead_heavy_2 = scripted_enemy.bellmead_gunner_2
local green_bulldozer = scripted_enemy.bulldozer_1
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("easy_above")

local bellmead_mercs = { [bellmead_1] = 5, [bellmead_heavy_1] = 1, [bellmead_heavy_2] = 1 }
local specials_list_eclipse = { [taser] = 2, [medic] = 2, [cloaker] = 2, [elite_ben_bulldozer] = 1 }
local specials_list_hard_ovk = { [taser] = 4, [medic] = 3, [cloaker] = 2, [green_bulldozer] = 1 }
local specials_list_easy_normal = { [taser] = 3, [cloaker] = 1 }
local specials = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse

local patches = {
	swat_chopper = {
		regular_spawns = table.set(100010, 100011, 100012),
		special_spawn = table.set(100013),
		filters_disable = table.set(100041, 100027, 100028),
		filters_normal_above = table.set(100026),
	},
}

M["levels/instances/unique/deep/deep_helicopter_enemies/world/world"] = function(result)
	local heli_spawns = patches.swat_chopper

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if heli_spawns.regular_spawns[id] then
			element.values.enemy_table = bellmead_mercs
		elseif heli_spawns.special_spawn[id] then
			element.values.enemy_table = specials
		elseif heli_spawns.filters_normal_above[id] then
			table.map_append(element.values, filter_normal_above)
		elseif heli_spawns.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		end
	end
end

return M
