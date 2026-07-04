---@module Black Cat
local M = {}
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local scripted_enemy = Eclipse.scripted_enemy
local swat = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_sg = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local green_bulldozer = scripted_enemy.bulldozer_1
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_normal_above = Eclipse.utils.set_diff_groups("easy_above")

local swats = { [swat] = 2, [swat_sg] = 1 }

local specials_list = {
	[taser] = get_difficulty_group_specific_value({ 1, 2, 2 }),
	[medic] = get_difficulty_group_specific_value({ 0, 2, 2 }),
	[cloaker] = get_difficulty_group_specific_value({ 0, 2, 2 }),
	[green_bulldozer] = get_difficulty_group_specific_value({ 0, 1, 0 }),
	[elite_ben_bulldozer] = get_difficulty_group_specific_value({ 0, 0, 1 }),
}
local specials = specials_list

local patches = {
	swat_chopper = {
		regular_spawns = table.set(100010, 100011),
		special_spawn = table.set(100012, 100013),
		filters_disable = table.set(100041, 100027, 100028),
		filters_normal_above = table.set(100026),
	},
}

M["levels/instances/unique/chca/chca_helicopter_enemies/world/world"] = function(result)
	local heli_spawns = patches.swat_chopper

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if heli_spawns.regular_spawns[id] then
			element.values.enemy_table = swats
			element.values.participate_to_group_ai = true
		elseif heli_spawns.special_spawn[id] then
			element.values.enemy_table = specials
			element.values.participate_to_group_ai = true
		elseif heli_spawns.filters_normal_above[id] then
			table.map_append(element.values, filter_normal_above)
		elseif heli_spawns.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		end
	end
end

return M
