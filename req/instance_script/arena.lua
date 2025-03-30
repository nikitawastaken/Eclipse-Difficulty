local preferred = Eclipse.preferred
local patches = {
	double_door_group = table.set(100013),
	elevator_group = table.set(100013)
}

return {
	["levels/instances/unique/are_ps_double_doors/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.double_door_group[element.id] then
				element.values.interval = 15
			end
		end
	end,
	["levels/instances/unique/are_elevator/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.elevator_group[element.id] then
				element.groups = preferred.no_shields_bulldozers
				element.values.interval = 60
			end
		end
	end,
}