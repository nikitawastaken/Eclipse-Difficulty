local preferred = Eclipse.preferred
local agile_horizntal_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local agile_vertical_spawn = deep_clone(agile_horizntal_spawn)
agile_vertical_spawn.groups = preferred.no_cops_agents

return {
	-- Combine some navigation areas
	[101204] = { -- link_startup
		ai_area = {
			{ 97, 129, 130, 131, 132, 133 },
			{ 94, 134, 135 },
			{ 95, 35 },
			{ 150, 162 },
		},
	},
	-- New reinforce
	[103141] = {
		reinforce = {
			{
				name = "fountain",
				force = 3,
				position = Vector3(2600, 2850, -80),
			},
			{
				name = "what_a_nice_truck",
				force = 2,
				position = Vector3(-1415, 5375, -100),
			},
			{
				name = "what_a_nice_plane",
				force = 2,
				position = Vector3(-3225, 4200, 0),
			},
			{
				name = "entrance",
				force = 2,
				position = Vector3(-500, 2350, 0),
			},
		},
	},
	-- Disable auctioneer sniper objective on damage
	[105761] = {
		values = {
			interruptible = true,
			interrupt_dmg = 0.1,
			interrupt_dis = 3,
		},
	},
	-- Spawn group intervals
	[100716] = agile_horizntal_spawn, -- Funny elevator group with 2 dummies.
	[101931] = agile_vertical_spawn,
	[101656] = agile_vertical_spawn,
	[101918] = agile_vertical_spawn,
}
