local so_access = Eclipse.access_filter_presets
local acrobatic_only = so_access.acrobatic
local patches = {
	so_access_tweak = table.set(100063),
}

return {
	["levels/instances/unique/mad/mad_anti_air/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.so_access_tweak[element.id] then
				element.values.SO_access = acrobatic_only -- only let SWATs, tasers and cloakers disable the anti air gun hack
			end
		end
	end,
	["levels/instances/unique/mad/mad_emp/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.so_access_tweak[element.id] then
				element.values.SO_access = acrobatic_only -- only let SWATs, tasers and cloakers disable the emp hack
			end
		end
	end,
}
