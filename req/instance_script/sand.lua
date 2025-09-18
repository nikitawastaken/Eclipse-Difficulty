---@module The Ukrainian Prisoner
local M = {}
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local scripted_enemy = Eclipse.scripted_enemy
local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local shield = scripted_enemy.shield
local elite_shield = scripted_enemy.elite_shield
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("easy_above")

local swats = { [swat_1] = 2, [swat_2] = 1 }
local specials_list_eclipse = { [taser] = 2, [medic] = 2, [cloaker] = 1 }
local specials_list_hard_ovk = { [taser] = 4, [medic] = 3, [cloaker] = 2 }
local specials_list_easy_normal = { [taser] = 3, [cloaker] = 1 }
local specials_1 = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse
local specials_2 = (normal or hard) and shield or elite_shield

local patches = {
	swat_chopper = {
		regular_spawns = table.set(100010, 100011, 100012),
		special_spawn = table.set(100013),
		filters_disable = table.set(100041, 100027, 100028),
		filters_normal_above = table.set(100026),
	},
	swat_squad = {
		swat_1 = table.set(100010),
		swat_2 = table.set(100011),
		swat_3 = table.set(100012),
		special_spawn_1 = table.set(100013),
		special_spawn_2 = table.set(100036),
		special_spawn_3 = table.set(100040),
		swat_squad = table.set(100029),
		filters_disable = table.set(100041, 100027, 100028),
		filters_normal_above = table.set(100026),
	},
}

M["levels/instances/unique/sand/sand_spawn_enemies/world/world"] = function(result)
	local squads = patches.swat_squad

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if squads.swat_squad[id] then
			element.values.on_executed = {
				{ id = 100010, delay = 0 },
				{ id = 100011, delay = 0 },
				{ id = 100012, delay = 0 },
				{ id = 100013, delay = 0 },
				{ id = 100036, delay = 0 },
				{ id = 100040, delay = 0 },
			}
		elseif squads.swat_1[id] then
			element.values.enemy_table = swats
			element.values.position = Vector3(100, -125, 0)
		elseif squads.swat_2[id] then
			element.values.enemy_table = swats
			element.values.position = Vector3(2, -125, 0)
		elseif squads.swat_3[id] then
			element.values.enemy_table = swats
			element.values.position = Vector3(-100, -125, 0)
		elseif squads.special_spawn_1[id] then
			element.values.enemy = specials_2
			element.values.position = Vector3(64, -64, 0)
		elseif squads.special_spawn_2[id] then
			element.values.enemy = specials_2
			element.values.position = Vector3(-63, 67, 0)
		elseif squads.special_spawn_3[id] then
			element.values.enemy_table = specials_1
			element.values.position = Vector3(1, -0, 0)
		elseif squads.filters_normal_above[id] then
			table.map_append(element.values, filter_normal_above)
		elseif squads.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		end
	end
end

M["levels/instances/unique/sand/sand_helicopter_spawn_enemies/world/world"] = function(result)
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
end

return M
