---@module Buluc's Mansion
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local random_dozers = {
	scripted_enemy.bulldozer_1,
	scripted_enemy.bulldozer_2,
}
local random_elite_dozers = {
	scripted_enemy.elite_bulldozer_1,
	scripted_enemy.elite_bulldozer_2,
}
local bulldozers = is_eclipse_pro and random_elite_dozers or random_dozers
local specials = {
	[scripted_enemy.taser_1] = 3,
	[scripted_enemy.medic_1] = 2,
	[scripted_enemy.cloaker] = 1,
}
local security_enemy = "units/pd2_dlc_fex/characters/ene_thug_outdoor_fex/ene_thug_outdoor_fex"

local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_easy_above = Eclipse.utils.set_diff_groups("easy_above")

local patches = {
	mexican_heli = {
		dozer_spawns = table.set(100018),
		special_spawns = table.set(100019),
		swat_spawns = table.set(100027, 100031),
		filters_easy_above = table.set(100014),
		filters_disable = table.set(100015, 100016, 100017),
	},
	mayan_calendar = {
		filters_easy_above = table.set(100111),
	},
	security_room = {
		security_spawns = table.set(100030),
	},
}

M["levels/instances/unique/fex/fex_helicopter_backup/world/world"] = function(result)
	local dozer_heli = patches.mexican_heli

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if dozer_heli.filters_easy_above[id] then
			table.map_append(element.values, filter_easy_above)
		elseif dozer_heli.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		elseif dozer_heli.dozer_spawns[id] then
			element.values.enemy_table = bulldozers
		elseif dozer_heli.special_spawns[id] then
			element.values.enemy_table = specials
		elseif dozer_heli.swat_spawns[id] then
			element.values.enemy = scripted_enemy.heavy_swat_2
		end
	end
end

M["levels/instances/unique/fex/fex_mayan_codex/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		local id = element.id

		if patches.mayan_calendar.filters_easy_above[id] then
			table.map_append(element.values, filter_easy_above)
		end
	end
end

M["levels/instances/unique/fex/fex_security_room_right/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if patches.security_room.security_spawns[element.id] then
			element.values.enemy = security_enemy
		end
	end
end

M["levels/instances/unique/fex/fex_security_room_left/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if patches.security_room.security_spawns[element.id] then
			element.values.enemy = security_enemy
		end
	end
end

return M
