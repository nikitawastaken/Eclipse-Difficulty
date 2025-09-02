local so_access = Eclipse.access_filter
local acrobatic = so_access.acrobatic
local patches = {
	so_access_tweak = table.set(100003, 100013),
	bain_warning = table.set(100012),
}

return {
	["levels/instances/unique/stash_c4_wall/world/world"] = function(result)
		for _, element in ipairs(result.default.elements) do
			if patches.so_access_tweak[element.id] then
				element.values.SO_access = acrobatic -- only let SWATs, tasers and cloakers plant the c4
			elseif patches.bain_warning[element.id] then
				element.values.trigger_times = 1 -- only one warning dialogue for the c4 breach from Bain
			end
		end
	end,
}
