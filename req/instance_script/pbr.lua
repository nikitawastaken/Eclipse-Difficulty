local preferred = Eclipse.preferred
local patches = {
	--van_group = table.set(101504, 101413),
	starting_group = table.set(101418),
	cliff_group = table.set(101414),
}

return {
	["levels/instances/unique/pbr/pbr_mountain_surface/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.starting_group[element.id] then
				element.values.interval = 15
			elseif patches.cliff_group[element.id] then
				element.values.interval = 30
				element.values.groups = preferred.no_shields_bulldozers
			end
		end
	end,
}
