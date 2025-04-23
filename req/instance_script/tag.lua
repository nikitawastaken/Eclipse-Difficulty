---@module Brekin Fed
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local fbi_teacher = scripted_enemy.fbi_1

local patches = {
	riker_is_gone = table.set(100087),
}

M["levels/instances/unique/tag/tag_training/world/world"] = function(result)
	local riker_replacment = patches.riker_is_gone

	for _, element in pairs(result.default.elements) do
		local id = element.id

		if riker_replacment[id] then
			element.values.enemy = fbi_teacher
		end
	end
end

return M
