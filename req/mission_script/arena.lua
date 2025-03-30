local preferred = Eclipse.preferred
local curly_spawn = {
	values = {
		interval = 15
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local reinforce_amount = {
	values = {
		amount = 3,
	},
}
local skylight_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local upper_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local garage_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local elevator_spawn = {
	values = {
		interval = 60,
	},
	groups = preferred.no_shields_bulldozers,
}
return {
	-- Add new reinforce
	[101577] = { 
		reinforce = {
			{
				name = "lobby",
				force = 4,
				position = Vector3(-300, 550, 0),
			}
		}
	},
	-- Remove a few vanilla reinforce points
	[102054] = disabled,
	[102057] = disabled,
	[102070] = disabled,
	-- Spawn group delays
	[100130] = curly_spawn,
	[102078] = curly_spawn,
	[101166] = skylight_spawn,
	[104406] = skylight_spawn,
	[104471] = upper_spawn,
	[100132] = upper_spawn,
	[100128] = window_spawn,
	[101309] = window_spawn,
	[101310] = garage_spawn,
	[102066] = garage_spawn,
	[100805] = elevator_spawn,
	[101555] = elevator_spawn,
}