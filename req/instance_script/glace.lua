---@module Green Bridge
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local light_swat = scripted_enemy.swat_1
local cloaker = scripted_enemy.cloaker
local taser = scripted_enemy.taser_1
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("normal_above")
local specials_spawns = { [taser] = 3, [cloaker] = 1 }

local patches = {
	swat_chopper = {
		regular_spawns = table.set(100014, 100015),
		special_spawns = table.set(100013, 100016),
		filters_disable = table.set(100008, 100010),
		filters_normal_above = table.set(100007),
	},
}

M["levels/instances/unique/glace/glace_helicopter_swat/world/world"] = function(result)
	local heli_spawns = patches.swat_chopper

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if heli_spawns.regular_spawns[id] then
			element.values.enemy = light_swat
		elseif heli_spawns.special_spawns[id] then
			element.values.enemy_table = specials_spawns
		elseif heli_spawns.filters_normal_above[id] then
			table.map_append(element.values, filters_normal_above)
		elseif heli_spawns.filters_disable[id] then
			table.map_append(element.values, filters_disable)
		end
	end
end

return M
