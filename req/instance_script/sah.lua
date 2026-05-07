---@module Shacklethorne Auction
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local diff_i = Eclipse.utils.difficulty_index()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local is_eclipse_pro = Eclipse.utils.is_eclipse_pro()
local bulldozer_1 = is_eclipse_pro and scripted_enemy.elite_bulldozer_1 or scripted_enemy.bulldozer_1
local bulldozer_2 = is_eclipse_pro and scripted_enemy.elite_bulldozer_2 or scripted_enemy.bulldozer_2
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1
local swat_sg = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2

local specials_list = {
	[taser] = get_difficulty_group_specific_value({ 1, 2, 3 }),
	[medic] = get_difficulty_group_specific_value({ 0, 1, 2 }),
	[cloaker] = get_difficulty_group_specific_value({ 0, 2, 3 }),
}

local dozer_list = {
	[bulldozer_1] = get_difficulty_group_specific_value({ 0, 1, 1 }),
	[bulldozer_2] = get_difficulty_group_specific_value({ 0, 1, 1 }),
	[taser] = get_difficulty_group_specific_value({ 1, 0, 0 }), -- this here is just for easy and normal
}

local filter_disable = Eclipse.utils.set_diff_groups("disable")
local filter_easy_above = Eclipse.utils.set_diff_groups("easy_above")
local patches = {
	swat_responders = {
		dozer_spawn = table.set(100041),
		special_spawn = table.set(100017),
		swat_spawn = table.set(100042),
		disable_turret = table.set(100071),
		filters_easy_above = table.set(100043),
		filters_disable = table.set(100061, 100062),
	},
}

M["levels/instances/unique/sah/sah_first_responders/world/world"] = function(result)
	local sah_responders = patches.swat_responders

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if sah_responders.filters_easy_above[id] then
			table.map_append(element.values, filter_easy_above)
			element.values.on_executed = {
				{ id = 100041, delay = 0 },
				{ id = 100017, delay = 0 },
				{ id = 100042, delay = 0 },
				{ id = 100042, delay = 3 },
			}
		elseif sah_responders.filters_disable[id] then
			table.map_append(element.values, filter_disable)
		elseif sah_responders.dozer_spawn[id] then
			element.values.enemy_table = dozer_list
		elseif sah_responders.special_spawn[id] then
			element.values.enemy_table = specials_list
		elseif sah_responders.swat_spawn[id] then
			element.values.enemy = swat_sg
		end
	end
end

return M
