local so_access = Eclipse.access_filter_presets
local swat_only = so_access.swat
local patches = {
	so_access_tweak = table.set(100003, 100013),
}

return {
	["levels/instances/unique/stash_c4_wall/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.so_access_tweak[element.id] then
				element.values.SO_access = swat_only -- only let SWATs plant the c4
			end
		end
	end,
}
