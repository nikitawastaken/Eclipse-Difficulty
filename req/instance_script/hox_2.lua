local patches = {
	breach_group = table.set(100012),
}

return {
	["levels/instances/unique/hox_fbi_ceiling_breach/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.breach_group[element.id] then
				element.values.interval = 40
			end
		end
	end,
}
