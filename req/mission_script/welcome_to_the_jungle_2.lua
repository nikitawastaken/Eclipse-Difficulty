local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local flank_spawn = {
	values = {
		interval = 15,
	},
}
local porch_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local skylight_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_group = {
	values = {
		interval = 90,
	},
}
return {
	-- Add power cut SO delay
	[100313] = {
		values = {
			base_delay = 30,
			base_delay_rand = 30,
		},
	},
	-- Disable a few reinforce near server rooms inside the house
	[101618] = disabled,
	[103415] = disabled,
	[103421] = disabled,
	-- Spawn group delays
	[100571] = flank_spawn,
	[100610] = flank_spawn,
	[103172] = porch_spawn,
	[103437] = porch_spawn,
	[100116] = skylight_spawn,
	[103249] = skylight_spawn,
	[103501] = cloaker_group,
	[103503] = cloaker_group,
	[103504] = cloaker_group,
	[103505] = cloaker_group,
	[103506] = cloaker_group,
}
