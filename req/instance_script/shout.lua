---@module Meltdown
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local diff_i = Eclipse.utils.difficulty_index()
local light_swat = diff_i < 5 and scripted_enemy.swat_1 or scripted_enemy.heavy_swat_1
local cloaker = scripted_enemy.cloaker
local taser = scripted_enemy.taser_1
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("easy_above")
local specials_spawns = { [taser] = 2, [cloaker] = 1 }
local greendozer_only = {
	green_bulldozer,
}
local random_dozers = {
	green_bulldozer,
	black_bulldozer,
}
local random_elite_dozers = {
	elite_ben_bulldozer,
	elite_skull_bulldozer,
}
local container_dozer = is_eclipse_pro and random_elite_dozers or diff_i < 4 and greendozer_only or random_dozers

local patches = {
	swat_chopper = {
		regular_spawns = table.set(100014, 100015),
		special_spawns = table.set(100013, 100016),
		filters_disable = table.set(100008, 100010),
		filters_normal_above = table.set(100007),
		hunt = table.set(100046),
	},
	dozer_tweak = {
		dozer_hunt = table.set(100009, 100021, 100022),
	},
}

M["levels/instances/unique/shout_helicopter_swat/world/world"] = function(result)
	local heli_spawns = patches.swat_chopper

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if heli_spawns.regular_spawns[id] then
			element.values.enemy = light_swat
		elseif heli_spawns.special_spawns[id] then
			element.values.enemy_table = specials_spawns
		elseif heli_spawns.filters_normal_above[id] then
			table.map_append(element.values, filter_normal_above)
		elseif heli_spawns.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		elseif heli_spawns.hunt[id] then
			element.values.enabled = true --why the fuck it's turned off?
			element.values.forced = false
		end
	end
end

M["levels/instances/unique/shout_container_normal/world/world"] = function(result)
	local dozer_hunt_tweak = patches.dozer_tweak

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if dozer_hunt_tweak.dozer_hunt[id] then
			element.values.enemy_table = container_dozer
			element.values.on_executed = {
				{ id = 100067, delay = 3 }, -- delay the hunt
			}
		end
	end
end

return M
