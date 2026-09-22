local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("easy_above")

local swats = {
	[overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1] = 2,
	[overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_2] = 1,
}

local specials_list = {
	[scripted_enemy.taser_1] = get_difficulty_group_specific_value({ 3, 2, 2 }),
	[scripted_enemy.medic_1] = get_difficulty_group_specific_value({ 0, 2, 2 }),
	[scripted_enemy.cloaker] = get_difficulty_group_specific_value({ 0, 1, 2 }),
}
local specials = specials_list

local patches = {
	swat_chopper = {
		regular_spawns = table.set(100010, 100011, 100012),
		special_spawn = table.set(100013),
		filters_disable = table.set(100041, 100027, 100028),
		filters_normal_above = table.set(100026),
	},
	vent_spawn = table.set(100019),
}

return {
	["levels/instances/unique/sand/sand_helicopter_spawn_enemies/world/world"] = function(result)
		local heli_spawns = patches.swat_chopper

		for _, element in pairs(result.default.elements) do
			local id = element.id

			if heli_spawns.regular_spawns[id] then
				element.values.enemy_table = swats
			elseif heli_spawns.special_spawn[id] then
				element.values.enemy_table = specials
			elseif heli_spawns.filters_normal_above[id] then
				table.map_append(element.values, filter_normal_above)
			elseif heli_spawns.filters_disable[id] then
				table.map_append(element.values, filter_disable)
			end
		end
	end,
	["levels/instances/unique/auc/auc_security_room/world/world"] = function(result)
		for _, element in pairs(result.default.elements) do
			local id = element.id

			if patches.vent_spawn[id] then
				element.values.interval = 30
				element.values.groups = preferred.no_cops_agents_shields_bulldozers
			end
		end
	end,
}
