-- From http://www.cse.yorku.ca/~oz/hash.html
local function djb2_hash(str)
	local hash = 5381
	for c in str:gmatch(".") do
		hash = hash * 33 + string.byte(c)
	end

	return hash
end

local function init_spray_patterns(weapon_data)
	-- If the segments don't match there can be desync
	-- when switching between stances due to implementation details
	--
	-- May fix later idk
	weapon_data.default_pattern_kick = {
		{
			shots = 30, -- Amount of shots until we move to the next pattern
			min = { -1, -1 }, -- lerp min
			max = { 1, 1 }, -- lerp max
		},
		{
			final = true, -- Persist pattern kinda
			min = { -1, -1 }, -- lerp min
			max = { 1, 1 }, -- lerp max
		},
	}
	weapon_data.ads_pattern_kick = {
		{
			shots = 30,
			min = { 0, 0 },
			max = { 2, 2 },
		},
		{
			final = true,
			min = { -0.5, -0.5 },
			max = { 0.5, 0.5 },
		},
	}

	for id, data in pairs(weapon_data) do
		if type(data) == "table" and data.stats then
			-- string based hashing :speaking_head: :fire:
			data.pattern_seed = djb2_hash(id)
			data.ads_seed = djb2_hash(id .. "_ads")
		end
	end
end

return init_spray_patterns
