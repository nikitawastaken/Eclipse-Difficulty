---@module White Xmas
local M = {}
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy

local swat_1 = overkill_and_above and scripted_enemy.heavy_swat_1 or scripted_enemy.swat_1
local swat_2 = overkill_and_above and scripted_enemy.heavy_swat_2 or scripted_enemy.swat_2
local taser = scripted_enemy.taser_1
local medic = scripted_enemy.medic_1
local cloaker = scripted_enemy.cloaker
local elite_sniper = scripted_enemy.elite_sniper

local swats = { [swat_1] = 2, [swat_2] = 1 }

local specials_list = {
	[taser] = get_difficulty_group_specific_value({ 3, 2, 2 }),
	[medic] = get_difficulty_group_specific_value({ 0, 2, 2 }),
	[cloaker] = get_difficulty_group_specific_value({ 1, 2, 2 }),
	[elite_sniper] = get_difficulty_group_specific_value({ 0, 0, 1 }),
}
local specials = specials_list

local patches = {
	swat_chopper = {
		swat_spawns = table.set(100013, 100014),
		special_spawns = table.set(100015, 100016),
	},
}

M["levels/instances/unique/san_helicopter_4swat/world/world"] = function(result)
	local reworked_chopper = patches.swat_chopper

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if reworked_chopper.swat_spawns[id] then
			element.values.enemy_table = swats
		elseif reworked_chopper.special_spawns[id] then
			element.values.enemy_table = specials
		end
	end
end

return M
