-- From http://www.cse.yorku.ca/~oz/hash.html
local function djb2_hash(str)
	local hash = 5381
	for c in str:gmatch(".") do
		hash = hash * 33 + string.byte(c)
	end

	return hash
end

local function init_spray_patterns(weapon_data)
	for id, data in pairs(weapon_data) do
		if type(data) == "table" and data.stats then
			-- Only player weapons have a stats table
			data.pattern_kick = {
				{ -1, -1 }, -- lerp min
				{ 1, 1 }, -- lerp max
			}
			data.pattern_seed = djb2_hash(id)
		end
	end
end

return init_spray_patterns
