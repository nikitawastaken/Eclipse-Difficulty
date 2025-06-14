local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local flank_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_bulldozers,
}
local warehouse_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_shields,
}
local roof_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local dozer_in_the_container_amount = is_eclipse and 2 or 1
return {
	-- add one additional dozer in the container on Eclipse
	[107061] = {
		values = {
			amount = dozer_in_the_container_amount,
		},
	},
	-- disable turret logic
	[106492] = {
		values = {
			enabled = false,
		},
	},
	-- Spawn group delays
	[100132] = flank_spawn,
	[103919] = flank_spawn,
	[100007] = warehouse_spawn,
	[100131] = roof_spawn,
	[101008] = roof_spawn,
	[101153] = roof_spawn,
	[101473] = roof_spawn,
}
