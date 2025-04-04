---@module Bomb: Dockyard
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local us_soldier_1 = scripted_enemy.soldier_2
local us_soldier_2 = scripted_enemy.soldier_3
local patches = {
	soldiers = {
		soldier_spawn = table.set(100003, 100005, 100007),
	},
}
local us_soldiers = { [us_soldier_1] = 3, [us_soldier_2] = 1 }

M["levels/instances/unique/crojob/veh_truck_police_anim_01_stage_02/world/world"] = function(result)
	local soldier_tweaks = patches.soldiers

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if soldier_tweaks.soldier_spawn[id] then -- replace SWATs with US Army response
			element.values.enemy_table = us_soldiers
		end
	end
end

return M
