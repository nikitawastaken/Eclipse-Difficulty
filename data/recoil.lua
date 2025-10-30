-- From http://www.cse.yorku.ca/~oz/hash.html
local function djb2_hash(str)
	local hash = 5381
	for c in str:gmatch(".") do
		hash = hash * 33 + string.byte(c)
	end

	return hash
end

local function init_spray_patterns(weapon_data)
	weapon_data.default_pattern_kick = {
		{
			shots = 10, -- Amount of shots until we move to the next pattern
			min = { -1, -1 }, -- lerp min
			max = { 1, 1 }, -- lerp max
		},
		{
			final = true, -- Persist pattern kinda
			min = { -1, -1 }, -- lerp min
			max = { 1, 1 }, -- lerp max
		},
	}

	for id, data in pairs(weapon_data) do
		if type(data) == "table" and data.stats then
			data.pattern_seed = djb2_hash(id)
		end
	end
end

return init_spray_patterns
