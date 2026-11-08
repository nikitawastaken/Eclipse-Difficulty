---@module The Diamond
local M = {}
local scripted_enemy = Eclipse.scripted_enemy

local patches = {
	guard_suv = table.set(100017),
	permament_heli = table.set(100038, 100040),
}

local security_room = patches.guard_suv
local no_heli_leave = patches.permament_heli

M["levels/instances/unique/mus_security_room/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if security_room[element.id] then
			element.values.enemy = scripted_enemy.green_security_4
		end
	end
end
M["levels/instances/unique/mus_helicopter/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if no_heli_leave[element.id] then
			element.values.enabled = false
		end
	end
end

return M
