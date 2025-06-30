---@module Prison Nightmare
local M = {}
local is_pro_job = Eclipse.utils.is_pro_job()
local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local headless_dozer_black = scripted_enemy.headless_bulldozer_1
local headless_dozer_white = scripted_enemy.headless_bulldozer_2
local headless_black_only = {
	headless_dozer_black,
}
local headless_tanks = is_eclipse and { [headless_dozer_black] = 3, [headless_dozer_white] = 1 } or headless_black_only

local patches = {
	headless_dozers = {
		dozer = table.set(100021, 100038, 100039, 100034),
	},
	bridge_group = table.set(100072, 100013, 100040, 100044, 100045, 100046, 100074),
	bridge_snipers = table.set(100049, 100068),
}

M["levels/instances/unique/help/escape/world/world"] = function(result)
	for _, element in ipairs(result.default.elements) do
		if patches.bridge_group[element.id] then
			element.values.interval = 30
		elseif patches.bridge_snipers[element.id] then
			element.values.enabled = is_pro_job
		end
	end
end

M["levels/instances/unique/help/help_king_cloaker_dozer/world/world"] = function(result)
	local dozer_event = patches.headless_dozers

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if dozer_event.dozer[id] then
			element.values.enemy_table = headless_tanks
		end
	end
end

return M
