---@module Diamond Heist

-- TODO: investigate crashes that may be related to GenSec red guards
do return end

local M = {}
local scripted_enemy = Eclipse.scripted_enemy
local gensec_security = scripted_enemy.gensec_2

local patches = {
	gensec_suv = table.set(100021),
}

local security_room = patches.gensec_suv

M["levels/instances/unique/dah/dah_security_room/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if security_room[element.id] then
			element.values.enemy = gensec_security
		end
	end
end

M["levels/instances/unique/dah/dah_security_room2/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if security_room[element.id] then
			element.values.enemy = gensec_security
		end
	end
end

M["levels/instances/unique/dah/dah_security_room3/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if security_room[element.id] then
			element.values.enemy = gensec_security
		end
	end
end

M["levels/instances/unique/dah/dah_security_room4/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if security_room[element.id] then
			element.values.enemy = gensec_security
		end
	end
end

M["levels/instances/unique/dah/dah_security_room5/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if security_room[element.id] then
			element.values.enemy = gensec_security
		end
	end
end

return M
