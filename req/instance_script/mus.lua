---@module The Diamond
local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local green_security = scripted_enemy.green_security_4

local patches = {
	guard_suv = table.set(100017),
}

local security_room = patches.guard_suv

M["levels/instances/unique/mus_security_room/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if security_room[element.id] then
			element.values.enemy = green_security
		end
	end
end

return M
