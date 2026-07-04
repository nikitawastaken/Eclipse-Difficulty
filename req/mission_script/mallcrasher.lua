local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local exclude_cop_agents_shields_dozers = {
	so_access_filter = so_access.acrobatic,
}
local skylight_far_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents,
}
local skylight_close_spawn = {
	values = {
		interval = 40,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local damage_calc_fix = {
	on_executed = {
		{ id = 300768, delay = 0 },
	},
}
return {
	-- Combine some navigation areas
	[300000] = {
		ai_area = {
			{ 1, 2, 5 },
			{ 47, 54, 67, 68, 70, 112 },
			{ 49, 61, 73 },
			{ 41, 52 },
			{ 29, 33, 42, 44 },
			{ 3, 4 },
			{ 45, 57, 60, 69 },
			{ 58, 65 },
			{ 76, 84 },
			{ 81, 72, 62 },
			{ 55, 111 },
			{ 86, 101, 104, 106, 108, 109 },
			{ 24, 39 },
			{ 90, 93, 94, 96 },
		},
		-- hide the floating traffic light
		on_executed = {
			{ id = 400022, delay = 0 },
		},
	},
	[300164] = { -- Add an unused spawngroup
		values = {
			spawn_groups = { 300313, 300314, 300281 },
		},
	},
	-- change up ATMs brandings
	[301403] = {
		on_executed = {
			{ id = 400021, delay = 1 },
		},
	},
	-- fix one of the cop cars not being hidden
	[302012] = {
		values = {
			unit_ids = {
				302026,
				302025,
				302023,
				302027,
				500501,
				500857,
				500851,
			},
		},
	},
	-- restore unused cop spawns
	[300163] = {
		on_executed = {
			{ id = 300258, delay = 0 },
			{ id = 300257, delay = 0 },
			{ id = 300256, delay = 0 },
		},
	},
	[300250] = {
		on_executed = {
			{ id = 300266, delay = 0 },
			{ id = 300265, delay = 0 },
		},
	},
	[300265] = {
		values = {
			position = Vector3(3495, 639, -400),
			rotation = Rotation(0, 0, 0),
		},
	},
	[300266] = {
		values = {
			position = Vector3(3495, 569, -400),
			rotation = Rotation(0, 0, 0),
		},
	},
	[300258] = {
		values = {
			position = Vector3(-4616, 6146, -398),
			rotation = Rotation(180, 0, 0),
		},
	},
	[300257] = {
		values = {
			position = Vector3(-4673, 6217, -398),
			rotation = Rotation(180, 0, 0),
		},
	},
	[300256] = {
		values = {
			position = Vector3(-4576, 6231, -398),
			rotation = Rotation(180, 0, 0),
		},
	},
	-- increase the amount of snipers on higher difficulties
	[302137] = {
		values = {
			amount = normal and 1 or hard and 2 or 3,
		},
	},
	-- fix two windows in Jewerly store not being counted as damage cost when destroyed
	[301333] = damage_calc_fix,
	[301332] = damage_calc_fix,
	-- disable the silly jump SOs for some enemies
	[301777] = exclude_cop_agents_shields_dozers,
	[302013] = exclude_cop_agents_shields_dozers,
	[302020] = exclude_cop_agents_shields_dozers,
	[302024] = exclude_cop_agents_shields_dozers,
	[302035] = exclude_cop_agents_shields_dozers,
	[302047] = exclude_cop_agents_shields_dozers,
	[302048] = exclude_cop_agents_shields_dozers,
	[302049] = exclude_cop_agents_shields_dozers,
	[302050] = exclude_cop_agents_shields_dozers,
	[302051] = exclude_cop_agents_shields_dozers,
	[302052] = exclude_cop_agents_shields_dozers,
	[302053] = exclude_cop_agents_shields_dozers,
	[302054] = exclude_cop_agents_shields_dozers,
	[302055] = exclude_cop_agents_shields_dozers,
	[302056] = exclude_cop_agents_shields_dozers,
	[302057] = exclude_cop_agents_shields_dozers,
	[302060] = exclude_cop_agents_shields_dozers,
	[302061] = exclude_cop_agents_shields_dozers,
	[302062] = exclude_cop_agents_shields_dozers,
	[302063] = exclude_cop_agents_shields_dozers,
	[302064] = exclude_cop_agents_shields_dozers,
	[302065] = exclude_cop_agents_shields_dozers,
	[302066] = exclude_cop_agents_shields_dozers,
	[302067] = exclude_cop_agents_shields_dozers,
	[302068] = exclude_cop_agents_shields_dozers,
	[302069] = exclude_cop_agents_shields_dozers,
	[302070] = exclude_cop_agents_shields_dozers,
	[302071] = exclude_cop_agents_shields_dozers,
	[302072] = exclude_cop_agents_shields_dozers,
	[302073] = exclude_cop_agents_shields_dozers,
	[302074] = exclude_cop_agents_shields_dozers,
	-- Spawn group intervals
	-- This heist got botched pretty hard when spawn group intervals were standardized.
	-- More or less what you'd expect, the skylight rappels have been slowed down drastically, but it's not a complete port of the old intervals.
	-- There are two different intervals for these rappels, the longer one is used for the groups that spawn directly in front of shops in straight lines, they cover a lot of playable space when they spawn.
	[301852] = skylight_far_spawn,
	[301847] = skylight_far_spawn,
	[302083] = skylight_close_spawn,
	[302084] = skylight_close_spawn,
}
