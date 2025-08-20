---@module Aftershock
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local so_access = Eclipse.access_filter_presets
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
local us_soldier_3 = scripted_enemy.soldier_4
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
local specials_list_eclipse = { [taser] = 2, [medic] = 2, [cloaker] = 2, [elite_ben_bulldozer] = 1, [elite_skull_bulldozer] = 1 }
local specials_list_hard_ovk = { [taser] = 4, [medic] = 3, [cloaker] = 2, [green_bulldozer] = 1, [black_bulldozer] = 1 }
local specials_list_easy_normal = { [taser] = 3, [cloaker] = 1 }
local us_soldiers = { [us_soldier_1] = 4, [us_soldier_2] = 2, [us_soldier_3] = 1 }
local specials = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse
local law = so_access.law
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("easy_above")
local patches = {
	heli = {
		soldiers = table.set(100003, 100004, 100000),
		specials = table.set(100002),
		hunt_so = table.set(100011),
		filters_disable = table.set(100042, 100075, 100033),
		filters_normal_above = table.set(100041),
	},
}

return {
	["levels/instances/unique/hox_estate_heli_spawn/world/world"] = function(result)
		local heli_army = patches.heli

		for _, element in pairs(result.default.elements) do
			local id = element.id

			if heli_army.soldiers[id] then
				element.values.enemy_table = us_soldiers
			elseif heli_army.specials[id] then
				element.values.enemy_table = specials	
			elseif heli_army.hunt_so[id] then
				element.values.SO_access = law
			elseif heli_army.filters_normal_above[id] then
				table.map_append(element.values, filter_normal_above)
			elseif heli_army.filters_disable[id] then
				table.map_append(element.values, filter_disable)
			end
		end
	end,
}
