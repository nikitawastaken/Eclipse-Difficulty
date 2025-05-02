local preferred = Eclipse.preferred

local disabled = {
	values = {
		enabled = false,
	},
}

local construction_spawn1 = {
	values = {
		interval = 15,
	},
}
local bridge_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local construction_spawn2 = {
	values = {
		interval = 30,
	},
	groups = preferred.no_bulldozers,
}

return {
	-- Disable hunt
	[101598] = disabled,
	-- Spawn point delays
	[101063] = construction_spawn1,
	[100979] = construction_spawn2,
	[100996] = construction_spawn2,
	[100997] = construction_spawn2,
	[100381] = bridge_spawn,
	[100532] = bridge_spawn,
	[100214] = bridge_spawn,
	[100228] = bridge_spawn,
	[100004] = bridge_spawn,
	[100005] = bridge_spawn,
	[100279] = bridge_spawn,
	[100280] = bridge_spawn,
	[100408] = bridge_spawn,
	[100409] = bridge_spawn,
	[100411] = bridge_spawn,
	[100412] = bridge_spawn,
	[100418] = bridge_spawn,
	[100434] = bridge_spawn,
	[100374] = bridge_spawn,
	[100225] = bridge_spawn,
	[100226] = bridge_spawn,
	[100467] = bridge_spawn,
	[100377] = bridge_spawn,
}
