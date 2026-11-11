---@module The Diamond
local M = {}

local scripted_enemy = Eclipse.scripted_enemy

local filter_overkill_above = Eclipse.utils.set_diff_groups("overkill_above")
local filter_disable = Eclipse.utils.set_diff_groups("disable")

local patches = {
	guard_suv = table.set(100017),
	permament_heli = table.set(100038, 100040),
	chamber_controller = {
		overkill_above = table.set(100342),
		filter_disable = table.set(100343),
	},
}

M["levels/instances/unique/mus_security_room/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if patches.guard_suv[element.id] then
			element.values.enemy = scripted_enemy.green_security_4
		end
	end
end

M["levels/instances/unique/mus_helicopter/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if patches.permament_heli[element.id] then
			element.values.enabled = false
		end
	end
end

M["levels/instances/unique/mus_chamber_controller/world/world"] = function(result)
	for _, element in pairs(result.default.elements) do
		if patches.chamber_controller.overkill_above[element.id] then
			table.map_append(element.values, filter_overkill_above)
		elseif patches.chamber_controller.filter_disable[element.id] then
			table.map_append(element.values, filter_disable)
		end
	end
end

return M
