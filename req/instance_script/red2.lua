---@module First World Bank
local M = {}
local scripted_enemy = Eclipse.scripted_enemy

local patches = {
	guard_suv = table.set(100030),
}

local security_room = patches.guard_suv

M["levels/instances/unique/red/red_camera_room/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if security_room[element.id] then
			element.values.enemy = scripted_enemy.green_security_4
		end
	end
end

return M
